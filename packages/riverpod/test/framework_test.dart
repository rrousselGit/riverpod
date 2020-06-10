import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';
import 'package:riverpod/riverpod.dart';

Matcher isProvider(ProviderBase provider) {
  final res = isA<ProviderStateBase>().having(
    (s) => s.provider,
    'provider',
    provider,
  );
  return res;
}

void main() {
  // TODO: throw if tried to dispose a parent owner that still have undisposed children owners
  // TODO reading unflushed triggers flush
  test('remove dependency when owner is disposed', () {
    final provider = Provider((_) {});
    final provider2 = Provider((ref) => ref.dependOn(provider));
    final root = ProviderStateOwner();
    final owner = ProviderStateOwner(
      parent: root,
      overrides: [provider2],
    );

    provider.readOwner(owner);
    provider2.readOwner(owner);

    expect(root.debugProviderStates, [isProvider(provider)]);
    final state = root.debugProviderStates.first;
    expect(owner.debugProviderStates, [isProvider(provider2)]);
    final state2 = owner.debugProviderStates.first;

    expect(state.debugDependents, {state2});

    owner.dispose();

    expect(state.debugDependents, <ProviderStateBase>{});
  });

  test('depth is recursive cross ower', () {
    final provider = Provider((ref) => ref, name: '1');
    final provider2 = Provider((ref) => ref, name: '2');
    final provider3 = Provider((ref) => ref, name: '3');
    final provider4 = Provider((ref) => ref, name: '4');
    final root = ProviderStateOwner();
    final owner = ProviderStateOwner(
      parent: root,
      overrides: [provider3, provider4],
    );

    expect(owner.debugProviderStates, <Object>[]);

    provider.readOwner(owner);
    final ref2 = provider2.readOwner(owner);
    final ref3 = provider3.readOwner(owner);
    final ref4 = provider4.readOwner(owner);

    expect(
      root.debugProviderStates,
      unorderedMatches(<Object>[
        isProvider(provider2),
        isProvider(provider),
      ]),
    );
    expect(
      owner.debugProviderStates,
      unorderedMatches(<Object>[
        isProvider(provider4),
        isProvider(provider3),
      ]),
    );

    ref3.dependOn(provider2);
    ref4.dependOn(provider2);

    expect(
      root.debugProviderStates,
      unorderedMatches(<Object>[
        isProvider(provider2),
        isProvider(provider),
      ]),
    );
    expect(
      owner.debugProviderStates,
      unorderedMatches(<Object>[
        isProvider(provider4),
        isProvider(provider3),
      ]),
    );

    ref2.dependOn(provider);

    expect(root.debugProviderStates, <Object>[
      isProvider(provider),
      isProvider(provider2),
    ]);
    expect(
      owner.debugProviderStates,
      unorderedMatches(<Object>[
        isProvider(provider4),
        isProvider(provider3),
      ]),
    );
  });
  test('redepth is recursive', () {
    final owner = ProviderStateOwner();
    final provider = Provider((ref) => ref, name: '1');
    final provider2 = Provider((ref) => ref, name: '2');
    final provider3 = Provider((ref) => ref, name: '3');
    final provider4 = Provider((ref) => ref, name: '4');

    expect(owner.debugProviderStates, <Object>[]);

    provider.readOwner(owner);
    final ref2 = provider2.readOwner(owner);
    final ref3 = provider3.readOwner(owner);
    final ref4 = provider4.readOwner(owner);

    expect(
      owner.debugProviderStates,
      unorderedMatches(<Object>[
        isProvider(provider4),
        isProvider(provider3),
        isProvider(provider2),
        isProvider(provider),
      ]),
    );

    ref4.dependOn(provider3);

    expect(
      owner.debugProviderStates,
      containsAllInOrder(<Object>[
        isProvider(provider3),
        isProvider(provider4),
      ]),
    );

    ref3.dependOn(provider2);

    expect(
      owner.debugProviderStates,
      containsAllInOrder(<Object>[
        isProvider(provider2),
        isProvider(provider3),
        isProvider(provider4),
      ]),
    );

    ref2.dependOn(provider);

    expect(owner.debugProviderStates, <Object>[
      isProvider(provider),
      isProvider(provider2),
      isProvider(provider3),
      isProvider(provider4),
    ]);
  });
  test("can't call onDispose inside onDispose", () {
    final provider = Provider((ref) {
      ref.onDispose(() {
        ref.onDispose(() {});
      });
      return ref;
    });
    final owner = ProviderStateOwner();

    provider.readOwner(owner);

    final errors = <Object>[];
    runZonedGuarded(owner.dispose, (err, _) => errors.add(err));

    expect(errors, [isStateError]);
  });
  test("can't call dependOn inside onDispose", () {
    final provider2 = Provider((ref) => 0);
    final provider = Provider((ref) {
      ref.onDispose(() {
        ref.dependOn(provider2);
      });
      return ref;
    });
    final owner = ProviderStateOwner();

    provider.readOwner(owner);

    final errors = <Object>[];
    runZonedGuarded(owner.dispose, (err, _) => errors.add(err));

    expect(errors, [isStateError]);
  });
  test('owner.debugProviderValues', () {
    final unnamed = Provider((_) => 0);
    final counter = Counter();
    final named = StateNotifierProvider((_) {
      return counter;
    }, name: 'named');
    final owner = ProviderStateOwner();

    expect(owner.debugProviderValues, <ProviderBase, Object>{});

    expect(unnamed.readOwner(owner), 0);

    expect(owner.debugProviderValues, {
      unnamed: 0,
    });

    expect(named.readOwner(owner), counter);

    expect(owner.debugProviderValues, {
      unnamed: 0,
      named: counter,
    });

    expect(named.state.readOwner(owner), 0);

    expect(owner.debugProviderValues, {
      unnamed: 0,
      named: counter,
      named.state: 0,
    });
  });

  test('Circular dependency check accross multiple owners', () {
    final provider = Provider((_) => 1);
    final provider2 = Provider((_) => 2);
    final provider3 = Provider((ref) => ref.dependOn(provider2).value * 2);

    final root = ProviderStateOwner(overrides: [
      provider.overrideAs(
        Provider((ref) => ref.dependOn(provider3).value * 2),
      )
    ]);
    final owner = ProviderStateOwner(parent: root, overrides: [
      provider2.overrideAs(Provider((ref) => ref.dependOn(provider).value * 2)),
      provider3,
    ]);

    // read 3 from `owner` -> 2 from owner -> 1 from root -> 3 from root -> 2 from root
    // 2 * 2 * 2 * 2 * 2

    expect(provider3.readOwner(owner), 32);
  });
  test(
      'adding dependency on a provider from a different owner add the state to the proper owner',
      () {
    final provider1 = Provider((_) => 1);
    final provider3 = Provider((_) => '1');
    final provider2 = Provider((ref) => ref.dependOn(provider1).value * 2.5);

    final root = ProviderStateOwner();
    final owner = ProviderStateOwner(parent: root, overrides: [
      provider3,
      provider2,
    ]);

    expect(provider1.readOwner(owner), 1);
    expect(provider2.readOwner(owner), 2.5);
    expect(provider3.readOwner(owner), '1');

    expect(
      root.debugProviderStates.map((s) => s.provider),
      [provider1],
    );
    expect(
      owner.debugProviderStates.map((s) => s.provider),
      anyOf([
        [provider3, provider2],
        [provider2, provider3],
      ]),
    );
  });
  test('owner life-cycles are unusuable after dispose', () {
    final owner = ProviderStateOwner()..dispose();

    expect(owner.dispose, throwsStateError);
    expect(() => owner.debugUpdate([]), throwsStateError);
    expect(() => owner.ref, throwsStateError);
    expect(() => owner.readProviderState(Provider((_) => 0)), throwsStateError);
  });
  test('provider.overrideAs(provider) can be simplified into provider', () {
    final notifier = Counter();
    final provider = StateNotifierProvider<Counter>((_) => notifier);
    final root = ProviderStateOwner();
    final owner = ProviderStateOwner(parent: root, overrides: [provider]);

    expect(provider.readOwner(owner), notifier);
    expect(notifier.mounted, true);

    owner.dispose();

    expect(notifier.mounted, false);
  });
  test('cannot call markMayHaveChanged after dispose', () {
    final owner = ProviderStateOwner();
    final provider = TestProvider((ref) {});
    ProviderStateBase providerBaseState;
    provider.onInitState.thenAnswer((state) {
      providerBaseState = state;
    });

    provider.readOwner(owner);

    expect(providerBaseState.dirty, false);
    providerBaseState.markMayHaveChanged();
    expect(providerBaseState.dirty, true);

    provider.readOwner(owner);

    expect(providerBaseState.dirty, false);

    owner.dispose();

    expect(
      () => providerBaseState.markMayHaveChanged(),
      throwsStateError,
    );
  });
  test('owner.ref uses the override', () {
    final provider = Provider((_) => 42);
    final owner = ProviderStateOwner();
    final owner2 = ProviderStateOwner(overrides: [
      provider.overrideAs(
        Provider((_) => 21),
      ),
    ]);

    final ref = owner.ref;
    final ref2 = owner2.ref;

    expect(ref, isNot(ref2));
    expect(owner.ref, ref);
    expect(owner2.ref, ref2);

    expect(ref.dependOn(provider).value, 42);
    expect(ref2.dependOn(provider).value, 21);

    owner.debugUpdate([]);
    owner2.debugUpdate([
      provider.overrideAs(
        Provider((_) => 21),
      ),
    ]);

    expect(owner.ref, ref);
    expect(owner2.ref, ref2);
    expect(ref.dependOn(provider).value, 42);
    expect(ref2.dependOn(provider).value, 21);
  });

  test('ref.dependOn disposes the provider state', () {
    var didDispose = false;
    final provider = TestProvider((ref) {
      ref.onDispose(() => didDispose = true);
      return 0;
    });
    final other = Provider((ref) => ref.dependOn(provider));

    final owner = ProviderStateOwner();
    final owner2 = ProviderStateOwner(
      parent: owner,
      overrides: [other],
    );

    final value = other.readOwner(owner2);
    expect(value, isNotNull);
    verifyZeroInteractions(provider.onValueDispose);
    expect(didDispose, isFalse);

    owner2.dispose();

    verify(provider.onValueDispose(value));
    verifyNoMoreInteractions(provider.onValueDispose);
    expect(didDispose, isFalse);
  });
  test('Owner.dependOn', () {
    final provider = TestProvider((ref) => 0);
    final provider2 = TestProvider((ref) => 1);
    final owner = ProviderStateOwner();

    final value1 = owner.ref.dependOn(provider);
    final value2 = owner.ref.dependOn(provider);
    final value21 = owner.ref.dependOn(provider2);
    final value22 = owner.ref.dependOn(provider2);

    expect(value1, value2);
    expect(value1.value, 0);
    expect(value21, value22);
    expect(value21, isNot(value1));
    expect(value21.value, 1);

    verifyZeroInteractions(provider.onValueDispose);
    verifyZeroInteractions(provider2.onValueDispose);

    owner.dispose();

    verify(provider.onValueDispose(value1));
    verify(provider2.onValueDispose(value21));
    verifyNoMoreInteractions(provider.onValueDispose);
    verifyNoMoreInteractions(provider2.onValueDispose);
  });
  test(
      "updating overrides / dispose don't compute provider states if not loaded yet",
      () {
    var callCount = 0;
    final provider = Provider((_) => callCount++);

    final owner = ProviderStateOwner(
      overrides: [provider],
    );

    expect(callCount, 0);

    owner.debugUpdate([provider]);

    expect(callCount, 0);

    owner.dispose();

    expect(callCount, 0);
  });
  test('circular dependencies', () {
    Provider<int Function()> provider;

    final provider1 = Provider((ref) {
      return ref.dependOn(provider).value() + 1;
    });
    final provider2 = Provider((ref) {
      return ref.dependOn(provider1).value + 1;
    });
    provider = Provider((ref) {
      return () => ref.dependOn(provider2).value + 1;
    });

    final owner = ProviderStateOwner();
    expect(
      () => provider.readOwner(owner)(),
      throwsA(isA<CircularDependencyError>()),
    );
  });
  test('circular dependencies #2', () {
    final owner = ProviderStateOwner();

    final provider = Provider((ref) => ref);
    final provider1 = Provider((ref) => ref);
    final provider2 = Provider((ref) => ref);

    provider1.readOwner(owner).dependOn(provider);
    provider2.readOwner(owner).dependOn(provider1);
    final ref = provider.readOwner(owner);

    expect(
      () => ref.dependOn(provider2),
      throwsA(isA<CircularDependencyError>()),
    );
  });
  test('dispose providers in dependency order (simple)', () {
    final owner = ProviderStateOwner();
    final onDispose1 = OnDisposeMock();
    final onDispose2 = OnDisposeMock();
    final onDispose3 = OnDisposeMock();

    final provider1 = Provider((ref) {
      ref.onDispose(onDispose1);
      return 1;
    });

    final provider2 = Provider((ref) {
      final value = ref.dependOn(provider1).value;
      ref.onDispose(onDispose2);
      return value + 1;
    });

    final provider3 = Provider((ref) {
      final value = ref.dependOn(provider2).value;
      ref.onDispose(onDispose3);
      return value + 1;
    });

    expect(provider3.readOwner(owner), 3);

    owner.dispose();

    verifyInOrder([
      onDispose3(),
      onDispose2(),
      onDispose1(),
    ]);
    verifyNoMoreInteractions(onDispose1);
    verifyNoMoreInteractions(onDispose2);
    verifyNoMoreInteractions(onDispose3);
  });

  test('dispose providers in dependency order (late binding)', () {
    final owner = ProviderStateOwner();
    final onDispose1 = OnDisposeMock();
    final onDispose2 = OnDisposeMock();
    final onDispose3 = OnDisposeMock();

    final provider1 = Provider((ref) {
      ref.onDispose(onDispose1);
      return 1;
    });

    final provider2 = Provider((ref) {
      ref.onDispose(onDispose2);
      return () => ref.dependOn(provider1).value + 1;
    });

    final provider3 = Provider((ref) {
      ref.onDispose(onDispose3);
      return () => ref.dependOn(provider2).value() + 1;
    });

    expect(provider3.readOwner(owner)(), 3);

    owner.dispose();

    verifyInOrder([
      onDispose3(),
      onDispose2(),
      onDispose1(),
    ]);
    verifyNoMoreInteractions(onDispose1);
    verifyNoMoreInteractions(onDispose2);
    verifyNoMoreInteractions(onDispose3);
  });
  test('update providers in dependency order', () {
    final provider = TestProvider((_) => 1);
    final provider1 = TestProvider((ref) {
      return () => ref.dependOn(provider).value + 1;
    });
    final provider2 = TestProvider((ref) {
      return () => ref.dependOn(provider1).value() + 1;
    });

    final owner = ProviderStateOwner(overrides: [
      provider,
      provider1,
      provider2,
    ]);

    expect(provider2.readOwner(owner)(), 3);

    verifyZeroInteractions(provider.onDidUpdateProvider);
    verifyZeroInteractions(provider1.onDidUpdateProvider);
    verifyZeroInteractions(provider2.onDidUpdateProvider);

    owner.debugUpdate([
      provider,
      provider1,
      provider2,
    ]);

    verifyInOrder([
      provider.onDidUpdateProvider(),
      provider1.onDidUpdateProvider(),
      provider2.onDidUpdateProvider(),
    ]);
    verifyNoMoreInteractions(provider.onDidUpdateProvider);
    verifyNoMoreInteractions(provider1.onDidUpdateProvider);
    verifyNoMoreInteractions(provider2.onDidUpdateProvider);
  });
  test('dependOn used on same provider multiple times returns same instance',
      () {
    final owner = ProviderStateOwner();
    final provider = Provider((_) => 42);

    ProviderSubscription<int> other;
    ProviderSubscription<int> other2;

    final provider1 = Provider((ref) {
      other = ref.dependOn(provider);
      other2 = ref.dependOn(provider);
      return other.value;
    });

    expect(provider1.readOwner(owner), 42);
    expect(other, other2);

    owner.dispose();
  });
  test('ProviderReference is unusable after dispose (dependOn/onDispose)', () {
    final owner = ProviderStateOwner();
    ProviderReference ref;
    final provider = Provider((s) {
      ref = s;
      return 42;
    });
    final other = Provider((_) => 42);

    expect(provider.readOwner(owner), 42);
    owner.dispose();

    expect(ref.mounted, isFalse);
    expect(() => ref.onDispose(() {}), throwsStateError);
    expect(() => ref.dependOn(other), throwsStateError);
  });

  test('if a provider threw on creation, subsequent reads throws too', () {
    var callCount = 0;
    final error = Error();
    final provider = Provider((_) {
      callCount++;
      throw error;
    });
    final owner = ProviderStateOwner();

    expect(() => provider.readOwner(owner), throwsA(error));
    expect(callCount, 1);
    expect(() => provider.readOwner(owner), throwsA(error));
    expect(callCount, 1);

    expect(() => owner.ref.dependOn(provider), throwsA(error));
    expect(callCount, 1);
    expect(() => owner.ref.dependOn(provider), throwsA(error));
    expect(callCount, 1);

    expect(() => provider.watchOwner(owner, (value) {}), throwsA(error));
    expect(callCount, 1);
    expect(() => provider.watchOwner(owner, (value) {}), throwsA(error));
    expect(callCount, 1);
  });
  test('if a provider threw on creation, markNeedsNotify throws StateError',
      () {
    var callCount = 0;
    final error = Error();
    SetStateProviderReference<int> reference;
    final provider = SetStateProvider<int>((ref) {
      reference = ref;
      callCount++;
      throw error;
    });
    final owner = ProviderStateOwner();

    expect(() => provider.readOwner(owner), throwsA(error));
    expect(callCount, 1);

    expect(() => reference.state = 42, throwsStateError);
  });
  test('if a provider threw on creation, onDispose still works', () {
    var callCount = 0;
    final onDispose = OnDisposeMock();
    final error = Error();
    ProviderReference reference;
    final provider = Provider((ref) {
      reference = ref;
      callCount++;
      ref.onDispose(onDispose);
      throw error;
    });
    final owner = ProviderStateOwner();

    expect(() => provider.readOwner(owner), throwsA(error));
    expect(callCount, 1);

    final onDispose2 = OnDisposeMock();
    reference.onDispose(onDispose2);

    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);

    owner.dispose();

    expect(callCount, 1);
    verifyInOrder([
      onDispose(),
      onDispose2(),
    ]);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);
  });
  group('notify listeners', () {
    test('calls onChange at most once per flush', () {
      final counter = Counter();
      final provider = StateNotifierProvider<Counter>((_) => counter);
      final root = ProviderStateOwner();
      final owner = ProviderStateOwner(
        parent: root,
        overrides: [
          provider,
          provider.state,
        ],
      );
      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = ListenerMock();

      final sub = provider.state.addLazyListener(
        owner,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      verify(listener(0)).called(1);
      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);

      sub.flush();

      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);

      counter.increment();

      verify(mayHaveChanged()).called(1);
      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);

      counter.increment();

      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);

      sub.flush();

      verify(listener(2)).called(1);
      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);

      counter.increment();

      verify(mayHaveChanged()).called(1);
      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);
    });
    test('noop inside initState', () {
      final provider = TestProvider((ref) {});
      final root = ProviderStateOwner();
      final owner = ProviderStateOwner(
        parent: root,
        overrides: [
          provider,
        ],
      );
      TestProviderState state;
      when(provider.onInitState(any)).thenAnswer((i) {
        state = i.positionalArguments.first as TestProviderState;

        expect(state.dirty, true);
        state..markMayHaveChanged()..markMayHaveChanged();
      });
      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = ListenerMock();

      final sub = provider.addLazyListener(
        owner,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      verify(listener(any)).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(mayHaveChanged);
      expect(state.dirty, false);

      sub.flush();

      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(mayHaveChanged);
      expect(state.dirty, false);
    });
    test('noop if no provider was "dirty"', () {
      final counter = Counter();
      final provider = StateNotifierProvider<Counter>((_) => counter);
      final owner = ProviderStateOwner();
      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = ListenerMock();

      final sub = provider.state.addLazyListener(
        owner,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      verify(listener(0)).called(1);
      verifyNoMoreInteractions(listener);

      sub.flush();
      verifyNoMoreInteractions(listener);

      counter..increment()..increment();

      verifyNoMoreInteractions(listener);

      sub.flush();

      verify(listener(2)).called(1);
      verifyNoMoreInteractions(listener);

      sub.flush();

      verifyNoMoreInteractions(listener);
    });
    test('update first update providers then dispatch notifications', () {
      final futureProvider = FutureProvider((_) async => 0);
      final owner = ProviderStateOwner(overrides: [
        futureProvider.debugOverrideWithValue(const AsyncValue.loading()),
      ]);
      final listener = AsyncListenerMock();

      futureProvider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.loading())).called(1);
      verifyNoMoreInteractions(listener);

      owner.debugUpdate([
        futureProvider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);
    });
    test('on update`', () async {
      final owner = ProviderStateOwner();
      final counter = Counter();
      final provider = StateNotifierProvider<Counter>((_) => counter);
      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = ListenerMock();

      final sub = provider.state.addLazyListener(
        owner,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      verify(listener(0)).called(1);
      verifyNoMoreInteractions(listener);

      counter.increment();
      verifyNoMoreInteractions(listener);

      counter.increment();
      verifyNoMoreInteractions(listener);

      sub.flush();

      verify(listener(2)).called(1);
      verifyNoMoreInteractions(listener);
    });
    test('in dependency order', () async {
      final owner = ProviderStateOwner();
      final counter = Counter();
      final counter2 = Counter();
      final counter3 = Counter();

      final provider = StateNotifierProvider<Counter>((_) => counter);
      final provider2 = StateNotifierProvider<Counter>((ref) {
        ref.dependOn(provider);
        return counter2;
      });
      final provider3 = StateNotifierProvider<Counter>((ref) {
        ref.dependOn(provider2);
        return counter3;
      });

      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = ListenerMock('first');
      final sub = provider.state.addLazyListener(
        owner,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      final mayHaveChanged2 = MockMarkMayHaveChanged();
      final listener2 = ListenerMock('second');
      final sub2 = provider2.state.addLazyListener(
        owner,
        mayHaveChanged: mayHaveChanged2,
        onChange: listener2,
      );

      final mayHaveChanged3 = MockMarkMayHaveChanged();
      final listener3 = ListenerMock('third');
      final sub3 = provider3.state.addLazyListener(
        owner,
        mayHaveChanged: mayHaveChanged3,
        onChange: listener3,
      );

      verify(listener(0)).called(1);
      verifyNoMoreInteractions(listener);
      verify(listener2(0)).called(1);
      verifyNoMoreInteractions(listener2);
      verify(listener3(0)).called(1);
      verifyNoMoreInteractions(listener3);

      counter3.increment();
      counter2.increment();
      counter.increment();

      verifyInOrder([
        mayHaveChanged3(),
        mayHaveChanged2(),
        mayHaveChanged(),
      ]);

      sub3.flush();

      verify(listener3(1)).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
      verifyNoMoreInteractions(listener3);

      sub2.flush();
      verify(listener2(1)).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
      verifyNoMoreInteractions(listener3);

      sub.flush();
      verify(listener(1)).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
      verifyNoMoreInteractions(listener3);
    });
  });
}

class AsyncListenerMock extends Mock {
  void call(AsyncValue<int> value);
}

class ListenerMock extends Mock {
  ListenerMock([this.debugLabel]);
  final String debugLabel;

  void call(int value);

  @override
  String toString() {
    if (debugLabel != null) {
      return debugLabel;
    }
    return super.toString();
  }
}

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

class OnDisposeMock extends Mock {
  void call();
}

class MockMarkMayHaveChanged extends Mock {
  void call();
}

class MockDidUpdateProvider extends Mock {
  void call();
}

class MockInitState<T> extends Mock {
  void call(TestProviderState<T> state);

  void thenAnswer(void Function(TestProviderState<T> state) cb) {
    when(this(any)).thenAnswer((realInvocation) {
      Function.apply(
        cb,
        realInvocation.positionalArguments,
        realInvocation.namedArguments,
      );
    });
  }
}

class MockOnValueDispose<T> extends Mock {
  void call(TestProviderValue<T> value);
}

class TestProviderValue<T> extends ProviderSubscriptionBase {
  TestProviderValue(this.value, {@required this.onDispose});

  final T value;
  final MockOnValueDispose<T> onDispose;

  @override
  void dispose() {
    onDispose(this);
    super.dispose();
  }
}

class TestProvider<T> extends AlwaysAliveProvider<TestProviderValue<T>, T> {
  TestProvider(this.create, {String name}) : super(name);

  final T Function(ProviderReference ref) create;
  final MockInitState<T> onInitState = MockInitState();
  final MockDidUpdateProvider onDidUpdateProvider = MockDidUpdateProvider();
  final MockOnValueDispose<T> onValueDispose = MockOnValueDispose();

  @override
  TestProviderState<T> createState() {
    return TestProviderState<T>();
  }
}

class TestProviderState<T>
    extends ProviderStateBase<TestProviderValue<T>, T, TestProvider<T>> {
  @override
  T state;

  @override
  void initState() {
    provider.onInitState(this);
    state = provider.create(ProviderReference(this));
  }

  @override
  void didUpdateProvider(TestProvider<T> oldProvider) {
    super.didUpdateProvider(oldProvider);
    provider.onDidUpdateProvider?.call();
  }

  @override
  TestProviderValue<T> createProviderSubscription() {
    return TestProviderValue<T>(state, onDispose: provider.onValueDispose);
  }
}
