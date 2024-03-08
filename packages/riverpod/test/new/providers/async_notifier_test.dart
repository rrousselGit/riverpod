// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart' show UnmountedRefException;
import 'package:riverpod/src/providers/async_notifier.dart' show $AsyncNotifier;
import 'package:test/test.dart';

import '../matrix.dart';
import '../utils.dart';

void main() {
  test('Throws if using notifier properties in its constructor', () {
    expect(
      CtorNotifier.new,
      throwsA(isA<StateError>()),
    );
    expect(
      FamilyCtorNotifier.new,
      throwsA(isA<StateError>()),
    );
  });

  asyncNotifierProviderFactory.createGroup((factory) {
    test('Cannot share a Notifier instance between providers ', () {
      final container = ProviderContainer.test();
      final notifier = factory.deferredNotifier<int>((ref) => 0);

      final provider = factory.provider<int>(() => notifier);
      final provider2 = factory.provider<int>(() => notifier);

      container.read(provider);

      expect(
        container.read(provider2),
        isA<AsyncError<int>>(),
      );
    });

    test('Can read state inside onDispose', () {
      final container = ProviderContainer.test();
      late TestAsyncNotifier<int> notifier;
      late List<Object?> errors;
      final provider = factory.simpleTestProvider((ref) {
        ref.onDispose(() {
          errors = captureErrors([
            () => notifier.state,
            () => notifier.state = const AsyncData(42),
            () => notifier.future,
          ]);
        });
        return 0;
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
      final provider = factory.simpleTestProvider((ref) => 0);

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

    test('Can assign `AsyncLoading<T>` to `AsyncValue<void>`', () {
      // Regression test for https://github.com/rrousselGit/riverpod/issues/2120
      final provider = factory.simpleTestProvider<void>((ref) => 42);
      final container = ProviderContainer.test();

      final sub = container.listen(provider.notifier, (prev, next) {});

      // ignore: void_checks
      expect(sub.read().state, const AsyncData<void>(42));

      sub.read().state = const AsyncLoading<int>();

      expect(
        sub.read().state,
        isA<AsyncLoading<void>>()
            .having((e) => e.hasValue, 'hasValue', true)
            .having((e) => e.value, 'value', 42),
      );
    });

    test('Can assign `AsyncData<T>` to `AsyncValue<void>`', () {
      // Regression test for https://github.com/rrousselGit/riverpod/issues/2120
      final provider = factory.simpleTestProvider<void>((ref) => 42);
      final container = ProviderContainer.test();

      final sub = container.listen(provider.notifier, (prev, next) {});

      // ignore: void_checks
      expect(sub.read().state, const AsyncData<void>(42));

      sub.read().state = const AsyncData<int>(42);

      expect(
        sub.read().state,
        isA<AsyncData<void>>()
            .having((e) => e.hasValue, 'hasValue', true)
            .having((e) => e.value, 'value', 42),
      );
    });

    test('Can assign `AsyncError<T>` to `AsyncValue<void>`', () {
      // Regression test for https://github.com/rrousselGit/riverpod/issues/2120
      final provider = factory.simpleTestProvider<void>((ref) => 42);
      final container = ProviderContainer.test();

      final sub = container.listen(provider.notifier, (prev, next) {});

      // ignore: void_checks
      expect(sub.read().state, const AsyncData<void>(42));

      sub.read().state = AsyncError<int>(21, StackTrace.current);

      expect(
        sub.read().state,
        isA<AsyncError<void>>()
            .having((e) => e.hasValue, 'hasValue', true)
            .having((e) => e.value, 'value', 42)
            .having((e) => e.hasError, 'hasError', true)
            .having((e) => e.error, 'error', 21),
      );
    });

    group('supports AsyncValue transition', () {
      test(
          'performs seamless copyWithPrevious if triggered by ref.invalidate/ref.refresh',
          () async {
        final container = ProviderContainer.test();
        var count = 0;
        final provider = factory.simpleTestProvider(
          (ref) => Future.value(count++),
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
        final provider = factory.simpleTestProvider((ref) => Future.value(0));

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
          (ref) => Future.value(ref.watch(dep)),
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

      test('performs seamless data > loading > error transition', () async {
        final container = ProviderContainer.test();
        var result = Future.value(42);
        final provider = FutureProvider((ref) => result);

        final sub = container.listen(provider.future, (_, __) {});

        expect(container.read(provider), const AsyncLoading<int>());
        expect(await sub.read(), 42);
        expect(container.read(provider), const AsyncData<int>(42));

        result = Future.error('err', StackTrace.empty);
        container.invalidate(provider);

        expect(
          container.read(provider),
          const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)),
        );
        await expectLater(sub.read(), throwsA('err'));
        expect(
          container.read(provider),
          const AsyncError<int>('err', StackTrace.empty)
              .copyWithPrevious(const AsyncData<int>(42)),
        );
      });

      test(
          'performs seamless:false copyWithPrevious if both triggered by a dependency change and ref.refresh',
          () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        final provider = factory.simpleTestProvider(
          (ref) => Future.value(ref.watch(dep)),
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
      final provider = factory.simpleTestProvider((ref) => Future.value(0));
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
        'converts AsyncNotifier.build into an AsyncData if the future completes',
        () async {
      final provider = factory.simpleTestProvider((ref) => Future.value(0));
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

    test('converts AsyncNotifier.build into an AsyncError if the future fails',
        () async {
      final provider = factory.simpleTestProvider<int>(
        (ref) => Future.error(0, StackTrace.empty),
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

    test('supports cases where the AsyncNotifier constructor throws', () async {
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
        'synchronously emits AsyncData if AsyncNotifier.build emits synchronously',
        () async {
      final provider = factory.simpleTestProvider<int>((ref) => 0);
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncData(0)));
      expect(container.read(provider.notifier).state, const AsyncData(0));
      await expectLater(container.read(provider.future), completion(0));
    });

    test(
        'synchronously emits AsyncError if AsyncNotifier.build throws synchronously',
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
        (ref) => completers[ref.watch(dep)]!.future,
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
        (ref) => completers[ref.watch(dep)]!.future,
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

    group('AsyncNotifier.state', () {
      test(
          'when manually modifying the state, the new exposed value contains the previous state when possible',
          () async {
        final provider = factory.simpleTestProvider<int>((ref) => 0);
        final container = ProviderContainer.test();

        final sub = container.listen(provider.notifier, (previous, next) {});

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
            late TestAsyncNotifier<int> notifier;
            return notifier = factory.deferredNotifier<int>(
              (ref) {
                state = notifier.state;
                return Future.value(ref.watch(dep));
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

      test('notifies listeners when the setter is called', () {
        final provider = factory.simpleTestProvider((ref) => 0);
        final container = ProviderContainer.test();
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener.call);

        verifyZeroInteractions(listener);

        container.read(provider.notifier).state = const AsyncData(42);

        verifyOnly(
          listener,
          listener(const AsyncData(0), const AsyncData(42)),
        );
      });
    });

    group('AsyncNotifier.future', () {
      test('If the notifier is recreated with an error, rethrows the new error',
          () async {
        final container = ProviderContainer.test();
        final listener = Listener<Future<int>>();
        var body = () => factory.deferredNotifier((ref) => 0);
        final provider = factory.provider<int>(() => body());

        container.listen(provider.future, listener.call);

        await expectLater(
          container.read(provider.future),
          completion(0),
        );
        verifyZeroInteractions(listener);

        body = () => throw StateError('foo');
        container.invalidate(provider);

        await expectLater(
          container.read(provider.future),
          throwsA(isA<StateError>()),
        );
        verify(listener(any, any)).called(1);
      });

      test(
          'when disposed during loading, resolves with the content of AsyncNotifier.build',
          () async {
        final container = ProviderContainer.test();
        final completer = Completer<int>.sync();
        final provider = factory.simpleTestProvider<int>(
          (ref) => completer.future,
        );

        final future = container.read(provider.future);
        container.dispose();

        completer.complete(42);

        await expectLater(future, completion(42));
      });

      test(
          'when disposed during loading, resolves with the error of AsyncNotifier.build',
          () async {
        final container = ProviderContainer.test();
        final completer = Completer<int>.sync();
        final provider = factory.simpleTestProvider<int>(
          (ref) => completer.future,
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
            (ref) => completer.future,
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

      test(
        'if going back to loading after future resolved, throws StateError',
        () async {
          final container = ProviderContainer.test();
          final completer = Completer<int>.sync();
          final provider = factory.simpleTestProvider<int>(
            (ref) => completer.future,
          );

          container.read(provider);

          completer.complete(42);

          container.read(provider.notifier).state = const AsyncData(42);
          container.read(provider.notifier).state = const AsyncLoading<int>();

          final future = container.read(provider.future);

          container.dispose();

          await expectLater(future, throwsStateError);
        },
      );

      test(
          'resolves with the new state if AsyncNotifier.state is modified during loading',
          () async {
        final container = ProviderContainer.test();
        final completer = Completer<int>.sync();
        final provider = factory.simpleTestProvider<int>(
          (ref) => completer.future,
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
        final provider = factory.simpleTestProvider<int>((ref) => 0);
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
            return Future.value(ref.watch(dep));
          },
        );
        final container = ProviderContainer.test();

        container.listen(provider.notifier, (previous, next) {});
        final notifier = container.read(provider.notifier);

        expect(notifier.future, same(container.read(provider.future)));
      });
    });

    group('AsyncNotifierProvider.notifier', () {
      test('If the notifier is recreated with an error, rethrows the new error',
          () async {
        final container = ProviderContainer.test();
        final listener = Listener<$AsyncNotifier<int>>();
        final onError = ErrorListener();
        var body = () => factory.deferredNotifier((ref) => 0);
        final provider = factory.provider<int>(() => body());

        container.listen(
          provider.notifier,
          listener.call,
          onError: onError.call,
        );

        await expectLater(container.read(provider.notifier), isNotNull);
        verifyZeroInteractions(listener);
        verifyZeroInteractions(onError);

        body = () => throw StateError('foo');
        container.invalidate(provider);

        await expectLater(
          () => container.read(provider.notifier),
          throwsA(isA<StateError>()),
        );
        verifyZeroInteractions(listener);
        verifyOnly(onError, onError(isA<StateError>(), any)).called(1);
      });

      test(
          'Notifies listeners whenever `build` is re-executed, due to recreating a new notifier.',
          () async {
        final notifierListener = Listener<$AsyncNotifier<int>>();
        final dep = StateProvider((ref) => 0);
        final provider = factory.provider<int>(() {
          return factory.deferredNotifier(
            (ref) => Future.value(ref.watch(dep)),
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
        'Can override AsyncNotifier.updateShouldNotify to change the default filter logic',
        () {
      final provider = factory.simpleTestProvider<Equal<int>>(
        (ref) => Equal(42),
        updateShouldNotify: (a, b) => a != b,
      );
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<Equal<int>>>();

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
          (ref) => 0,
        );

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
        final provider = factory.simpleTestProvider<int>((ref) => 1);

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
          (ref) => Future.value(42),
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

  test('supports overrideWith', () {
    final provider = AsyncNotifierProvider<DeferredAsyncNotifier<int>, int>(
      () => DeferredAsyncNotifier((ref) => 0),
    );
    final autoDispose =
        AsyncNotifierProvider.autoDispose<DeferredAsyncNotifier<int>, int>(
      () => DeferredAsyncNotifier((ref) => 0),
    );
    final container = ProviderContainer.test(
      overrides: [
        provider.overrideWith(() => DeferredAsyncNotifier((ref) => 42)),
        autoDispose.overrideWith(
          () => DeferredAsyncNotifier((ref) => 84),
        ),
      ],
    );

    expect(container.read(provider).value, 42);
    expect(container.read(autoDispose).value, 84);
  });

  test('supports family overrideWith', () {
    final family = AsyncNotifierProvider.family<
        DeferredFamilyAsyncNotifier<int>, int, int>(
      () => DeferredFamilyAsyncNotifier((ref) => 0),
    );
    final autoDisposeFamily = AsyncNotifierProvider.autoDispose
        .family<DeferredFamilyAsyncNotifier<int>, int, int>(
      () => DeferredFamilyAsyncNotifier((ref) => 0),
    );
    final container = ProviderContainer.test(
      overrides: [
        family.overrideWith(
          () => DeferredFamilyAsyncNotifier<int>((ref) => 42),
        ),
        autoDisposeFamily.overrideWith(
          () => DeferredFamilyAsyncNotifier<int>((ref) => 84),
        ),
      ],
    );

    expect(container.read(family(10)).value, 42);
    expect(container.read(autoDisposeFamily(10)).value, 84);
  });

  group('modifiers', () {
    void canBeAssignedToRefreshable<T>(
      Refreshable<T> provider,
    ) {}

    void canBeAssignedToProviderListenable<T>(
      ProviderListenable<T> provider,
    ) {}

    test('provider', () {
      final provider = AsyncNotifierProvider<DeferredAsyncNotifier<int>, int>(
        () => DeferredAsyncNotifier((ref) => 0),
      );

      // ignore: avoid_types_on_closure_parameters
      provider.select((AsyncValue<int> value) => 0);
      // ignore: avoid_types_on_closure_parameters
      provider.selectAsync((int value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<int>>(provider);
      canBeAssignedToRefreshable<AsyncValue<int>>(provider);

      canBeAssignedToProviderListenable<Future<int>>(provider.future);
      canBeAssignedToRefreshable<Future<int>>(provider.future);

      canBeAssignedToProviderListenable<AsyncNotifier<int>>(provider.notifier);
      canBeAssignedToRefreshable<AsyncNotifier<int>>(provider.notifier);
    });

    test('autoDispose', () {
      final autoDispose =
          AsyncNotifierProvider.autoDispose<DeferredAsyncNotifier<int>, int>(
        () => DeferredAsyncNotifier((ref) => 0),
      );

      // ignore: avoid_types_on_closure_parameters
      autoDispose.select((AsyncValue<int> value) => 0);
      // ignore: avoid_types_on_closure_parameters
      autoDispose.selectAsync((int value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<int>>(autoDispose);
      canBeAssignedToRefreshable<AsyncValue<int>>(autoDispose);

      canBeAssignedToProviderListenable<Future<int>>(autoDispose.future);
      canBeAssignedToRefreshable<Future<int>>(autoDispose.future);

      canBeAssignedToProviderListenable<AsyncNotifier<int>>(
        autoDispose.notifier,
      );
      canBeAssignedToRefreshable<AsyncNotifier<int>>(
        autoDispose.notifier,
      );
    });

    test('family', () {
      final family = AsyncNotifierProvider.family<
          DeferredFamilyAsyncNotifier<String>, String, int>(
        () => DeferredFamilyAsyncNotifier((ref) => '0'),
      );

      // ignore: avoid_types_on_closure_parameters
      family(0).select((AsyncValue<String> value) => 0);
      // ignore: avoid_types_on_closure_parameters
      family(0).selectAsync((String value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<String>>(family(0));
      canBeAssignedToRefreshable<AsyncValue<String>>(family(0));

      canBeAssignedToProviderListenable<Future<String>>(family(0).future);
      canBeAssignedToRefreshable<Future<String>>(family(0).future);

      canBeAssignedToProviderListenable<FamilyAsyncNotifier<String, int>>(
        family(0).notifier,
      );
      canBeAssignedToRefreshable<FamilyAsyncNotifier<String, int>>(
        family(0).notifier,
      );
    });

    test('autoDisposeFamily', () {
      expect(
        AsyncNotifierProvider.autoDispose.family,
        same(AsyncNotifierProvider.family.autoDispose),
      );

      final autoDisposeFamily = AsyncNotifierProvider.autoDispose
          .family<DeferredFamilyAsyncNotifier<String>, String, int>(
        () => DeferredFamilyAsyncNotifier((ref) => '0'),
      );

      // ignore: avoid_types_on_closure_parameters
      autoDisposeFamily(0).select((AsyncValue<String> value) => 0);
      // ignore: avoid_types_on_closure_parameters
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

      canBeAssignedToProviderListenable<FamilyAsyncNotifier<String, int>>(
        autoDisposeFamily(0).notifier,
      );
      canBeAssignedToRefreshable<FamilyAsyncNotifier<String, int>>(
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

  @override
  String toString() => 'Equal($value)';
}

class CtorNotifier extends AsyncNotifier<int> {
  CtorNotifier() {
    state;
  }

  @override
  FutureOr<int> build() => 0;
}

class FamilyCtorNotifier extends FamilyAsyncNotifier<int, int> {
  FamilyCtorNotifier() {
    state;
  }

  @override
  FutureOr<int> build(int arg) => 0;
}
