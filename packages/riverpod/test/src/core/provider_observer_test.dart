import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('ProviderObserver', () {
    test('can have const constructors', () {
      final root = ProviderContainer.test(observers: [const ConstObserver()]);

      root.dispose();
    });

    group('didUpdateProvider', () {
      test(
        'after an error didUpdateProvider receives null as previous value ',
        () async {
          final observer = ObserverMock();
          final observer2 = ObserverMock();
          final container = ProviderContainer.test(
            observers: [observer, observer2],
          );
          final dep = StateProvider((ref) => 0);
          final provider = Provider((ref) {
            if (ref.watch(dep) == 0) {
              throw UnimplementedError();
            }
            return 0;
          });

          container.listen(provider, (_, __) {}, onError: (err, stack) {});

          clearInteractions(observer);
          clearInteractions(observer2);

          container.read(dep.notifier).state++;
          await container.pump();

          verifyInOrder([
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(
                  provider: provider,
                  container: container,
                ),
              ),
              null,
              0,
            ),
            observer2.didUpdateProvider(
              argThat(
                isProviderObserverContext(
                  provider: provider,
                  container: container,
                ),
              ),
              null,
              0,
            ),
          ]);
          verifyNever(observer.providerDidFail(any, any, any));
        },
      );

      test(
        'on scoped ProviderContainer, applies both child and ancestors observers',
        () {
          final provider = StateNotifierProvider<StateController<int>, int>(
            (ref) => StateController(0),
            dependencies: const [],
          );
          final observer = ObserverMock('a');
          final observer2 = ObserverMock('b');
          final observer3 = ObserverMock('c');

          final root = ProviderContainer.test(observers: [observer]);
          final mid = ProviderContainer.test(
            parent: root,
            observers: [observer2],
          );
          final child = ProviderContainer.test(
            parent: mid,
            overrides: [provider.overrideWith((ref) => StateController(42))],
            observers: [observer3],
          );

          expect(child.read(provider), 42);
          expect(mid.read(provider), 0);

          clearInteractions(observer3);
          clearInteractions(observer2);
          clearInteractions(observer);

          expect(child.read(provider.notifier).state++, 42);

          verify(
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
              43,
            ),
          ).called(1);
          verify(
            observer2.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
              43,
            ),
          ).called(1);
          verify(
            observer3.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
              43,
            ),
          ).called(1);

          mid.read(provider.notifier).state++;

          verify(
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: root),
              ),
              0,
              1,
            ),
          ).called(1);

          verifyNoMoreInteractions(observer3);
          verifyNoMoreInteractions(observer2);
          verifyNoMoreInteractions(observer);
        },
      );

      test('handles computed provider update', () async {
        final observer = ObserverMock();
        final container = ProviderContainer.test(observers: [observer]);
        final notifier = Counter();
        final provider = StateNotifierProvider<Counter, int>((_) => notifier);
        final computed = Provider((ref) => ref.watch(provider));

        container.listen(computed, (_, __) {});
        notifier.increment();

        clearInteractions(observer);

        await container.pump();

        verify(
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: computed,
                container: container,
              ),
            ),
            0,
            1,
          ),
        ).called(1);
        verifyNever(observer.didUpdateProvider(any, any, any));
      });

      test('handles direct provider update', () {
        final observer = ObserverMock();
        final container = ProviderContainer.test(observers: [observer]);
        final notifier = Counter();
        final provider = StateNotifierProvider<Counter, int>((_) => notifier);

        container.read(provider);
        clearInteractions(observer);

        notifier.increment();

        verifyOnly(
          observer,
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            1,
          ),
        ).called(1);
      });

      test('didUpdateProviders', () {
        final observer = ObserverMock('a');
        final observer2 = ObserverMock('b');
        final provider = StateNotifierProvider<Counter, int>((_) => Counter());
        final counter = Counter();
        final container = ProviderContainer.test(
          overrides: [provider.overrideWith((ref) => counter)],
          observers: [observer, observer2],
        );
        final listener = Listener<int>();

        container.listen(provider, listener.call, fireImmediately: true);

        verify(listener(null, 0)).called(1);
        verifyNoMoreInteractions(listener);
        verifyInOrder([
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
          ),
          observer2.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
          ),
        ]);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);

        counter.increment();

        verifyInOrder([
          listener(0, 1),
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            1,
          ),
          observer2.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            1,
          ),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);
      });

      test('guards didUpdateProviders', () {
        final observer = ObserverMock();
        when(observer.didUpdateProvider(any, any, any)).thenThrow('error1');
        final observer2 = ObserverMock();
        when(observer2.didUpdateProvider(any, any, any)).thenThrow('error2');
        final observer3 = ObserverMock();
        final provider = StateNotifierProvider<Counter, int>((_) => Counter());
        final counter = Counter();
        final errors = <Object>[];
        final container =
            runZonedGuarded(
              () => ProviderContainer.test(
                overrides: [provider.overrideWith((ref) => counter)],
                observers: [observer, observer2, observer3],
              ),
              (err, stack) => errors.add(err),
            )!;

        container.read(provider);

        clearInteractions(observer);
        clearInteractions(observer2);
        clearInteractions(observer3);

        counter.increment();

        expect(errors, ['error1', 'error2']);
        verifyInOrder([
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            1,
          ),
          observer2.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            1,
          ),
          observer3.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            1,
          ),
        ]);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);
        verifyNoMoreInteractions(observer3);
      });

      test(
        "Computed don't call didUpdateProviders when value doesn't change",
        () async {
          final observer = ObserverMock();
          final counter = Counter();
          final provider = StateNotifierProvider<Counter, int>((_) => counter);
          final isNegative = Provider((ref) {
            return ref.watch(provider).isNegative;
          });
          final container = ProviderContainer.test(observers: [observer]);
          final isNegativeListener = Listener<bool>();

          container.listen(
            isNegative,
            isNegativeListener.call,
            fireImmediately: true,
          );

          clearInteractions(observer);
          verifyOnly(isNegativeListener, isNegativeListener(null, false));

          counter.increment();
          await container.pump();

          verifyInOrder([
            observer.didDisposeProvider(
              argThat(
                isProviderObserverContext(
                  provider: isNegative,
                  container: container,
                ),
              ),
            ),
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(
                  provider: provider,
                  container: container,
                ),
              ),
              0,
              1,
            ),
          ]);
          verifyNever(observer.didUpdateProvider(any, any, any));

          counter.state = -10;
          await container.pump();

          verifyInOrder([
            observer.didDisposeProvider(
              argThat(
                isProviderObserverContext(
                  provider: isNegative,
                  container: container,
                ),
              ),
            ),
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(
                  provider: provider,
                  container: container,
                ),
              ),
              1,
              -10,
            ),
            isNegativeListener(false, true),
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(
                  provider: isNegative,
                  container: container,
                ),
              ),
              false,
              true,
            ),
          ]);
          verifyNever(observer.didUpdateProvider(any, any, any));
          verifyNoMoreInteractions(isNegativeListener);
        },
      );
    });

    group('providerDidFail', () {
      test(
        'on scoped ProviderContainer, applies both child and ancestors observers',
        () async {
          final dep = StateProvider((ref) => 0);
          final provider = StateNotifierProvider<StateController<int>, int>(
            (ref) => StateController(0),
            dependencies: const [],
          );
          final observer = ObserverMock('a');
          final observer2 = ObserverMock('b');
          final observer3 = ObserverMock('c');

          final root = ProviderContainer.test(observers: [observer]);
          final mid = ProviderContainer.test(
            parent: root,
            observers: [observer2],
          );
          final child = ProviderContainer.test(
            parent: mid,
            overrides: [
              provider.overrideWith((ref) {
                if (ref.watch(dep) != 0) {
                  Error.throwWithStackTrace('error', StackTrace.empty);
                }
                return StateController(42);
              }),
            ],
            observers: [observer3],
          );

          child.listen(provider, (_, __) {}, onError: (_, __) {});

          expect(child.read(provider), 42);
          expect(mid.read(provider), 0);

          clearInteractions(observer3);
          clearInteractions(observer2);
          clearInteractions(observer);

          child.read(dep.notifier).state++;
          await child.pump();

          verifyInOrder([
            observer.didDisposeProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
            ),
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: dep, container: root),
              ),
              0,
              1,
            ),
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
              null,
            ),
            observer.providerDidFail(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              'error',
              StackTrace.empty,
            ),
          ]);
          verifyInOrder([
            observer2.didDisposeProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
            ),
            observer2.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
              null,
            ),
            observer2.providerDidFail(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              'error',
              StackTrace.empty,
            ),
          ]);
          verifyInOrder([
            observer3.didDisposeProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
            ),
            observer3.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
              null,
            ),
            observer3.providerDidFail(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              'error',
              StackTrace.empty,
            ),
          ]);
          verifyNever(observer3.didUpdateProvider(any, any, any));
          verifyNever(observer2.didUpdateProvider(any, any, any));
          verifyNever(observer.didUpdateProvider(any, any, any));
        },
      );

      test('is called when FutureProvider emits an error', () async {
        final observer = ObserverMock();
        final container = ProviderContainer.test(
          observers: [observer],
          retry: (_, __) => null,
        );
        final provider = FutureProvider(
          (ref) => Future<void>.error('error', StackTrace.empty),
        );

        container.listen(provider, (_, __) {});
        await container.read(provider.future).catchError((_) {});

        verifyInOrder([
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            const AsyncLoading<void>(),
          ),
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            const AsyncLoading<void>(),
            const AsyncError<void>('error', StackTrace.empty),
          ),
          observer.providerDidFail(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            'error',
            StackTrace.empty,
          ),
        ]);
      });

      test('is called when StreamProvider emits an error', () async {
        final observer = ObserverMock();
        final container = ProviderContainer.test(
          observers: [observer],
          retry: (_, __) => null,
        );
        final provider = StreamProvider(
          (ref) => Stream<void>.error('error', StackTrace.empty),
        );

        container.listen(provider, (_, __) {});
        await container.read(provider.future).catchError((_) {});

        verifyInOrder([
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            const AsyncLoading<void>(),
          ),
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            const AsyncLoading<void>(),
            const AsyncError<void>('error', StackTrace.empty),
          ),
          observer.providerDidFail(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            'error',
            StackTrace.empty,
          ),
        ]);
      });

      test('is called on uncaught error during first initialization', () {
        final observer = ObserverMock();
        final observer2 = ObserverMock();
        final container = ProviderContainer.test(
          observers: [observer, observer2],
        );
        final provider = Provider((ref) => throw UnimplementedError());

        expect(() => container.read(provider), throwsA(anything));

        verifyInOrder([
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            null,
          ),
          observer2.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            null,
          ),
          observer.providerDidFail(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            argThat(isUnimplementedError),
            argThat(isNotNull),
          ),
          observer2.providerDidFail(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            argThat(isUnimplementedError),
            argThat(isNotNull),
          ),
        ]);
        verifyNoMoreInteractions(observer);
      });

      test('is called on uncaught error after update ', () async {
        final observer = ObserverMock();
        final observer2 = ObserverMock();
        final container = ProviderContainer.test(
          observers: [observer, observer2],
        );
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          if (ref.watch(dep) != 0) {
            throw UnimplementedError();
          }
          return 0;
        });

        container.listen(provider, (_, __) {}, onError: (err, stack) {});

        clearInteractions(observer);
        clearInteractions(observer2);

        container.read(dep.notifier).state++;
        await container.pump();

        verifyInOrder([
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            null,
          ),
          observer2.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            null,
          ),
          observer.providerDidFail(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            argThat(isUnimplementedError),
            argThat(isNotNull),
          ),
          observer2.providerDidFail(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            argThat(isUnimplementedError),
            argThat(isNotNull),
          ),
        ]);
      });
    });

    group('didAddProvider', () {
      test('when throwing during creation, receives `null` as value', () {
        final observer = ObserverMock();
        final container = ProviderContainer.test(observers: [observer]);
        final provider = Provider((ref) => throw UnimplementedError());

        expect(() => container.read(provider), throwsA(anything));

        verify(
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            null,
          ),
        );
      });

      test(
        'on scoped ProviderContainer, applies both child and ancestors observers',
        () {
          final provider = Provider((ref) => 0, dependencies: const []);
          final observer = ObserverMock();
          final observer2 = ObserverMock();
          final observer3 = ObserverMock();
          final root = ProviderContainer.test(observers: [observer]);
          final mid = ProviderContainer.test(
            parent: root,
            observers: [observer2],
          );
          final child = ProviderContainer.test(
            parent: mid,
            overrides: [provider.overrideWithValue(42)],
            observers: [observer3],
          );

          expect(child.read(provider), 42);

          verifyInOrder([
            observer3.didAddProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
            ),
            observer2.didAddProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
            ),
            observer.didAddProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
            ),
          ]);

          expect(mid.read(provider), 0);

          verify(
            observer.didAddProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: root),
              ),
              0,
            ),
          ).called(1);

          verifyNoMoreInteractions(observer3);
          verifyNoMoreInteractions(observer2);
          verifyNoMoreInteractions(observer);
        },
      );

      test('works', () {
        final observer = ObserverMock();
        final observer2 = ObserverMock();
        final provider = Provider((_) => 42);
        final container = ProviderContainer.test(
          observers: [observer, observer2],
        );

        expect(container.read(provider), 42);
        verifyInOrder([
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            42,
          ),
          observer2.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            42,
          ),
        ]);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);
      });

      test('guards against exceptions', () {
        final observer = ObserverMock();
        when(observer.didAddProvider(any, any)).thenThrow('error1');
        final observer2 = ObserverMock();
        when(observer2.didAddProvider(any, any)).thenThrow('error2');
        final observer3 = ObserverMock();
        final provider = Provider((_) => 42);
        final errors = <Object>[];
        final container =
            runZonedGuarded(
              () => ProviderContainer.test(
                observers: [observer, observer2, observer3],
              ),
              (err, stack) => errors.add(err),
            )!;

        final result = container.read(provider);

        expect(result, 42);
        expect(errors, ['error1', 'error2']);
        verifyInOrder([
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            42,
          ),
          observer2.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            42,
          ),
          observer3.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            42,
          ),
        ]);
        verifyNoMoreInteractions(observer);
      });
    });
  });

  group('didDisposeProvider', () {
    test('supports invalidate', () {
      final observer = ObserverMock();
      final container = ProviderContainer.test(observers: [observer]);
      final provider = Provider<int>((ref) => 0);

      container.read(provider);
      clearInteractions(observer);

      container.invalidate(provider);
      verifyOnly(
        observer,
        observer.didDisposeProvider(
          argThat(
            isProviderObserverContext(provider: provider, container: container),
          ),
        ),
      );

      container.invalidate(provider);
      verifyNoMoreInteractions(observer);
    });

    test('supports container dispose', () {
      final observer = ObserverMock();
      final container = ProviderContainer.test(observers: [observer]);
      final provider = StateNotifierProvider<Counter, int>((ref) => Counter());

      container.read(provider);

      clearInteractions(observer);

      container.dispose();

      verifyInOrder([
        observer.didDisposeProvider(
          argThat(
            isProviderObserverContext(provider: provider, container: container),
          ),
        ),
      ]);
      verifyNoMoreInteractions(observer);
    });

    test('supports auto-dispose', () async {
      final observer = ObserverMock();
      final container = ProviderContainer.test(observers: [observer]);
      final provider = StateNotifierProvider.autoDispose<Counter, int>((ref) {
        return Counter();
      });

      final sub = container.listen(provider, (_, __) {});

      clearInteractions(observer);

      sub.close();
      await container.pump();

      verifyInOrder([
        observer.didDisposeProvider(
          argThat(
            isProviderObserverContext(provider: provider, container: container),
          ),
        ),
      ]);
      verifyNoMoreInteractions(observer);
    });

    test('is guarded', () {
      final observer = ObserverMock();
      when(observer.didDisposeProvider(any)).thenThrow('error1');
      final observer2 = ObserverMock();
      when(observer2.didDisposeProvider(any)).thenThrow('error2');
      final observer3 = ObserverMock();
      final onDispose = OnDisposeMock();
      final provider = Provider((ref) {
        ref.onDispose(onDispose.call);
        return 0;
      });
      final provider2 = Provider((ref) => ref.watch(provider));
      final errors = <Object>[];
      final container =
          runZonedGuarded(
            () => ProviderContainer.test(
              observers: [observer, observer2, observer3],
            ),
            (err, stack) => errors.add(err),
          )!;

      expect(container.read(provider), 0);
      expect(container.read(provider2), 0);
      clearInteractions(observer);
      clearInteractions(observer2);
      clearInteractions(observer3);
      verifyNoMoreInteractions(onDispose);

      container.dispose();

      expect(errors, ['error1', 'error2', 'error1', 'error2']);
      verifyInOrder([
        observer.didDisposeProvider(
          argThat(
            isProviderObserverContext(
              provider: provider2,
              container: container,
            ),
          ),
        ),
        observer2.didDisposeProvider(
          argThat(
            isProviderObserverContext(
              provider: provider2,
              container: container,
            ),
          ),
        ),
        observer3.didDisposeProvider(
          argThat(
            isProviderObserverContext(
              provider: provider2,
              container: container,
            ),
          ),
        ),
        onDispose(),
        observer.didDisposeProvider(
          argThat(
            isProviderObserverContext(provider: provider, container: container),
          ),
        ),
        observer2.didDisposeProvider(
          argThat(
            isProviderObserverContext(provider: provider, container: container),
          ),
        ),
        observer3.didDisposeProvider(
          argThat(
            isProviderObserverContext(provider: provider, container: container),
          ),
        ),
      ]);
      verifyNoMoreInteractions(onDispose);
      verifyNoMoreInteractions(observer);
      verifyNoMoreInteractions(observer2);
      verifyNoMoreInteractions(observer3);
    });
  });
}

class OnDisposeMock extends Mock {
  void call();
}

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;

  @override
  abstract int state;
}

final class ConstObserver extends ProviderObserver {
  const ConstObserver();
}
