import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

void main() {
  test('report change once even if there are multiple listeners', () {
    final observer = ObserverMock();
    final owner = ProviderStateOwner(observers: [observer]);
    final notifier = Counter();
    final provider = StateNotifierProvider((_) => notifier);

    provider.state.watchOwner(owner, (value) {});
    provider.state.watchOwner(owner, (value) {});

    verify(observer.didAddProvider(provider, notifier));
    verify(observer.didAddProvider(provider.state, 0));
    verifyNoMoreInteractions(observer);

    notifier.increment();

    verify(observer.didUpdateProvider(provider.state, 1));

    verifyNoMoreInteractions(observer);
  });
  test('didAddProvider', () {
    final observer = ObserverMock();
    final observer2 = ObserverMock();
    final provider = Provider((_) => 0);
    final owner = ProviderStateOwner(
      overrides: [
        provider.overrideAs(Provider((_) => 42)),
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
        provider.overrideAs(Provider((_) => 42)),
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
        provider.overrideAs(StateNotifierProvider((_) => counter)),
      ],
      observers: [observer, observer2],
    );
    final listener = Listener<int>();

    final sub = provider.state.addLazyListener(
      owner,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    verifyInOrder([
      observer.didAddProvider(provider, counter),
      observer2.didAddProvider(provider, counter),
      observer.didAddProvider(provider.state, 0),
      observer2.didAddProvider(provider.state, 0)
    ]);
    verifyNoMoreInteractions(observer);
    verifyNoMoreInteractions(observer2);

    counter.increment();

    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(observer);
    verifyNoMoreInteractions(observer2);

    sub.flush();

    verifyInOrder([
      observer.didUpdateProvider(provider.state, 1),
      observer2.didUpdateProvider(provider.state, 1),
      listener(1),
    ]);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(observer);
    verifyNoMoreInteractions(observer2);
  });
  test('guards didUpdateProviders', () {
    final observer = ObserverMock();
    when(observer.didUpdateProvider(any, any)).thenThrow('error1');
    final observer2 = ObserverMock();
    when(observer2.didUpdateProvider(any, any)).thenThrow('error2');
    final observer3 = ObserverMock();
    final provider = StateNotifierProvider((_) => Counter());
    final counter = Counter();
    final owner = ProviderStateOwner(
      overrides: [
        provider.overrideAs(StateNotifierProvider((_) => counter)),
      ],
      observers: [observer, observer2, observer3],
    );
    final listener = Listener<int>();

    final sub = provider.state.addLazyListener(
      owner,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    clearInteractions(observer);
    clearInteractions(observer2);
    clearInteractions(observer3);

    counter.increment();

    verifyNoMoreInteractions(observer);
    verifyNoMoreInteractions(observer2);

    final errors = <Object>[];
    runZonedGuarded(sub.flush, (err, stack) => errors.add(err));

    expect(errors, ['error1', 'error2']);
    verifyInOrder([
      observer.didUpdateProvider(provider.state, 1),
      observer2.didUpdateProvider(provider.state, 1),
      observer3.didUpdateProvider(provider.state, 1),
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
      return read(provider.state).isNegative;
    });
    final owner = ProviderStateOwner(observers: [observer]);
    final isNegativeListener = Listener<bool>();

    final sub = isNegative.addLazyListener(
      owner,
      mayHaveChanged: () {},
      onChange: isNegativeListener,
    );

    verifyInOrder([
      observer.didAddProvider(provider, counter),
      observer.didAddProvider(provider.state, 0),
      observer.didAddProvider(isNegative, false),
      isNegativeListener(false),
    ]);
    verifyNoMoreInteractions(isNegativeListener);
    verifyNoMoreInteractions(observer);

    counter.increment();
    verifyNoMoreInteractions(isNegativeListener);
    verifyNoMoreInteractions(observer);

    sub.flush();

    verifyInOrder([
      observer.didUpdateProvider(provider.state, 1),
    ]);
    verifyNoMoreInteractions(isNegativeListener);
    verifyNoMoreInteractions(observer);

    counter.setState(-10);
    verifyNoMoreInteractions(isNegativeListener);
    verifyNoMoreInteractions(observer);

    sub.flush();

    verifyInOrder([
      observer.didUpdateProvider(provider.state, -10),
      observer.didUpdateProvider(isNegative, true),
      isNegativeListener(true),
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
    final provider2 = Provider((ref) => ref.dependOn(provider).value);
    final onDispose = OnDisposeMock();
    final owner = ProviderStateOwner(
      overrides: [
        provider.overrideAs(Provider((ref) {
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

class ObserverMock extends Mock implements ProviderStateOwnerObserver {}

// can subclass ProviderStateOwnerObserver without implementing all life-cycles
class CustomObserver extends ProviderStateOwnerObserver {}
