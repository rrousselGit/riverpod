import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test('can add observers only on the root container', () {
    final observer = ObserverMock();
    final observer2 = ObserverMock();
    final container = ProviderContainer(observers: [observer]);

    expect(
      () => ProviderContainer(parent: container, observers: [observer2]),
      throwsUnsupportedError,
    );
  });

  test('report change once even if there are multiple listeners', () {
    final observer = ObserverMock();
    final container = ProviderContainer(observers: [observer]);
    final notifier = Counter();
    final provider = StateNotifierProvider<Counter, int>((_) => notifier);

    final sub = container.listen(provider);

    verify(observer.didAddProvider(provider.notifier, notifier));
    verify(observer.didAddProvider(provider, 0));
    verifyNoMoreInteractions(observer);

    container.listen(provider);

    verifyNoMoreInteractions(observer);

    notifier.increment();

    verifyOnly(observer, observer.mayHaveChanged(provider));

    sub.read();

    verifyOnly(observer, observer.didUpdateProvider(provider, 1));
  });

  test('didAddProvider', () {
    final observer = ObserverMock();
    final observer2 = ObserverMock();
    final provider = Provider((_) => 0);
    final container = ProviderContainer(
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

  test('catch exceptions on didAddProvider', () {
    final observer = ObserverMock();
    when(observer.didAddProvider(any, any)).thenThrow('error1');
    final observer2 = ObserverMock();
    when(observer2.didAddProvider(any, any)).thenThrow('error2');
    final observer3 = ObserverMock();
    final provider = Provider((_) => 0);
    final container = ProviderContainer(
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

  test('didUpdateProviders', () {
    final observer = ObserverMock();
    final observer2 = ObserverMock();
    final provider = StateNotifierProvider<Counter, int>((_) => Counter());
    final counter = Counter();
    final container = ProviderContainer(
      overrides: [
        provider.overrideWithValue(counter),
      ],
      observers: [observer, observer2],
    );
    final listener = Listener<int>();

    final sub = provider.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

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

    verifyNoMoreInteractions(listener);
    verifyOnly(observer, observer.mayHaveChanged(provider));
    verifyOnly(observer2, observer2.mayHaveChanged(provider));

    sub.flush();

    verifyInOrder([
      listener(1),
      observer.didUpdateProvider(provider, 1),
      observer2.didUpdateProvider(provider, 1),
    ]);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(observer);
    verifyNoMoreInteractions(observer2);
  });

  test('guards mayHaveChanged', () {
    final observer = ObserverMock();
    when(observer.mayHaveChanged(any)).thenThrow('error1');
    final observer2 = ObserverMock();
    when(observer2.mayHaveChanged(any)).thenThrow('error2');
    final observer3 = ObserverMock();
    final provider = StateNotifierProvider<Counter, int>((_) => Counter());
    final counter = Counter();
    final container = ProviderContainer(
      overrides: [
        provider.overrideWithValue(counter),
      ],
      observers: [observer, observer2, observer3],
    );
    final listener = Listener<int>();

    provider.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    clearInteractions(observer);
    clearInteractions(observer2);
    clearInteractions(observer3);

    final errors = <Object>[];
    runZonedGuarded(counter.increment, (err, stack) => errors.add(err));

    expect(errors, ['error1', 'error2']);
    verifyInOrder([
      observer.mayHaveChanged(provider),
      observer2.mayHaveChanged(provider),
      observer3.mayHaveChanged(provider),
    ]);
    verifyNoMoreInteractions(observer);
    verifyNoMoreInteractions(observer2);
    verifyNoMoreInteractions(observer3);
  });

  test('guards didUpdateProviders', () {
    final observer = ObserverMock();
    when(observer.didUpdateProvider(any, any)).thenThrow('error1');
    final observer2 = ObserverMock();
    when(observer2.didUpdateProvider(any, any)).thenThrow('error2');
    final observer3 = ObserverMock();
    final provider = StateNotifierProvider<Counter, int>((_) => Counter());
    final counter = Counter();
    final container = ProviderContainer(
      overrides: [
        provider.overrideWithValue(counter),
      ],
      observers: [observer, observer2, observer3],
    );
    final listener = Listener<int>();

    final sub = provider.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    clearInteractions(observer);
    clearInteractions(observer2);
    clearInteractions(observer3);

    counter.increment();

    clearInteractions(observer);
    clearInteractions(observer2);
    clearInteractions(observer3);

    final errors = <Object>[];
    runZonedGuarded(sub.flush, (err, stack) => errors.add(err));

    expect(errors, ['error1', 'error2']);
    verifyInOrder([
      observer.didUpdateProvider(provider, 1),
      observer2.didUpdateProvider(provider, 1),
      observer3.didUpdateProvider(provider, 1),
    ]);
    verifyNoMoreInteractions(observer);
    verifyNoMoreInteractions(observer2);
    verifyNoMoreInteractions(observer3);
  });

  test("Computed don't call didUpdateProviders when value doesn't change", () {
    final observer = ObserverMock();
    final counter = Counter();
    final provider = StateNotifierProvider<Counter, int>((_) => counter);
    final isNegative = Provider((ref) {
      return ref.watch(provider).isNegative;
    });
    final container = ProviderContainer(observers: [observer]);
    final isNegativeListener = Listener<bool>();

    final sub = isNegative.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: isNegativeListener,
    );

    verifyInOrder([
      observer.didAddProvider(provider.notifier, counter),
      observer.didAddProvider(provider, 0),
      observer.didAddProvider(isNegative, false),
      isNegativeListener(false),
    ]);
    verifyNoMoreInteractions(isNegativeListener);
    verifyNoMoreInteractions(observer);

    counter.increment();

    verifyNoMoreInteractions(isNegativeListener);
    verify(observer.mayHaveChanged(isNegative));
    verify(observer.mayHaveChanged(provider));
    verifyNoMoreInteractions(observer);

    sub.flush();

    verifyInOrder([
      observer.didUpdateProvider(provider, 1),
    ]);
    verifyNoMoreInteractions(isNegativeListener);
    verifyNoMoreInteractions(observer);

    counter.setState(-10);

    verifyNoMoreInteractions(isNegativeListener);
    verify(observer.mayHaveChanged(isNegative));
    verify(observer.mayHaveChanged(provider));
    verifyNoMoreInteractions(observer);

    sub.flush();

    verifyInOrder([
      observer.didUpdateProvider(provider, -10),
      isNegativeListener(true),
      observer.didUpdateProvider(isNegative, true),
    ]);
    verifyNoMoreInteractions(isNegativeListener);
    verifyNoMoreInteractions(observer);
  });

  test('guards didDisposeProvider', () {
    final observer = ObserverMock();
    when(observer.didDisposeProvider(any)).thenThrow('error1');
    final observer2 = ObserverMock();
    when(observer2.didDisposeProvider(any)).thenThrow('error2');
    final observer3 = ObserverMock();
    final provider = Provider((_) => 0);
    final provider2 = Provider((ref) => ref.watch(provider));
    final onDispose = OnDisposeMock();
    final container = ProviderContainer(
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
