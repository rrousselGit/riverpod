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

    test('can add observers only on the root container', () {
      final observer = ObserverMock();
      final observer2 = ObserverMock();
      final container = createContainer(observers: [observer]);

      expect(
        () => createContainer(parent: container, observers: [observer2]),
        throwsUnsupportedError,
      );
    });

    group('didUpdateProvider', () {
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

        verifyOnly(observer, observer.didUpdateProvider(computed, 0, 1))
            .called(1);
      });

      test('handles direct provider update', () {
        final observer = ObserverMock();
        final container = createContainer(observers: [observer]);
        final notifier = Counter();
        final provider = StateNotifierProvider<Counter, int>((_) => notifier);

        container.read(provider);
        clearInteractions(observer);

        notifier.increment();

        verifyOnly(observer, observer.didUpdateProvider(provider, 0, 1))
            .called(1);
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
          observer.didAddProvider(provider.notifier, counter),
          observer2.didAddProvider(provider.notifier, counter),
          observer.didAddProvider(provider, 0),
          observer2.didAddProvider(provider, 0),
        ]);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);

        counter.increment();

        verifyInOrder([
          listener(1),
          observer.didUpdateProvider(provider, 0, 1),
          observer2.didUpdateProvider(provider, 0, 1),
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
          observer.didUpdateProvider(provider, 0, 1),
          observer2.didUpdateProvider(provider, 0, 1),
          observer3.didUpdateProvider(provider, 0, 1),
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
          observer.didUpdateProvider(provider, 0, 1),
        ]);
        verifyNoMoreInteractions(observer);

        counter.setState(-10);
        await container.pump();

        verifyInOrder([
          observer.didUpdateProvider(provider, 1, -10),
          isNegativeListener(true),
          observer.didUpdateProvider(isNegative, false, true),
        ]);
        verifyNoMoreInteractions(isNegativeListener);
        verifyNoMoreInteractions(observer);
      });
    });

    group('didAddProvider', () {
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
          observer.didAddProvider(provider, 42),
          observer2.didAddProvider(provider, 42)
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
          observer.didAddProvider(provider, 42),
          observer2.didAddProvider(provider, 42),
          observer3.didAddProvider(provider, 42),
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
        observer.didDisposeProvider(provider),
        observer.didDisposeProvider(provider.notifier),
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
        observer.didDisposeProvider(provider),
        observer.didDisposeProvider(provider.notifier),
      ]);
      verifyNoMoreInteractions(observer);
    });

    test('is guarded', () {
      final observer = ObserverMock();
      when(observer.didDisposeProvider(any)).thenThrow('error1');
      final observer2 = ObserverMock();
      when(observer2.didDisposeProvider(any)).thenThrow('error2');
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
        observer.didDisposeProvider(provider2),
        observer2.didDisposeProvider(provider2),
        observer3.didDisposeProvider(provider2),
        onDispose(),
        observer.didDisposeProvider(provider),
        observer2.didDisposeProvider(provider),
        observer3.didDisposeProvider(provider),
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
