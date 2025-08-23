// ignore_for_file: invalid_use_of_protected_member, void_checks, prefer_const_constructors, avoid_types_on_closure_parameters

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/misc.dart' show Refreshable, ProviderListenable;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart' show UnmountedRefException;
import 'package:riverpod/src/providers/async_notifier.dart' show $AsyncNotifier;
import 'package:test/test.dart';

import '../../third_party/fake_async.dart';
import '../matrix.dart';
import '../utils.dart';

void main() {
  test('Throws if using notifier properties in its constructor', () {
    final errors = captureErrors([
      () => CtorNotifier().state,
      () => CtorNotifier().state = const AsyncData(42),
      () => CtorNotifier().future,
      () => CtorNotifier().ref,
    ]);
  });

  asyncNotifierProviderFactory.createGroup((factory) {
    test('filters state update by == by default', () async {
      final provider = factory.simpleTestProvider<Equal<int>>(
        (ref, _) => Equal(42),
      );
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<Equal<int>>>();

      container.listen(provider, listener.call);
      clearInteractions(listener);

      final notifier = container.read(provider.notifier);
      final firstState = notifier.state;

      // voluntarily assigning the same value
      final self = notifier.state;
      notifier.state = self;

      verifyZeroInteractions(listener);

      notifier.state = AsyncData(Equal(42));

      verifyZeroInteractions(listener);

      notifier.state = AsyncData(Equal(21));

      verifyOnly(listener, listener(firstState, AsyncData(Equal(21))));
    });

    if (factory.isFamily) {
      test(
        'sets provider(arg) dependencies/allTransitiveDependencies to null',
        () {
          final provider = factory.value(
            (_, arg) => factory.deferredNotifier((ref, _) => 0),
            dependencies: [],
          );

          expect(provider().dependencies, null);
          expect(provider().$allTransitiveDependencies, null);
        },
      );
    }

    test('locks .future notification during build', () async {
      final container = ProviderContainer.test();
      FutureOr<int> Function(Ref ref, $AsyncNotifier<int> self) build =
          (ref, self) => 0;
      final provider = factory.simpleTestProvider<int>(
        (ref, self) => build(ref, self),
      );
      final futureListener = Listener<Future<int>>();

      container.listen(provider.future, futureListener.call);

      build = (ref, self) {
        self.state = const AsyncData(42);
        self.state = const AsyncData(21);
        return 84;
      };
      container.invalidate(provider);
      await container.pump();

      final result = verify(futureListener(captureAny, captureAny))..called(1);
      await expectLater(result.captured.first, completion(0));
      await expectLater(result.captured.last, completion(84));
    });

    group('retry', () {
      test(
        'sets AsyncValue.retrying based on if a retry is started or not',
        () => fakeAsync((fake) async {
          final container = ProviderContainer.test();
          final controller = StreamController<int>.broadcast();
          addTearDown(controller.close);
          final provider = factory.simpleTestProvider<int>(
            (ref, self) async {
              return controller.stream.first;
            },
            retry: (count, _) {
              if (count == 1) return null;
              return const Duration(seconds: 1);
            },
          );
          final listener = Listener<AsyncValue<int>>();

          container.listen(provider, fireImmediately: true, listener.call);
          verifyOnly(listener, listener(null, const AsyncLoading<int>()));

          controller.addError(Exception('foo'));

          await container.read(provider.future).catchError((e) => 0);

          verifyOnly(
            listener,
            listener(any, argThat(isAsyncError<int>(anything, retrying: true))),
          );

          fake.elapse(const Duration(seconds: 1));
          fake.flushMicrotasks();

          verifyOnly(
            listener,
            listener(any, argThat(isAsyncError<int>(anything, retrying: true))),
          );

          controller.addError(Exception('foo'));

          await container.read(provider.future).catchError((e) => 0);

          verifyOnly(
            listener,
            listener(
              any,
              argThat(isAsyncError<int>(anything, retrying: false)),
            ),
          );
        }),
      );

      test(
        'handles retry',
        () => fakeAsync((fake) async {
          final container = ProviderContainer.test();
          var err = Exception('foo');
          final stack = StackTrace.current;
          final provider = factory.simpleTestProvider<int>(
            (ref, self) => Error.throwWithStackTrace(err, stack),
            retry: (_, __) => const Duration(seconds: 1),
          );
          final listener = Listener<AsyncValue<int>>();

          container.listen(provider, fireImmediately: true, listener.call);
          await container.read(provider.future).catchError((e) => 0);

          verifyOnly(
            listener,
            listener(
              any,
              argThat(
                isAsyncError<int>(err, stackTrace: stack, retrying: true),
              ),
            ),
          );

          err = Exception('bar');

          fake.elapse(const Duration(seconds: 1));
          fake.flushMicrotasks();

          await container.read(provider.future).catchError((e) => 0);

          verifyOnly(
            listener,
            listener(
              any,
              argThat(
                isAsyncError<int>(err, stackTrace: stack, retrying: true),
              ),
            ),
          );
        }),
      );

      test(
        'manually setting the state to an error does not cause a retry',
        () => fakeAsync((fake) async {
          final container = ProviderContainer.test();
          var retryCount = 0;
          final provider = factory.simpleTestProvider<int>(
            (ref, self) => 0,
            retry: (_, __) {
              retryCount++;
              return const Duration(seconds: 1);
            },
          );
          final listener = Listener<AsyncValue<int>>();

          container.listen(provider, fireImmediately: true, listener.call);

          expect(retryCount, 0);

          container.read(provider.notifier).state = AsyncValue<int>.error(
            Error(),
            StackTrace.current,
          );

          expect(retryCount, 0);
        }),
      );
    });

    test('resets progress to 0 if restarting while the future is pending', () {
      final container = ProviderContainer.test();
      final completer = Completer<int>();
      addTearDown(() => completer.complete(42));

      final provider = factory.simpleTestProvider((ref, self) {
        return completer.future;
      });

      expect(container.read(provider), const AsyncValue<int>.loading());

      container.read(provider.notifier).state = const AsyncValue<int>.loading(
        progress: .2,
      );

      container.refresh(provider);

      expect(container.read(provider), const AsyncValue<int>.loading());
    });

    test('Does not skip return value if ref.state was set', () async {
      final provider = factory.simpleTestProvider<int>((ref, self) async {
        await Future<void>.value();
        self.state = const AsyncData(1);
        await Future<void>.value();
        self.state = const AsyncData(2);
        await Future<void>.value();
        return 3;
      });
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<int>>();
      // Completer used for the sole purpose of being able to await `provider.future`
      // Since `provider` emits `AsyncData` before the future completes, then
      // `provider.future` completes early.
      // As such, awaiting `provider.future` isn't enough to fully await the FutureProvider
      final completer = Completer<void>();

      container.listen<AsyncValue<int>>(provider, (prev, next) {
        if (next.value == 3) completer.complete();
        listener(prev, next);
      }, fireImmediately: true);

      await completer.future;

      verifyInOrder([
        listener(null, const AsyncLoading<int>()),
        listener(const AsyncLoading<int>(), const AsyncData(1)),
        listener(const AsyncData(1), const AsyncData(2)),
        listener(const AsyncData(2), const AsyncData(3)),
      ]);
    });

    test('Cannot share a Notifier instance between providers ', () {
      final container = ProviderContainer.test();
      final notifier = factory.deferredNotifier<int>((ref, _) => 0);

      final provider = factory.provider<int>(() => notifier);
      final provider2 = factory.provider<int>(() => notifier);

      container.read(provider);

      expect(container.read(provider2), isA<AsyncError<int>>());
    });

    test('Support AsyncLoading.progress', () async {
      final container = ProviderContainer.test();
      final provider = factory.simpleTestProvider<int>((ref, self) async {
        self.state = const AsyncLoading<int>(progress: 0.5);
        await null;
        self.state = const AsyncLoading<int>(progress: 1);
        return 0;
      });
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener.call);
      await container.read(provider.future);

      verifyInOrder([
        listener(
          const AsyncLoading<int>(progress: 0.5),
          const AsyncLoading<int>(progress: 1),
        ),
        listener(const AsyncLoading<int>(progress: 1), const AsyncData(0)),
      ]);
    });

    test('Can read state inside onDispose', () {
      final container = ProviderContainer.test();
      late TestAsyncNotifier<int> notifier;
      late List<Object?> errors;
      final provider = factory.simpleTestProvider((ref, _) {
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

      expect(errors, everyElement(isA<AssertionError>()));
    });

    test('Using the notifier after dispose throws', () async {
      final container = ProviderContainer.test();
      final provider = factory.simpleTestProvider((ref, _) => 0);

      container.listen(provider.notifier, (prev, next) {});
      final notifier = container.read(provider.notifier);

      container.dispose();

      expect(notifier.ref.mounted, false);
      expect(() => notifier.state, throwsA(isA<UnmountedRefException>()));
      expect(() => notifier.future, throwsA(isA<UnmountedRefException>()));
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
      final provider = factory.simpleTestProvider<void>((ref, _) => 42);
      final container = ProviderContainer.test();

      final sub = container.listen(provider.notifier, (prev, next) {});

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
      final provider = factory.simpleTestProvider<void>((ref, _) => 42);
      final container = ProviderContainer.test();

      final sub = container.listen(provider.notifier, (prev, next) {});

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
      final provider = factory.simpleTestProvider<void>((ref, _) => 42);
      final container = ProviderContainer.test();

      final sub = container.listen(provider.notifier, (prev, next) {});

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
            (ref, _) => Future.value(count++),
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
        },
      );

      test(
        'performs seamless:false copyWithPrevious on `state = AsyncLoading()`',
        () async {
          final container = ProviderContainer.test();
          final provider = factory.simpleTestProvider(
            (ref, _) => Future.value(0),
          );

          final sub = container.listen(provider.notifier, (previous, next) {});

          await expectLater(container.read(provider.future), completion(0));
          expect(container.read(provider), const AsyncData(0));

          sub.read().state = const AsyncLoading<int>();

          expect(
            sub.read().state,
            const AsyncLoading<int>().copyWithPrevious(
              const AsyncData(0),
              isRefresh: false,
            ),
          );
        },
      );

      test(
        'performs seamless:false copyWithPrevious if triggered by a dependency change',
        () async {
          final container = ProviderContainer.test();
          final dep = StateProvider((ref) => 0);
          final provider = factory.simpleTestProvider(
            (ref, _) => Future.value(ref.watch(dep)),
          );

          container.listen(provider, (previous, next) {});

          await expectLater(container.read(provider.future), completion(0));
          expect(container.read(provider), const AsyncData(0));

          container.read(dep.notifier).state++;
          expect(
            container.read(provider),
            const AsyncLoading<int>().copyWithPrevious(
              const AsyncData(0),
              isRefresh: false,
            ),
          );

          await expectLater(container.read(provider.future), completion(1));
          expect(container.read(provider), const AsyncData(1));
        },
      );

      test('performs seamless data > loading > error transition', () async {
        final container = ProviderContainer.test(retry: (_, __) => null);
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
          const AsyncError<int>(
            'err',
            StackTrace.empty,
          ).copyWithPrevious(const AsyncData<int>(42)),
        );
      });

      test(
        'performs seamless:false copyWithPrevious if both triggered by a dependency change and ref.refresh',
        () async {
          final container = ProviderContainer.test();
          final dep = StateProvider((ref) => 0);
          final provider = factory.simpleTestProvider(
            (ref, _) => Future.value(ref.watch(dep)),
          );

          container.listen(provider, (previous, next) {});

          await expectLater(container.read(provider.future), completion(0));
          expect(container.read(provider), const AsyncData(0));

          container.read(dep.notifier).state++;
          expect(
            container.refresh(provider),
            const AsyncLoading<int>().copyWithPrevious(
              const AsyncData(0),
              isRefresh: false,
            ),
          );

          await expectLater(container.read(provider.future), completion(1));
          expect(container.read(provider), const AsyncData(1));
        },
      );
    });

    test('does not notify listeners when refreshed during loading', () async {
      final provider = factory.simpleTestProvider((ref, _) => Future.value(0));
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncLoading()));

      container.refresh(provider);

      await container.read(provider.future);

      verifyOnly(listener, listener(const AsyncLoading(), const AsyncData(0)));
    });

    group('listenSelf', () {
      test('can remove the listener', () async {
        final container = ProviderContainer.test();
        final listener = Listener<AsyncValue<int>>();
        late final RemoveListener remove;
        final provider = factory.simpleTestProvider<int>((ref, self) {
          remove = self.listenSelf(listener.call);
          return 0;
        });

        container.listen(provider.notifier, (previous, next) {});
        clearInteractions(listener);

        remove();

        container.read(provider.notifier).state = const AsyncData(42);

        verifyZeroInteractions(listener);
      });

      test('supports listenSelf', () {
        final listener = Listener<AsyncValue<int>>();
        final onError = ErrorListener();
        final provider = factory.simpleTestProvider<int>((ref, self) {
          self.listenSelf(listener.call, onError: onError.call);
          Error.throwWithStackTrace(42, StackTrace.empty);
        });
        final container = ProviderContainer.test(retry: (_, __) => null);

        container.listen(provider, (previous, next) {});

        verifyOnly(
          listener,
          listener(
            const AsyncLoading(),
            const AsyncError<int>(42, StackTrace.empty),
          ),
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
    });

    test(
      'converts AsyncNotifier.build into an AsyncData if the future completes',
      () async {
        final provider = factory.simpleTestProvider(
          (ref, _) => Future.value(0),
        );
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
      },
    );

    test(
      'converts AsyncNotifier.build into an AsyncError if the future fails',
      () async {
        final provider = factory.simpleTestProvider<int>(
          (ref, _) => Future.error(0, StackTrace.empty),
        );
        final container = ProviderContainer.test(retry: (_, __) => null);
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
      },
    );

    test('supports cases where the AsyncNotifier constructor throws', () async {
      final provider = factory.provider<int>(
        () => Error.throwWithStackTrace(0, StackTrace.empty),
      );
      final container = ProviderContainer.test(retry: (_, __) => null);
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(
        listener,
        listener(null, const AsyncError(0, StackTrace.empty)),
      );
      expect(
        () => container.read(provider.notifier),
        throwsProviderException(0),
      );

      await expectLater(container.read(provider.future), throwsA(0));
    });

    test(
      'synchronously emits AsyncData if AsyncNotifier.build emits synchronously',
      () async {
        final provider = factory.simpleTestProvider<int>((ref, _) => 0);
        final container = ProviderContainer.test();
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, const AsyncData(0)));
        expect(container.read(provider.notifier).state, const AsyncData(0));
        await expectLater(container.read(provider.future), completion(0));
      },
    );

    test(
      'synchronously emits AsyncError if AsyncNotifier.build throws synchronously',
      () async {
        final provider = factory.simpleTestProvider<int>(
          (ref, _) => Error.throwWithStackTrace(42, StackTrace.empty),
        );
        final container = ProviderContainer.test(retry: (_, __) => null);
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
      },
    );

    test(
      'stops listening to the previous future data when the provider rebuilds',
      () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        final completers = {0: Completer<int>.sync(), 1: Completer<int>.sync()};
        final provider = factory.simpleTestProvider<int>(
          (ref, _) => completers[ref.watch(dep)]!.future,
        );
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener.call);

        expect(
          container.read(provider.future),
          completion(21),
          reason:
              'The provider rebuilt while the future was still pending, '
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
      },
    );

    test(
      'stops listening to the previous future error when the provider rebuilds',
      () async {
        final container = ProviderContainer.test(retry: (_, __) => null);
        final dep = StateProvider((ref) => 0);
        final completers = {0: Completer<int>.sync(), 1: Completer<int>.sync()};
        final provider = factory.simpleTestProvider<int>(
          (ref, _) => completers[ref.watch(dep)]!.future,
        );
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener.call);

        expect(
          container.read(provider.future),
          throwsA(21),
          reason:
              'The provider rebuilt while the future was still pending, '
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
      },
    );

    group('AsyncNotifier.state', () {
      test(
        'when manually modifying the state, the new exposed value contains the previous state when possible',
        () async {
          final provider = factory.simpleTestProvider<int>((ref, _) => 0);
          final container = ProviderContainer.test();

          final sub = container.listen(provider.notifier, (previous, next) {});

          final newState = AsyncData(84);
          final newLoading = AsyncLoading<int>();
          final newError = AsyncError<int>(84, StackTrace.empty);

          sub.read().state = newState;

          expect(sub.read().state, same(newState));

          sub.read().state = newLoading;

          expect(
            sub.read().state,
            const AsyncLoading<int>().copyWithPrevious(
              newState,
              isRefresh: false,
            ),
          );

          sub.read().state = newError;

          expect(
            sub.read().state,
            newError.copyWithPrevious(
              const AsyncLoading<int>().copyWithPrevious(
                newState,
                isRefresh: false,
              ),
            ),
          );
        },
      );

      test('can be read inside build', () {
        final dep = StateProvider((ref) => 0);
        late AsyncValue<int> state;
        final provider = factory.provider<int>(() {
          late TestAsyncNotifier<int> notifier;
          return notifier = factory.deferredNotifier<int>((ref, _) {
            state = notifier.state;
            return Future.value(ref.watch(dep));
          });
        });
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
        final provider = factory.simpleTestProvider((ref, _) => 0);
        final container = ProviderContainer.test();
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener.call);

        verifyZeroInteractions(listener);

        container.read(provider.notifier).state = const AsyncData(42);

        verifyOnly(listener, listener(const AsyncData(0), const AsyncData(42)));
      });
    });

    group('AsyncNotifier.future', () {
      test('can be used inside Notifier.build', () async {
        final provider = factory.simpleTestProvider<int>((ref, self) {
          return self.future;
        });
        final container = ProviderContainer.test();

        final sub = container.listen(provider.notifier, (previous, next) {});

        expect(sub.read().future, completion(42));

        container.read(provider.notifier).state = AsyncData(42);

        expect(sub.read().future, completion(42));
      });

      test(
        'when disposed during loading, resolves with the content of AsyncNotifier.build',
        () async {
          final container = ProviderContainer.test();
          final completer = Completer<int>.sync();
          final provider = factory.simpleTestProvider<int>(
            (ref, _) => completer.future,
          );

          final future = container.read(provider.future);
          container.dispose();

          completer.complete(42);

          await expectLater(future, completion(42));
        },
      );

      test(
        'when disposed during loading, resolves with the error of AsyncNotifier.build',
        () async {
          final container = ProviderContainer.test();
          final completer = Completer<int>.sync();
          final provider = factory.simpleTestProvider<int>(
            (ref, _) => completer.future,
          );

          final future = container.read(provider.future);

          container.dispose();

          completer.completeError(42);

          await expectLater(future, throwsA(42));
        },
      );

      test('going data > loading while the future is still pending. '
          'Resolves with last future result', () async {
        final container = ProviderContainer.test();
        final completer = Completer<int>.sync();
        final provider = factory.simpleTestProvider<int>(
          (ref, _) => completer.future,
        );

        container.read(provider);
        container.read(provider.notifier).state = const AsyncData(42);
        container.read(provider.notifier).state = const AsyncLoading<int>();

        final future = container.read(provider.future);

        container.dispose();

        completer.complete(42);

        await expectLater(future, completion(42));
      });

      test(
        'if going back to loading after future resolved, throws StateError',
        () async {
          final container = ProviderContainer.test();
          final completer = Completer<int>.sync();
          final provider = factory.simpleTestProvider<int>(
            (ref, _) => completer.future,
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
            (ref, _) => completer.future,
          );
          final listener = Listener<Future<int>>();

          final sub = container.listen(provider.notifier, (previous, next) {});
          container.listen(provider.future, listener.call);

          expect(sub.read().future, completion(21));

          sub.read().state = const AsyncData(21);

          completer.complete(42);

          expect(sub.read().future, completion(42));
          final capture = verifyOnly(
            listener,
            listener(captureAny, captureAny),
          ).captured;

          expect(capture.length, 2);
          expect(capture.first, completion(21));
          expect(capture.last, completion(42));
        },
      );

      test(
        'resolves with the new state when notifier.state is changed',
        () async {
          final container = ProviderContainer.test();
          final provider = factory.simpleTestProvider<int>((ref, _) => 0);
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
        },
      );

      test('returns a Future identical to that of .future', () {
        final listener = OnBuildMock();
        final dep = StateProvider((ref) => 0);
        final provider = factory.simpleTestProvider<int>((ref, _) {
          listener();
          return Future.value(ref.watch(dep));
        });
        final container = ProviderContainer.test();

        container.listen(provider.notifier, (previous, next) {});
        final notifier = container.read(provider.notifier);

        expect(notifier.future, same(container.read(provider.future)));
      });
    });

    test(
      'Can override AsyncNotifier.updateShouldNotify to change the default filter logic',
      () {
        final provider = factory.simpleTestProvider<Equal<int>>(
          (ref, _) => Equal(42),
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
      },
    );

    group('AsyncNotifier.update', () {
      test('passes in the latest state', () async {
        final container = ProviderContainer.test();
        final provider = factory.simpleTestProvider<int>((ref, _) => 0);

        final sub = container.listen(provider.notifier, (prev, next) {});

        expect(container.read(provider), const AsyncData<int>(0));

        await expectLater(sub.read().update((prev) => prev + 1), completion(1));
        await expectLater(sub.read().future, completion(1));
        await expectLater(sub.read().update((prev) => prev + 1), completion(2));
      });

      test('can specify onError to handle error scenario', () async {
        final container = ProviderContainer.test(retry: (_, __) => null);
        final provider = factory.simpleTestProvider<int>(
          (ref, _) => Error.throwWithStackTrace(42, StackTrace.empty),
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

      test(
        'executes immediately with current state if a state is available',
        () async {
          final container = ProviderContainer.test();
          final provider = factory.simpleTestProvider<int>((ref, _) => 1);

          final sub = container.listen(provider.notifier, (prev, next) {});

          expect(container.read(provider), const AsyncData(1));

          await expectLater(
            sub.read().update((prev) => prev + 1),
            completion(2),
          );
          expect(container.read(provider), const AsyncData(2));
        },
      );

      test(
        'executes immediately with current state if an error is available',
        () async {
          final container = ProviderContainer.test(retry: (_, __) => null);
          final provider = factory.simpleTestProvider<int>(
            (ref, _) => Error.throwWithStackTrace(42, StackTrace.empty),
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
        },
      );

      test('awaits the future resolution if in loading state', () async {
        final container = ProviderContainer.test();
        final provider = factory.simpleTestProvider<int>(
          (ref, _) => Future.value(42),
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
      () => DeferredAsyncNotifier((ref, _) => 0),
    );
    final autoDispose =
        AsyncNotifierProvider.autoDispose<DeferredAsyncNotifier<int>, int>(
          () => DeferredAsyncNotifier((ref, _) => 0),
        );
    final container = ProviderContainer.test(
      overrides: [
        provider.overrideWith(() => DeferredAsyncNotifier((ref, _) => 42)),
        autoDispose.overrideWith(() => DeferredAsyncNotifier((ref, _) => 84)),
      ],
    );

    expect(container.read(provider).value, 42);
    expect(container.read(autoDispose).value, 84);
  });

  test('supports family overrideWith', () {
    final family =
        AsyncNotifierProvider.family<DeferredAsyncNotifier<int>, int, int>(
          (arg) => DeferredAsyncNotifier((ref, _) => 0),
        );
    final autoDisposeFamily = AsyncNotifierProvider.autoDispose
        .family<DeferredAsyncNotifier<int>, int, int>(
          (arg) => DeferredAsyncNotifier((ref, _) => 0),
        );
    final container = ProviderContainer.test(
      overrides: [
        family.overrideWith(() => DeferredAsyncNotifier<int>((ref, _) => 42)),
        autoDisposeFamily.overrideWith(
          () => DeferredAsyncNotifier<int>((ref, _) => 84),
        ),
      ],
    );

    expect(container.read(family(10)).value, 42);
    expect(container.read(autoDisposeFamily(10)).value, 84);
  });

  group('modifiers', () {
    void canBeAssignedToRefreshable<StateT>(Refreshable<StateT> provider) {}

    void canBeAssignedToProviderListenable<StateT>(
      ProviderListenable<StateT> provider,
    ) {}

    test('provider', () {
      final provider = AsyncNotifierProvider<DeferredAsyncNotifier<int>, int>(
        () => DeferredAsyncNotifier((ref, _) => 0),
      );

      provider.select((AsyncValue<int> value) => 0);
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
            () => DeferredAsyncNotifier((ref, _) => 0),
          );

      autoDispose.select((AsyncValue<int> value) => 0);
      autoDispose.selectAsync((int value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<int>>(autoDispose);
      canBeAssignedToRefreshable<AsyncValue<int>>(autoDispose);

      canBeAssignedToProviderListenable<Future<int>>(autoDispose.future);
      canBeAssignedToRefreshable<Future<int>>(autoDispose.future);

      canBeAssignedToProviderListenable<AsyncNotifier<int>>(
        autoDispose.notifier,
      );
      canBeAssignedToRefreshable<AsyncNotifier<int>>(autoDispose.notifier);
    });

    test('family', () {
      final family =
          AsyncNotifierProvider.family<
            DeferredAsyncNotifier<String>,
            String,
            int
          >((arg) => DeferredAsyncNotifier((ref, _) => '0'));

      family(0).select((AsyncValue<String> value) => 0);
      family(0).selectAsync((String value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<String>>(family(0));
      canBeAssignedToRefreshable<AsyncValue<String>>(family(0));

      canBeAssignedToProviderListenable<Future<String>>(family(0).future);
      canBeAssignedToRefreshable<Future<String>>(family(0).future);
    });

    test('autoDisposeFamily', () {
      expect(
        AsyncNotifierProvider.autoDispose.family,
        same(AsyncNotifierProvider.family.autoDispose),
      );

      final autoDisposeFamily = AsyncNotifierProvider.autoDispose
          .family<DeferredAsyncNotifier<String>, String, int>(
            (arg) => DeferredAsyncNotifier((ref, _) => '0'),
          );

      autoDisposeFamily(0).select((AsyncValue<String> value) => 0);
      autoDisposeFamily(0).selectAsync((String value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<String>>(
        autoDisposeFamily(0),
      );
      canBeAssignedToRefreshable<AsyncValue<String>>(autoDisposeFamily(0));

      canBeAssignedToProviderListenable<Future<String>>(
        autoDisposeFamily(0).future,
      );
      canBeAssignedToRefreshable<Future<String>>(autoDisposeFamily(0).future);
    });
  });
}

@immutable
class Equal<BoxedT> {
  const Equal(this.value);

  final BoxedT value;

  @override
  bool operator ==(Object other) =>
      other is Equal<BoxedT> && other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() => 'Equal($value)';
}

class CtorNotifier extends AsyncNotifier<int> {
  @override
  FutureOr<int> build() => 0;
}
