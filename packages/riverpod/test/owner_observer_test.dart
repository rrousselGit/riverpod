import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

void main() {
  test('didAddProvider', () {
    final observer = ObserverMock();
    final observer2 = ObserverMock();
    final provider = Provider((_) => 0);
    final owner = ProviderStateOwner(
      overrides: [
        provider.overrideForSubtree(Provider((_) => 42)),
      ],
      observers: [observer, observer2],
    );

    expect(provider.readOwner(owner), 42);
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
    final owner = ProviderStateOwner(
      overrides: [
        provider.overrideForSubtree(Provider((_) => 42)),
      ],
      observers: [observer, observer2, observer3],
    );

    final errors = <Object>[];
    final result = runZonedGuarded(
      () => provider.readOwner(owner),
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
    final provider = StateNotifierProvider((_) => Counter());
    final counter = Counter();
    final owner = ProviderStateOwner(
      overrides: [
        provider.overrideForSubtree(StateNotifierProvider((_) => counter)),
      ],
      observers: [observer, observer2],
    );

    expect(provider.value.readOwner(owner), 0);
    verifyInOrder([
      observer.didAddProvider(provider, counter),
      observer2.didAddProvider(provider, counter),
      observer.didAddProvider(provider.value, 0),
      observer2.didAddProvider(provider.value, 0)
    ]);
    verifyNoMoreInteractions(observer);
    verifyNoMoreInteractions(observer2);

    counter.increment();

    verifyNoMoreInteractions(observer);
    verifyNoMoreInteractions(observer2);

    owner.update();

    verifyInOrder([
      observer.didUpdateProviders({provider.value: 1}),
      observer2.didUpdateProviders({provider.value: 1})
    ]);
    verifyNoMoreInteractions(observer);
    verifyNoMoreInteractions(observer2);
  });
  test('guards didUpdateProviders', () {
    final observer = ObserverMock();
    when(observer.didUpdateProviders(any)).thenThrow('error1');
    final observer2 = ObserverMock();
    when(observer2.didUpdateProviders(any)).thenThrow('error2');
    final observer3 = ObserverMock();
    final provider = StateNotifierProvider((_) => Counter());
    final counter = Counter();
    final owner = ProviderStateOwner(
      overrides: [
        provider.overrideForSubtree(StateNotifierProvider((_) => counter)),
      ],
      observers: [observer, observer2, observer3],
    );

    expect(provider.value.readOwner(owner), 0);
    clearInteractions(observer);
    clearInteractions(observer2);
    clearInteractions(observer3);

    counter.increment();

    verifyNoMoreInteractions(observer);
    verifyNoMoreInteractions(observer2);

    final errors = <Object>[];
    runZonedGuarded(owner.update, (err, stack) => errors.add(err));

    expect(errors, ['error1', 'error2']);
    verifyInOrder([
      observer.didUpdateProviders({provider.value: 1}),
      observer2.didUpdateProviders({provider.value: 1}),
      observer3.didUpdateProviders({provider.value: 1}),
    ]);
    verifyNoMoreInteractions(observer);
    verifyNoMoreInteractions(observer2);
    verifyNoMoreInteractions(observer3);
  });

  test("Computed don't call didUpdateProviders when value doesn't change", () {
    final observer = ObserverMock();
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final isNegative = Computed((read) {
      return read(provider.value).isNegative;
    });
    final owner = ProviderStateOwner(observers: [observer]);
    final listener = Listener<bool>();

    isNegative.watchOwner(owner, listener);

    verifyInOrder([
      observer.didAddProvider(provider, counter),
      observer.didAddProvider(provider.value, 0),
      observer.didAddProvider(isNegative, false),
      listener(false),
    ]);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(observer);

    counter.increment();
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(observer);

    owner.update();

    verifyInOrder([
      observer.didUpdateProviders({provider.value: 1}),
    ]);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(observer);

    counter.setState(-10);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(observer);

    owner.update();

    verifyInOrder([
      listener(true),
      observer.didUpdateProviders({provider.value: -10, isNegative: true}),
    ]);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(observer);
  });
  test('guards didDisposeProvider', () {
    final observer = ObserverMock();
    when(observer.didDisposeProvider(any)).thenThrow('error1');
    final observer2 = ObserverMock();
    when(observer2.didDisposeProvider(any)).thenThrow('error2');
    final observer3 = ObserverMock();
    final provider = Provider((_) => 0);
    final provider2 = Provider((ref) => ref.dependOn(provider).value);
    final onDispose = OnDisposeMock();
    final owner = ProviderStateOwner(
      overrides: [
        provider.overrideForSubtree(Provider((ref) {
          ref.onDispose(onDispose);
          return 0;
        })),
      ],
      observers: [observer, observer2, observer3],
    );

    expect(provider.readOwner(owner), 0);
    expect(provider2.readOwner(owner), 0);
    clearInteractions(observer);
    clearInteractions(observer2);
    clearInteractions(observer3);
    verifyNoMoreInteractions(onDispose);

    final errors = <Object>[];
    runZonedGuarded(owner.dispose, (err, stack) => errors.add(err));

    expect(errors, ['error1', 'error2', 'error1', 'error2']);
    verifyInOrder([
      onDispose(),
      observer.didDisposeProvider(provider),
      observer2.didDisposeProvider(provider),
      observer3.didDisposeProvider(provider),
      observer.didDisposeProvider(provider2),
      observer2.didDisposeProvider(provider2),
      observer3.didDisposeProvider(provider2),
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

class ObserverMock extends Mock implements ProviderStateOwnerObserver {}

// can subclass ProviderStateOwnerObserver without implementing all life-cycles
class CustomObserver extends ProviderStateOwnerObserver {}
