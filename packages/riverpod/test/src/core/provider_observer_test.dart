import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('ProviderObserver', () {
    test('life-cycles do nothing by default', () {
      const observer = ConstObserver();

      final provider = Provider((ref) => 0);
      final container = createContainer();

      observer.didAddProvider(provider, 0, container);
      observer.didDisposeProvider(provider, container);
      observer.didUpdateProvider(provider, 0, 0, container);
      observer.providerDidFail(provider, 0, StackTrace.empty, container);
    });

    test('ProviderObservers can have const constructors', () {
      final root = createContainer(
        observers: [
          const ConstObserver(),
        ],
      );

      root.dispose();
    });

    group('didUpdateProvider', () {
      test('after an error didUpdateProvider receives null as previous value ',
          () async {
        final observer = ObserverMock();
        final observer2 = ObserverMock();
        final container = createContainer(observers: [observer, observer2]);
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
            provider,
            null,
            0,
            container,
          ),
          observer2.didUpdateProvider(
            provider,
            null,
            0,
            container,
          ),
        ]);
        verifyNever(observer.providerDidFail(any, any, any, any));
      });

      test(
          'on scoped ProviderContainer, applies both child and ancestors observers',
          () {
        final provider = StateNotifierProvider<StateController<int>, int>(
          (ref) => StateController(0),
        );
        final observer = ObserverMock('a');
        final observer2 = ObserverMock('b');
        final observer3 = ObserverMock('c');

        final root = createContainer(observers: [observer]);
        final mid = createContainer(
          parent: root,
          observers: [observer2],
        );
        final child = createContainer(
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

        verify(observer.didUpdateProvider(provider, 42, 43, child)).called(1);
        verify(observer2.didUpdateProvider(provider, 42, 43, child)).called(1);
        verify(observer3.didUpdateProvider(provider, 42, 43, child)).called(1);

        mid.read(provider.notifier).state++;

        verify(observer.didUpdateProvider(provider, 0, 1, root)).called(1);

        verifyNoMoreInteractions(observer3);
        verifyNoMoreInteractions(observer2);
        verifyNoMoreInteractions(observer);
      });

      test('handles computed provider update', () async {
        final observer = ObserverMock();
        final container = createContainer(observers: [observer]);
        final notifier = Counter();
        final provider = StateNotifierProvider<Counter, int>((_) => notifier);
        final computed = Provider((ref) => ref.watch(provider));

        container.listen(computed, (_, __) {});
        notifier.increment();

        clearInteractions(observer);

        await container.pump();

        verifyOnly(
          observer,
          observer.didUpdateProvider(computed, 0, 1, container),
        ).called(1);
      });

      test('handles direct provider update', () {
        final observer = ObserverMock();
        final container = createContainer(observers: [observer]);
        final notifier = Counter();
        final provider = StateNotifierProvider<Counter, int>((_) => notifier);

        container.read(provider);
        clearInteractions(observer);

        notifier.increment();

        verifyOnly(
          observer,
          observer.didUpdateProvider(provider, 0, 1, container),
        ).called(1);
      });

      test('didUpdateProviders', () {
        final observer = ObserverMock('a');
        final observer2 = ObserverMock('b');
        final provider = StateNotifierProvider<Counter, int>((_) => Counter());
        final counter = Counter();
        final container = createContainer(
          overrides: [
            provider.overrideWith((ref) => counter),
          ],
          observers: [observer, observer2],
        );
        final listener = Listener<int>();

        container.listen(provider, listener.call, fireImmediately: true);

        verify(listener(null, 0)).called(1);
        verifyNoMoreInteractions(listener);
        verifyInOrder([
          observer.didAddProvider(provider, 0, container),
          observer2.didAddProvider(provider, 0, container),
        ]);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);

        counter.increment();

        verifyInOrder([
          listener(0, 1),
          observer.didUpdateProvider(provider, 0, 1, container),
          observer2.didUpdateProvider(provider, 0, 1, container),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);
      });

      test('guards didUpdateProviders', () {
        final observer = ObserverMock();
        when(observer.didUpdateProvider(any, any, any, any))
            .thenThrow('error1');
        final observer2 = ObserverMock();
        when(observer2.didUpdateProvider(any, any, any, any))
            .thenThrow('error2');
        final observer3 = ObserverMock();
        final provider = StateNotifierProvider<Counter, int>((_) => Counter());
        final counter = Counter();
        final container = createContainer(
          overrides: [provider.overrideWith((ref) => counter)],
          observers: [observer, observer2, observer3],
        );

        container.read(provider);

        clearInteractions(observer);
        clearInteractions(observer2);
        clearInteractions(observer3);

        final errors = <Object>[];
        runZonedGuarded(counter.increment, (err, stack) => errors.add(err));

        expect(errors, ['error1', 'error2']);
        verifyInOrder([
          observer.didUpdateProvider(provider, 0, 1, container),
          observer2.didUpdateProvider(provider, 0, 1, container),
          observer3.didUpdateProvider(provider, 0, 1, container),
        ]);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);
        verifyNoMoreInteractions(observer3);
      });

      test("Computed don't call didUpdateProviders when value doesn't change",
          () async {
        final observer = ObserverMock();
        final counter = Counter();
        final provider = StateNotifierProvider<Counter, int>((_) => counter);
        final isNegative = Provider((ref) {
          return ref.watch(provider).isNegative;
        });
        final container = createContainer(observers: [observer]);
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
          observer.didDisposeProvider(isNegative, container),
          observer.didUpdateProvider(
            provider,
            0,
            1,
            container,
          ),
        ]);
        verifyNoMoreInteractions(observer);

        counter.setState(-10);
        await container.pump();

        verifyInOrder([
          observer.didDisposeProvider(isNegative, container),
          observer.didUpdateProvider(
            provider,
            1,
            -10,
            container,
          ),
          isNegativeListener(false, true),
          observer.didUpdateProvider(
            isNegative,
            false,
            true,
            container,
          ),
        ]);
        verifyNoMoreInteractions(isNegativeListener);
        verifyNoMoreInteractions(observer);
      });
    });

    group('providerDidFail', () {
      test(
          'on scoped ProviderContainer, applies both child and ancestors observers',
          () async {
        final dep = StateProvider((ref) => 0);
        final provider = StateNotifierProvider<StateController<int>, int>(
          (ref) => StateController(0),
        );
        final observer = ObserverMock('a');
        final observer2 = ObserverMock('b');
        final observer3 = ObserverMock('c');

        final root = createContainer(observers: [observer]);
        final mid = createContainer(
          parent: root,
          observers: [observer2],
        );
        final child = createContainer(
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
          observer.didDisposeProvider(provider, child),
          observer.didUpdateProvider(dep, 0, 1, root),
          observer.didUpdateProvider(provider, 42, null, child),
          observer.providerDidFail(provider, 'error', StackTrace.empty, child),
        ]);
        verifyInOrder([
          observer2.didDisposeProvider(provider, child),
          observer2.didUpdateProvider(provider, 42, null, child),
          observer2.providerDidFail(provider, 'error', StackTrace.empty, child),
        ]);
        verifyInOrder([
          observer3.didDisposeProvider(provider, child),
          observer3.didUpdateProvider(provider, 42, null, child),
          observer3.providerDidFail(provider, 'error', StackTrace.empty, child),
        ]);

        verifyNoMoreInteractions(observer3);
        verifyNoMoreInteractions(observer2);
        verifyNoMoreInteractions(observer);
      });

      test('is called when FutureProvider emits an error', () async {
        final observer = ObserverMock();
        final container = createContainer(observers: [observer]);
        final provider = FutureProvider(
          (ref) => Future<void>.error('error', StackTrace.empty),
        );

        container.listen(provider, (_, __) {});
        await container.read(provider.future).catchError((_) {});

        verifyInOrder([
          observer.didAddProvider(
            provider,
            const AsyncLoading<void>(),
            container,
          ),
          observer.didUpdateProvider(
            provider,
            const AsyncLoading<void>(),
            const AsyncError<void>('error', StackTrace.empty),
            container,
          ),
          observer.providerDidFail(
            provider,
            'error',
            StackTrace.empty,
            container,
          ),
        ]);
      });

      test('is called when StreamProvider emits an error', () async {
        final observer = ObserverMock();
        final container = createContainer(observers: [observer]);
        final provider = StreamProvider(
          (ref) => Stream<void>.error('error', StackTrace.empty),
        );

        container.listen(provider, (_, __) {});
        await container.read(provider.future).catchError((_) {});

        verifyInOrder([
          observer.didAddProvider(
            provider,
            const AsyncLoading<void>(),
            container,
          ),
          observer.didUpdateProvider(
            provider,
            const AsyncLoading<void>(),
            const AsyncError<void>('error', StackTrace.empty),
            container,
          ),
          observer.providerDidFail(
            provider,
            'error',
            StackTrace.empty,
            container,
          ),
        ]);
      });

      test('is called on uncaught error during first initialization', () {
        final observer = ObserverMock();
        final observer2 = ObserverMock();
        final container = createContainer(observers: [observer, observer2]);
        final provider = Provider((ref) => throw UnimplementedError());

        expect(
          () => container.read(provider),
          throwsUnimplementedError,
        );

        verifyInOrder([
          observer.didAddProvider(provider, null, container),
          observer2.didAddProvider(provider, null, container),
          observer.providerDidFail(
            provider,
            argThat(isUnimplementedError),
            argThat(isNotNull),
            container,
          ),
          observer2.providerDidFail(
            provider,
            argThat(isUnimplementedError),
            argThat(isNotNull),
            container,
          ),
        ]);
        verifyNoMoreInteractions(observer);
      });

      test('is called on uncaught error after update ', () async {
        final observer = ObserverMock();
        final observer2 = ObserverMock();
        final container = createContainer(observers: [observer, observer2]);
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
            provider,
            0,
            null,
            container,
          ),
          observer2.didUpdateProvider(
            provider,
            0,
            null,
            container,
          ),
          observer.providerDidFail(
            provider,
            argThat(isUnimplementedError),
            argThat(isNotNull),
            container,
          ),
          observer2.providerDidFail(
            provider,
            argThat(isUnimplementedError),
            argThat(isNotNull),
            container,
          ),
        ]);
      });
    });

    group('didAddProvider', () {
      test('when throwing during creation, receives `null` as value', () {
        final observer = ObserverMock();
        final container = createContainer(observers: [observer]);
        final provider = Provider((ref) => throw UnimplementedError());

        expect(
          () => container.read(provider),
          throwsUnimplementedError,
        );

        verify(observer.didAddProvider(provider, null, container));
      });

      test(
          'on scoped ProviderContainer, applies both child and ancestors observers',
          () {
        final provider = Provider((ref) => 0);
        final observer = ObserverMock();
        final observer2 = ObserverMock();
        final observer3 = ObserverMock();
        final root = createContainer(observers: [observer]);
        final mid = createContainer(
          parent: root,
          observers: [observer2],
        );
        final child = createContainer(
          parent: mid,
          overrides: [provider.overrideWithValue(42)],
          observers: [observer3],
        );

        expect(child.read(provider), 42);

        verifyInOrder([
          observer3.didAddProvider(provider, 42, child),
          observer2.didAddProvider(provider, 42, child),
          observer.didAddProvider(provider, 42, child),
        ]);

        expect(mid.read(provider), 0);

        verify(observer.didAddProvider(provider, 0, root)).called(1);

        verifyNoMoreInteractions(observer3);
        verifyNoMoreInteractions(observer2);
        verifyNoMoreInteractions(observer);
      });

      test('works', () {
        final observer = ObserverMock();
        final observer2 = ObserverMock();
        final provider = Provider((_) => 42);
        final container = createContainer(observers: [observer, observer2]);

        expect(container.read(provider), 42);
        verifyInOrder([
          observer.didAddProvider(
            provider,
            42,
            container,
          ),
          observer2.didAddProvider(
            provider,
            42,
            container,
          ),
        ]);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);
      });

      test('guards against exceptions', () {
        final observer = ObserverMock();
        when(observer.didAddProvider(any, any, any)).thenThrow('error1');
        final observer2 = ObserverMock();
        when(observer2.didAddProvider(any, any, any)).thenThrow('error2');
        final observer3 = ObserverMock();
        final provider = Provider((_) => 42);
        final container = createContainer(
          observers: [observer, observer2, observer3],
        );

        final errors = <Object>[];
        final result = runZonedGuarded(
          () => container.read(provider),
          (err, stack) {
            errors.add(err);
          },
        );

        expect(result, 42);
        expect(errors, ['error1', 'error2']);
        verifyInOrder([
          observer.didAddProvider(provider, 42, container),
          observer2.didAddProvider(provider, 42, container),
          observer3.didAddProvider(provider, 42, container),
        ]);
        verifyNoMoreInteractions(observer);
      });
    });
  });

  group('didDisposeProvider', () {
    test('supports invalidate', () {
      final observer = ObserverMock();
      final container = createContainer(observers: [observer]);
      final provider = Provider<int>((ref) => 0);

      container.read(provider);
      clearInteractions(observer);

      container.invalidate(provider);
      verifyOnly(observer, observer.didDisposeProvider(provider, container));

      container.invalidate(provider);
      verifyNoMoreInteractions(observer);
    });

    test('supports container dispose', () {
      final observer = ObserverMock();
      final container = createContainer(observers: [observer]);
      final provider = StateNotifierProvider<Counter, int>((ref) => Counter());

      container.read(provider);

      clearInteractions(observer);

      container.dispose();

      verifyInOrder([
        observer.didDisposeProvider(provider, container),
      ]);
      verifyNoMoreInteractions(observer);
    });

    test('supports auto-dispose', () async {
      final observer = ObserverMock();
      final container = createContainer(observers: [observer]);
      final provider = StateNotifierProvider.autoDispose<Counter, int>((ref) {
        return Counter();
      });

      final sub = container.listen(provider, (_, __) {});

      clearInteractions(observer);

      sub.close();
      await container.pump();

      verifyInOrder([
        observer.didDisposeProvider(provider, container),
      ]);
      verifyNoMoreInteractions(observer);
    });

    test('is guarded', () {
      final observer = ObserverMock();
      when(observer.didDisposeProvider(any, any)).thenThrow('error1');
      final observer2 = ObserverMock();
      when(observer2.didDisposeProvider(any, any)).thenThrow('error2');
      final observer3 = ObserverMock();
      final onDispose = OnDisposeMock();
      final provider = Provider((ref) {
        ref.onDispose(onDispose.call);
        return 0;
      });
      final provider2 = Provider((ref) => ref.watch(provider));
      final container = createContainer(
        observers: [observer, observer2, observer3],
      );

      expect(container.read(provider), 0);
      expect(container.read(provider2), 0);
      clearInteractions(observer);
      clearInteractions(observer2);
      clearInteractions(observer3);
      verifyNoMoreInteractions(onDispose);

      final errors = <Object>[];
      runZonedGuarded(container.dispose, (err, stack) => errors.add(err));

      expect(errors, ['error1', 'error2', 'error1', 'error2']);
      verifyInOrder([
        observer.didDisposeProvider(provider2, container),
        observer2.didDisposeProvider(provider2, container),
        observer3.didDisposeProvider(provider2, container),
        onDispose(),
        observer.didDisposeProvider(provider, container),
        observer2.didDisposeProvider(provider, container),
        observer3.didDisposeProvider(provider, container),
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

  // ignore: use_setters_to_change_properties
  void setState(int value) => state = value;
}

class ConstObserver extends ProviderObserver {
  const ConstObserver();
}
