import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('ProviderObserver', () {
    test('ProviderObservers can have const constructors', () {
      final root = ProviderContainer(
        observers: [
          const ConstObserver(),
        ],
      );

      root.dispose();
    });

    group('didUpdateProvider', () {
      test(
          'on scoped ProviderContainer, applies both child and ancestors observers',
          () {
        final provider = StateNotifierProvider<StateController<int>, int>(
          (ref) => StateController(0),
        );
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
          overrides: [provider.overrideWithValue(StateController(42))],
          observers: [observer3],
        );

        expect(child.read(provider), 42);
        expect(mid.read(provider), 0);

        clearInteractions(observer3);
        clearInteractions(observer2);
        clearInteractions(observer);

        child.read(provider.notifier).state++;

        verifyInOrder([
          observer3.didUpdateProvider(provider, 42, 43, child),
          observer2.didUpdateProvider(provider, 42, 43, child),
          observer.didUpdateProvider(provider, 42, 43, child),
        ]);

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

        container.read(computed);
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
        final observer = ObserverMock();
        final observer2 = ObserverMock();
        final provider = StateNotifierProvider<Counter, int>((_) => Counter());
        final counter = Counter();
        final container = createContainer(
          overrides: [
            provider.overrideWithValue(counter),
          ],
          observers: [observer, observer2],
        );
        final listener = Listener<int>();

        container.listen(provider, listener, fireImmediately: true);

        verify(listener(0)).called(1);
        verifyNoMoreInteractions(listener);
        verifyInOrder([
          observer.didAddProvider(
            provider.notifier,
            counter,
            container,
          ),
          observer2.didAddProvider(provider.notifier, counter, container),
          observer.didAddProvider(provider, 0, container),
          observer2.didAddProvider(provider, 0, container),
        ]);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);

        counter.increment();

        verifyInOrder([
          listener(1),
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
          overrides: [
            provider.overrideWithValue(counter),
          ],
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

        container.listen(isNegative, isNegativeListener, fireImmediately: true);

        clearInteractions(observer);
        verifyOnly(isNegativeListener, isNegativeListener(false));

        counter.increment();
        await container.pump();

        verifyInOrder([
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
          observer.didUpdateProvider(
            provider,
            1,
            -10,
            container,
          ),
          isNegativeListener(true),
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

    group('didAddProvider', () {
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
        final provider = Provider((_) => 0);
        final container = createContainer(
          overrides: [
            provider.overrideWithProvider(Provider((_) => 42)),
          ],
          observers: [observer, observer2],
        );

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
          )
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
        final provider = Provider((_) => 0);
        final container = createContainer(
          overrides: [
            provider.overrideWithProvider(Provider((_) => 42)),
          ],
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
    test('supports container dispose', () {
      final observer = ObserverMock();
      final container = createContainer(observers: [observer]);
      final provider = StateNotifierProvider<Counter, int>((ref) => Counter());

      container.read(provider);

      clearInteractions(observer);

      container.dispose();

      verifyInOrder([
        observer.didDisposeProvider(provider, container),
        observer.didDisposeProvider(provider.notifier, container),
      ]);
      verifyNoMoreInteractions(observer);
    });

    test('supports auto-dispose', () async {
      final observer = ObserverMock();
      final container = createContainer(observers: [observer]);
      final provider = StateNotifierProvider.autoDispose<Counter, int>((ref) {
        return Counter();
      });

      final sub = container.listen(provider, (_) {});

      clearInteractions(observer);

      sub.close();
      await container.pump();

      verifyInOrder([
        observer.didDisposeProvider(provider, container),
        observer.didDisposeProvider(provider.notifier, container),
      ]);
      verifyNoMoreInteractions(observer);
    });

    test('is guarded', () {
      final observer = ObserverMock();
      when(observer.didDisposeProvider(any, any)).thenThrow('error1');
      final observer2 = ObserverMock();
      when(observer2.didDisposeProvider(any, any)).thenThrow('error2');
      final observer3 = ObserverMock();
      final provider = Provider((_) => 0);
      final provider2 = Provider((ref) => ref.watch(provider));
      final onDispose = OnDisposeMock();
      final container = createContainer(
        overrides: [
          provider.overrideWithProvider(Provider((ref) {
            ref.onDispose(onDispose);
            return 0;
          })),
        ],
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

class Listener<T> extends Mock {
  void call(T value);
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
