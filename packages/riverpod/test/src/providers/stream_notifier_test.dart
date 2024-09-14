// ignore_for_file: avoid_types_on_closure_parameters, invalid_use_of_protected_member

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart' show UnmountedRefException;
import 'package:riverpod/src/providers/stream_notifier.dart'
    show $StreamNotifier;
import 'package:test/test.dart';

import '../matrix.dart';
import '../utils.dart';

void main() {
  test('Throws if using notifier properties in its constructor', () {
    final errors = captureErrors([
      () => CtorNotifier().state,
      () => CtorNotifier().state = const AsyncData(42),
      () => CtorNotifier().future,
      () => CtorNotifier().ref,
      () => FamilyCtorNotifier().state,
      () => FamilyCtorNotifier().state = const AsyncData(42),
      () => FamilyCtorNotifier().future,
      () => FamilyCtorNotifier().ref,
    ]);
  });

  streamNotifierProviderFactory.createGroup((factory) {
    test('closes the StreamSubscription upon disposing the provider', () async {
      final onCancel = OnCancelMock();
      final container = ProviderContainer.test();
      final cancelCompleter = Completer<void>.sync();
      final provider = factory.simpleTestProvider<int>((ref) {
        final controller = StreamController<int>();
        ref.onDispose(() {
          controller.addError(42);
          controller.close();
        });

        return DelegatingStream(
          controller.stream,
          onSubscriptionCancel: () {
            onCancel.call();
            cancelCompleter.complete();
          },
        );
      });

      container.listen(provider, (previous, next) {});
      final future = container.read(provider.future);

      container.dispose();

      verifyZeroInteractions(onCancel);

      await expectLater(future, throwsA(42));
      await cancelCompleter.future;

      verifyOnly(onCancel, onCancel());
    });

    test('Pauses the Stream when the provider is paused', () {
      final streamController = StreamController<int>();
      addTearDown(streamController.close);

      final onSubPause = OnPause();
      final onSubResume = OnResume();

      final container = ProviderContainer.test();

      final provider = factory.simpleTestProvider(
        (ref) {
          return DelegatingStream(
            streamController.stream,
            onSubscriptionPause: onSubPause.call,
            onSubscriptionResume: onSubResume.call,
          );
        },
      );

      final sub = container.listen(provider, (previous, next) {});

      verifyZeroInteractions(onSubPause);
      verifyZeroInteractions(onSubResume);

      sub.pause();

      verifyOnly(onSubPause, onSubPause());
      verifyZeroInteractions(onSubResume);

      sub.resume();

      verifyOnly(onSubResume, onSubResume());
      verifyNoMoreInteractions(onSubPause);
    });

    test('Cannot share a Notifier instance between providers ', () {
      final container = ProviderContainer.test();
      final notifier = factory.deferredNotifier((ref) => Stream.value(0));

      final provider = factory.provider<int>(() => notifier);
      final provider2 = factory.provider<int>(() => notifier);

      container.read(provider);

      expect(
        container.read(provider2),
        isA<AsyncError<int>>(),
      );
    });

    test('Cannot properties inside onDispose', () {
      final container = ProviderContainer.test();
      late TestStreamNotifier<int> notifier;
      late List<Object?> errors;
      final provider = factory.simpleTestProvider((ref) {
        ref.onDispose(() {
          errors = captureErrors([
            () => notifier.state,
            () => notifier.state = const AsyncData(42),
            () => notifier.future,
          ]);
        });
        return Stream.value(0);
      });

      container.listen(provider.notifier, (prev, next) {});
      notifier = container.read(provider.notifier);

      container.dispose();

      expect(
        errors,
        everyElement(isA<UnmountedRefException>()),
      );
    });

    test('Using the notifier after dispose throws', () {
      final container = ProviderContainer.test();
      final provider = factory.simpleTestProvider((ref) => Stream.value(0));

      container.listen(provider.notifier, (prev, next) {});
      final notifier = container.read(provider.notifier);

      container.dispose();

      expect(notifier.ref.mounted, false);
      expect(
        () => notifier.state,
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => notifier.future,
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => notifier.state = const AsyncData(42),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => notifier.update((p1) => 42),
        throwsA(isA<UnmountedRefException>()),
      );
    });

    group('supports AsyncValue transition', () {
      test(
          'performs seamless copyWithPrevious if triggered by ref.invalidate/ref.refresh',
          () async {
        final container = ProviderContainer.test();
        var count = 0;
        final provider = factory.simpleTestProvider(
          (ref) => Stream.value(count++),
        );

        container.listen(provider, (previous, next) {});

        await expectLater(container.read(provider.future), completion(0));
        expect(container.read(provider), const AsyncData(0));

        expect(
          container.refresh(provider),
          const AsyncLoading<int>().copyWithPrevious(const AsyncData(0)),
        );

        await expectLater(container.read(provider.future), completion(1));
        expect(container.read(provider), const AsyncData(1));

        container.invalidate(provider);

        expect(
          container.read(provider),
          const AsyncLoading<int>().copyWithPrevious(const AsyncData(1)),
        );
        await expectLater(container.read(provider.future), completion(2));
        expect(container.read(provider), const AsyncData(2));
      });

      test(
          'performs seamless:false copyWithPrevious on `state = AsyncLoading()`',
          () async {
        final container = ProviderContainer.test();
        final provider = factory.simpleTestProvider((ref) => Stream.value(0));

        final sub = container.listen(provider.notifier, (previous, next) {});

        await expectLater(container.read(provider.future), completion(0));
        expect(container.read(provider), const AsyncData(0));

        sub.read().state = const AsyncLoading<int>();

        expect(
          sub.read().state,
          const AsyncLoading<int>()
              .copyWithPrevious(const AsyncData(0), isRefresh: false),
        );
      });

      test(
          'performs seamless:false copyWithPrevious if triggered by a dependency change',
          () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        final provider = factory.simpleTestProvider(
          (ref) => Stream.value(ref.watch(dep)),
        );

        container.listen(provider, (previous, next) {});

        await expectLater(container.read(provider.future), completion(0));
        expect(container.read(provider), const AsyncData(0));

        container.read(dep.notifier).state++;
        expect(
          container.read(provider),
          const AsyncLoading<int>()
              .copyWithPrevious(const AsyncData(0), isRefresh: false),
        );

        await expectLater(container.read(provider.future), completion(1));
        expect(container.read(provider), const AsyncData(1));
      });

      test(
          'performs seamless:false copyWithPrevious if both triggered by a dependency change and ref.refresh',
          () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        final provider = factory.simpleTestProvider(
          (ref) => Stream.value(ref.watch(dep)),
        );

        container.listen(provider, (previous, next) {});

        await expectLater(container.read(provider.future), completion(0));
        expect(container.read(provider), const AsyncData(0));

        container.read(dep.notifier).state++;
        expect(
          container.refresh(provider),
          const AsyncLoading<int>()
              .copyWithPrevious(const AsyncData(0), isRefresh: false),
        );

        await expectLater(container.read(provider.future), completion(1));
        expect(container.read(provider), const AsyncData(1));
      });
    });

    test('does not notify listeners when refreshed during loading', () async {
      final provider = factory.simpleTestProvider((ref) => Stream.value(0));
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncLoading()));

      container.refresh(provider);

      await container.read(provider.future);

      verifyOnly(
        listener,
        listener(const AsyncLoading(), const AsyncData(0)),
      );
    });

    test('supports listenSelf', () {
      final listener = Listener<AsyncValue<int>>();
      final onError = ErrorListener();
      final provider = factory.simpleTestProvider<int>((ref) {
        ref.listenSelf(listener.call, onError: onError.call);
        Error.throwWithStackTrace(42, StackTrace.empty);
      });
      final container = ProviderContainer.test();

      container.listen(provider, (previous, next) {});

      verifyOnly(
        listener,
        listener(null, const AsyncError<int>(42, StackTrace.empty)),
      );
      verifyZeroInteractions(onError);

      container.read(provider.notifier).state = const AsyncData(42);

      verifyNoMoreInteractions(onError);
      verifyOnly(
        listener,
        listener(
          const AsyncError<int>(42, StackTrace.empty),
          const AsyncData<int>(42),
        ),
      );
    });

    test(
        'converts StreamNotifier.build into an AsyncData if the future completes',
        () async {
      final provider = factory.simpleTestProvider((ref) => Stream.value(0));
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncLoading()));
      expect(
        container.read(provider.notifier).state,
        const AsyncLoading<int>(),
      );

      expect(await container.read(provider.future), 0);

      verifyOnly(
        listener,
        listener(const AsyncLoading(), const AsyncData(0)),
      );
      expect(
        container.read(provider.notifier).state,
        const AsyncData<int>(0),
      );
    });

    test('converts StreamNotifier.build into an AsyncError if the future fails',
        () async {
      final provider = factory.simpleTestProvider<int>(
        (ref) => Stream.error(0, StackTrace.empty),
      );
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncLoading()));
      expect(
        container.read(provider.notifier).state,
        const AsyncLoading<int>(),
      );

      await expectLater(container.read(provider.future), throwsA(0));

      verifyOnly(
        listener,
        listener(const AsyncLoading(), const AsyncError(0, StackTrace.empty)),
      );
      expect(
        container.read(provider.notifier).state,
        const AsyncError<int>(0, StackTrace.empty),
      );
    });

    test('supports cases where the StreamNotifier constructor throws',
        () async {
      final provider = factory.provider<int>(
        () => Error.throwWithStackTrace(0, StackTrace.empty),
      );
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(
        listener,
        listener(null, const AsyncError(0, StackTrace.empty)),
      );
      expect(
        () => container.read(provider.notifier),
        throwsA(0),
      );

      await expectLater(container.read(provider.future), throwsA(0));
    });

    test(
        'synchronously emits AsyncError if StreamNotifier.build throws synchronously',
        () async {
      final provider = factory.simpleTestProvider<int>(
        (ref) => Error.throwWithStackTrace(42, StackTrace.empty),
      );
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(
        listener,
        listener(null, const AsyncError(42, StackTrace.empty)),
      );
      expect(
        container.read(provider.notifier).state,
        const AsyncError<int>(42, StackTrace.empty),
      );
      await expectLater(container.read(provider.future), throwsA(42));
    });

    test(
        'stops listening to the previous future data when the provider rebuilds',
        () async {
      final container = ProviderContainer.test();
      final dep = StateProvider((ref) => 0);
      final completers = {
        0: Completer<int>.sync(),
        1: Completer<int>.sync(),
      };
      final provider = factory.simpleTestProvider<int>(
        (ref) => Stream.fromFuture(completers[ref.watch(dep)]!.future),
      );
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener.call);

      expect(
        container.read(provider.future),
        completion(21),
        reason: 'The provider rebuilt while the future was still pending, '
            'so .future should resolve with the next value',
      );
      verifyZeroInteractions(listener);
      expect(container.read(provider), const AsyncLoading<int>());

      container.read(dep.notifier).state++;
      completers[0]!.complete(42);

      verifyZeroInteractions(listener);

      expect(container.read(provider.future), completion(21));
      expect(container.read(provider), const AsyncLoading<int>());

      completers[1]!.complete(21);

      expect(await container.read(provider.future), 21);
      expect(container.read(provider), const AsyncData<int>(21));
    });

    test(
        'stops listening to the previous future error when the provider rebuilds',
        () async {
      final container = ProviderContainer.test();
      final dep = StateProvider((ref) => 0);
      final completers = {
        0: Completer<int>.sync(),
        1: Completer<int>.sync(),
      };
      final provider = factory.simpleTestProvider<int>(
        (ref) => Stream.fromFuture(completers[ref.watch(dep)]!.future),
      );
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener.call);

      expect(
        container.read(provider.future),
        throwsA(21),
        reason: 'The provider rebuilt while the future was still pending, '
            'so .future should resolve with the next value',
      );
      verifyZeroInteractions(listener);
      expect(container.read(provider), const AsyncLoading<int>());

      container.read(dep.notifier).state++;
      completers[0]!.completeError(42, StackTrace.empty);

      verifyZeroInteractions(listener);

      expect(container.read(provider.future), throwsA(21));
      expect(container.read(provider), const AsyncLoading<int>());

      completers[1]!.completeError(21, StackTrace.empty);

      await expectLater(container.read(provider.future), throwsA(21));
      expect(
        container.read(provider),
        const AsyncError<int>(21, StackTrace.empty),
      );
    });

    group('StreamNotifier.state', () {
      test(
          'when manually modifying the state, the new exposed value contains the previous state when possible',
          () async {
        final provider = factory.simpleTestProvider<int>(
          (ref) => Stream.value(0),
        );
        final container = ProviderContainer.test();

        final sub = container.listen(provider.notifier, (previous, next) {});
        await container.read(provider.future);

        // ignore: prefer_const_constructors, not using `const` as we voluntarily break identity to test `identical`
        final newState = AsyncData(84);
        // ignore: prefer_const_constructors, not using `const` as we voluntarily break identity to test `identical`
        final newLoading = AsyncLoading<int>();
        // ignore: prefer_const_constructors, not using `const` as we voluntarily break identity to test `identical`
        final newError = AsyncError<int>(84, StackTrace.empty);

        sub.read().state = newState;

        expect(sub.read().state, same(newState));

        sub.read().state = newLoading;

        expect(
          sub.read().state,
          const AsyncLoading<int>()
              .copyWithPrevious(newState, isRefresh: false),
        );

        sub.read().state = newError;

        expect(
          sub.read().state,
          newError.copyWithPrevious(
            const AsyncLoading<int>()
                .copyWithPrevious(newState, isRefresh: false),
          ),
        );
      });

      test('can be read inside build', () {
        final dep = StateProvider((ref) => 0);
        late AsyncValue<int> state;
        final provider = factory.provider<int>(
          () {
            late TestStreamNotifier<int> notifier;
            return notifier = factory.deferredNotifier<int>(
              (ref) {
                state = notifier.state;
                return Stream.value(ref.watch(dep));
              },
            );
          },
        );
        final container = ProviderContainer.test();

        container.listen(provider, (previous, next) {});

        expect(state, const AsyncLoading<int>());

        container.read(provider.notifier).state = const AsyncData(42);
        container.refresh(provider);

        expect(
          state,
          const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)),
        );
      });

      test('notifies listeners when the setter is called', () async {
        final provider = factory.simpleTestProvider((ref) => Stream.value(0));
        final container = ProviderContainer.test();
        final listener = Listener<AsyncValue<int>>();

        // Skip the loading
        await container.listen(provider.future, (previous, next) {}).read();

        container.listen(provider, listener.call);

        verifyZeroInteractions(listener);

        container.read(provider.notifier).state = const AsyncData(42);

        verifyOnly(
          listener,
          listener(const AsyncData(0), const AsyncData(42)),
        );
      });
    });

    group('StreamNotifier.future', () {
      test(
          'when disposed during loading, resolves with the content of StreamNotifier.build',
          () async {
        final container = ProviderContainer.test();
        final completer = Completer<int>.sync();
        final provider = factory.simpleTestProvider<int>(
          (ref) => Stream.fromFuture(completer.future),
        );

        final future = container.read(provider.future);
        container.dispose();

        completer.complete(42);

        await expectLater(future, completion(42));
      });

      test(
          'when disposed during loading, resolves with the error of StreamNotifier.build',
          () async {
        final container = ProviderContainer.test();
        final completer = Completer<int>.sync();
        final provider = factory.simpleTestProvider<int>(
          (ref) => Stream.fromFuture(completer.future),
        );

        final future = container.read(provider.future);

        container.dispose();

        completer.completeError(42);

        await expectLater(future, throwsA(42));
      });

      test(
        'going data > loading while the future is still pending. '
        'Resolves with last future result',
        () async {
          final container = ProviderContainer.test();
          final completer = Completer<int>.sync();
          final provider = factory.simpleTestProvider<int>(
            (ref) => Stream.fromFuture(completer.future),
          );

          container.read(provider);
          container.read(provider.notifier).state = const AsyncData(42);
          container.read(provider.notifier).state = const AsyncLoading<int>();

          final future = container.read(provider.future);

          container.dispose();

          completer.complete(42);

          await expectLater(future, completion(42));
        },
      );

      test('if going back to loading after future resolved, throws StateError',
          () async {
        final container = ProviderContainer.test();
        final completer = Completer<int>.sync();
        final provider = factory.simpleTestProvider<int>(
          (ref) => Stream.fromFuture(completer.future),
        );

        container.listen(provider, (previous, next) {});

        completer.complete(42);

        container.read(provider.notifier).state = const AsyncData(42);
        container.read(provider.notifier).state = const AsyncLoading<int>();

        final future = container.read(provider.future);

        container.dispose();

        await expectLater(future, throwsStateError);
      });

      test(
          'resolves with the new state if StreamNotifier.state is modified during loading',
          () async {
        final container = ProviderContainer.test();
        final completer = Completer<int>.sync();
        final provider = factory.simpleTestProvider<int>(
          (ref) => Stream.fromFuture(completer.future),
        );
        final listener = Listener<Future<int>>();

        final sub = container.listen(provider.notifier, (previous, next) {});
        container.listen(provider.future, listener.call);

        expect(sub.read().future, completion(21));

        sub.read().state = const AsyncData(21);

        completer.complete(42);

        expect(sub.read().future, completion(42));
        final capture =
            verifyOnly(listener, listener(captureAny, captureAny)).captured;

        expect(capture.length, 2);
        expect(capture.first, completion(21));
        expect(capture.last, completion(42));
      });

      test('resolves with the new state when notifier.state is changed',
          () async {
        final container = ProviderContainer.test();
        final provider = factory.simpleTestProvider<int>(
          (ref) => Stream.value(0),
        );
        final listener = Listener<Future<int>>();

        final sub = container.listen(provider.notifier, (previous, next) {});
        container.listen(
          provider.future,
          listener.call,
          fireImmediately: true,
        );

        await expectLater(sub.read().future, completion(0));
        verifyOnly(
          listener,
          listener(argThat(equals(null)), argThat(completion(0))),
        );

        sub.read().state = const AsyncData(1);

        await expectLater(sub.read().future, completion(1));
      });

      test('returns a Future identical to that of .future', () {
        final listener = OnBuildMock();
        final dep = StateProvider((ref) => 0);
        final provider = factory.simpleTestProvider<int>(
          (ref) {
            listener();
            return Stream.value(ref.watch(dep));
          },
        );
        final container = ProviderContainer.test();

        container.listen(provider.notifier, (previous, next) {});
        final notifier = container.read(provider.notifier);

        expect(notifier.future, same(container.read(provider.future)));
      });
    });

    group('StreamNotifierProvider.notifier', () {
      test(
          'Notifies listeners whenever `build` is re-executed, due to recreating a new notifier.',
          () async {
        final notifierListener = Listener<$StreamNotifier<int>>();
        final dep = StateProvider((ref) => 0);
        final provider = factory.provider<int>(() {
          return factory.deferredNotifier(
            (ref) => Stream.value(ref.watch(dep)),
          );
        });
        final container = ProviderContainer.test();

        final sub = container.listen(provider.notifier, notifierListener.call);
        final initialNotifier = sub.read();

        expect(initialNotifier.ref.mounted, true);

        // Skip the loading
        await container.read(provider.future);
        verifyNoMoreInteractions(notifierListener);

        container.refresh(provider);
        final newNotifier = sub.read();

        expect(newNotifier, isNot(same(initialNotifier)));
        verifyOnly(
          notifierListener,
          notifierListener(initialNotifier, newNotifier),
        ).called(1);
        expect(initialNotifier.ref.mounted, false);
        expect(newNotifier.ref.mounted, true);
      });
    });

    test(
        'Can override StreamNotifier.updateShouldNotify to change the default filter logic',
        () async {
      final provider = factory.simpleTestProvider<Equal<int>>(
        (ref) => Stream.value(Equal(42)),
        updateShouldNotify: (a, b) => a != b,
      );
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<Equal<int>>>();

      // Skip the loading
      await container.listen(provider.future, (previous, next) {}).read();

      container.listen(provider, listener.call);
      final notifier = container.read(provider.notifier);

      // voluntarily assigning the same value
      final self = notifier.state;
      notifier.state = self;

      verifyZeroInteractions(listener);

      notifier.state = AsyncData(Equal(42));

      verifyZeroInteractions(listener);

      notifier.state = AsyncData(Equal(21));

      verifyOnly(
        listener,
        listener(AsyncData(Equal(42)), AsyncData(Equal(21))),
      );
    });

    group('AsyncNotifier.update', () {
      test('passes in the latest state', () async {
        final container = ProviderContainer.test();
        final provider = factory.simpleTestProvider<int>(
          (ref) => Stream.value(0),
        );

        // Skip the loading
        await container.listen(provider.future, (previous, next) {}).read();

        final sub = container.listen(provider.notifier, (prev, next) {});

        expect(
          container.read(provider),
          const AsyncData<int>(0),
        );

        await expectLater(
          sub.read().update((prev) => prev + 1),
          completion(1),
        );
        await expectLater(
          sub.read().future,
          completion(1),
        );
        await expectLater(
          sub.read().update((prev) => prev + 1),
          completion(2),
        );
      });

      test('can specify onError to handle error scenario', () async {
        final container = ProviderContainer.test();
        final provider = factory.simpleTestProvider<int>(
          (ref) => Error.throwWithStackTrace(42, StackTrace.empty),
        );
        var callCount = 0;
        Object? actualErr;
        Object? actualStack;

        final sub = container.listen(provider.notifier, (prev, next) {});

        expect(
          container.read(provider),
          const AsyncError<int>(42, StackTrace.empty),
        );

        await expectLater(
          sub.read().update(
            (prev) {
              callCount++;
              return prev;
            },
            onError: (err, stack) {
              actualErr = err;
              actualStack = stack;
              return 21;
            },
          ),
          completion(21),
        );
        expect(callCount, 0);
        expect(actualErr, 42);
        expect(actualStack, StackTrace.empty);
        expect(container.read(provider), const AsyncData(21));
      });

      test('executes immediately with current state if a state is available',
          () async {
        final container = ProviderContainer.test();
        final provider = factory.simpleTestProvider<int>(
          (ref) => Stream.value(1),
        );

        // Skip the loading
        await container.listen(provider.future, (previous, next) {}).read();

        final sub = container.listen(provider.notifier, (prev, next) {});

        expect(container.read(provider), const AsyncData(1));

        await expectLater(
          sub.read().update((prev) => prev + 1),
          completion(2),
        );
        expect(container.read(provider), const AsyncData(2));
      });

      test('executes immediately with current state if an error is available',
          () async {
        final container = ProviderContainer.test();
        final provider = factory.simpleTestProvider<int>(
          (ref) => Error.throwWithStackTrace(42, StackTrace.empty),
        );
        var callCount = 0;

        final sub = container.listen(provider.notifier, (prev, next) {});

        expect(
          container.read(provider),
          const AsyncError<int>(42, StackTrace.empty),
        );

        await expectLater(
          sub.read().update((prev) {
            callCount++;
            return prev + 1;
          }),
          throwsA(42),
        );

        expect(callCount, 0);
        expect(
          container.read(provider),
          const AsyncError<int>(42, StackTrace.empty),
        );
      });

      test('awaits the future resolution if in loading state', () async {
        final container = ProviderContainer.test();
        final provider = factory.simpleTestProvider<int>(
          (ref) => Stream.value(42),
        );

        final sub = container.listen(provider.notifier, (prev, next) {});

        expect(container.read(provider), const AsyncLoading<int>());

        await expectLater(
          sub.read().update((prev) => prev + 1),
          completion(43),
        );
        expect(container.read(provider), const AsyncData(43));
      });
    });
  });

  test('supports overrideWith', () async {
    final provider = StreamNotifierProvider<DeferredStreamNotifier<int>, int>(
      () => DeferredStreamNotifier((ref) => Stream.value(0)),
    );
    final autoDispose =
        StreamNotifierProvider.autoDispose<DeferredStreamNotifier<int>, int>(
      () => DeferredStreamNotifier((ref) => Stream.value(0)),
    );
    final container = ProviderContainer.test(
      overrides: [
        provider.overrideWith(
          () => DeferredStreamNotifier((ref) => Stream.value(42)),
        ),
        autoDispose.overrideWith(
          () => DeferredStreamNotifier((ref) => Stream.value(84)),
        ),
      ],
    );

    // Skip the loading
    await container.listen(provider.future, (previous, next) {}).read();
    await container.listen(autoDispose.future, (previous, next) {}).read();

    expect(container.read(provider).value, 42);
    expect(container.read(autoDispose).value, 84);
  });

  test('supports family overrideWith', () async {
    final family = StreamNotifierProvider.family<
        DeferredFamilyStreamNotifier<int>, int, int>(
      () => DeferredFamilyStreamNotifier<int>((ref) => Stream.value(0)),
    );
    final autoDisposeFamily = StreamNotifierProvider.autoDispose
        .family<DeferredFamilyStreamNotifier<int>, int, int>(
      () => DeferredFamilyStreamNotifier<int>((ref) => Stream.value(0)),
    );
    final container = ProviderContainer.test(
      overrides: [
        family.overrideWith(
          () => DeferredFamilyStreamNotifier<int>((ref) => Stream.value(42)),
        ),
        autoDisposeFamily.overrideWith(
          () => DeferredFamilyStreamNotifier<int>(
            (ref) => Stream.value(84),
          ),
        ),
      ],
    );

    // Skip the loading
    await container.listen(family(10).future, (previous, next) {}).read();
    await container
        .listen(autoDisposeFamily(10).future, (previous, next) {})
        .read();

    expect(container.read(family(10)).value, 42);
    expect(container.read(autoDisposeFamily(10)).value, 84);
  });

  group('AutoDispose variant', () {
    test('can watch autoDispose providers', () async {
      final dep = Provider.autoDispose((ref) => 0);
      final provider =
          StreamNotifierProvider.autoDispose<DeferredStreamNotifier<int>, int>(
        () => DeferredStreamNotifier((ref) {
          return Stream.value(ref.watch(dep));
        }),
      );
      final container = ProviderContainer.test();

      // Skip the loading
      await container.listen(provider.future, (previous, next) {}).read();

      expect(container.read(provider), const AsyncData(0));
    });
  });

  group('modifiers', () {
    void canBeAssignedToRefreshable<T>(
      Refreshable<T> provider,
    ) {}

    void canBeAssignedToProviderListenable<T>(
      ProviderListenable<T> provider,
    ) {}

    test('provider', () {
      final provider = StreamNotifierProvider<DeferredStreamNotifier<int>, int>(
        () => DeferredStreamNotifier((ref) => Stream.value(0)),
      );

      provider.select((AsyncValue<int> value) => 0);
      provider.selectAsync((int value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<int>>(provider);
      canBeAssignedToRefreshable<AsyncValue<int>>(provider);

      canBeAssignedToProviderListenable<Future<int>>(provider.future);
      canBeAssignedToRefreshable<Future<int>>(provider.future);

      canBeAssignedToProviderListenable<StreamNotifier<int>>(provider.notifier);
      canBeAssignedToRefreshable<StreamNotifier<int>>(provider.notifier);
    });

    test('autoDispose', () {
      final autoDispose =
          StreamNotifierProvider.autoDispose<DeferredStreamNotifier<int>, int>(
        () => DeferredStreamNotifier((ref) => Stream.value(0)),
      );

      autoDispose.select((AsyncValue<int> value) => 0);
      autoDispose.selectAsync((int value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<int>>(autoDispose);
      canBeAssignedToRefreshable<AsyncValue<int>>(autoDispose);

      canBeAssignedToProviderListenable<Future<int>>(autoDispose.future);
      canBeAssignedToRefreshable<Future<int>>(autoDispose.future);

      canBeAssignedToProviderListenable<StreamNotifier<int>>(
        autoDispose.notifier,
      );
      canBeAssignedToRefreshable<StreamNotifier<int>>(
        autoDispose.notifier,
      );
    });

    test('family', () {
      final family = StreamNotifierProvider.family<
          DeferredFamilyStreamNotifier<String>, String, int>(
        () => DeferredFamilyStreamNotifier((ref) => Stream.value('0')),
      );

      family(0).select((AsyncValue<String> value) => 0);
      family(0).selectAsync((String value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<String>>(family(0));
      canBeAssignedToRefreshable<AsyncValue<String>>(family(0));

      canBeAssignedToProviderListenable<Future<String>>(family(0).future);
      canBeAssignedToRefreshable<Future<String>>(family(0).future);

      canBeAssignedToProviderListenable<FamilyStreamNotifier<String, int>>(
        family(0).notifier,
      );
      canBeAssignedToRefreshable<FamilyStreamNotifier<String, int>>(
        family(0).notifier,
      );
    });

    test('autoDisposeFamily', () {
      expect(
        StreamNotifierProvider.autoDispose.family,
        same(StreamNotifierProvider.family.autoDispose),
      );

      final autoDisposeFamily = StreamNotifierProvider.autoDispose
          .family<DeferredFamilyStreamNotifier<String>, String, int>(
        () => DeferredFamilyStreamNotifier((ref) => Stream.value('0')),
      );

      autoDisposeFamily(0).select((AsyncValue<String> value) => 0);
      autoDisposeFamily(0).selectAsync((String value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<String>>(
        autoDisposeFamily(0),
      );
      canBeAssignedToRefreshable<AsyncValue<String>>(
        autoDisposeFamily(0),
      );

      canBeAssignedToProviderListenable<Future<String>>(
        autoDisposeFamily(0).future,
      );
      canBeAssignedToRefreshable<Future<String>>(
        autoDisposeFamily(0).future,
      );

      canBeAssignedToProviderListenable<FamilyStreamNotifier<String, int>>(
        autoDisposeFamily(0).notifier,
      );
      canBeAssignedToRefreshable<FamilyStreamNotifier<String, int>>(
        autoDisposeFamily(0).notifier,
      );
    });
  });
}

@immutable
class Equal<T> {
  // ignore: prefer_const_constructors_in_immutables
  Equal(this.value);

  final T value;

  @override
  bool operator ==(Object other) => other is Equal<T> && other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value);
}

class CtorNotifier extends StreamNotifier<int> {
  @override
  Stream<int> build() => Stream.value(0);
}

class FamilyCtorNotifier extends FamilyStreamNotifier<int, int> {
  @override
  Stream<int> build(int arg) => Stream.value(0);
}
