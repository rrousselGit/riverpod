import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  // TODO provider.overrideForSubtree(provider) can be simplified into provider
  // TODO owner life-cycles are unusuable after dispose
  test('provider.overrideForSubtree(provider) can be simplified into provider',
      () {
    final notifier = Counter();
    final provider = StateNotifierProvider<Counter>((_) => notifier);
    final root = ProviderStateOwner();
    final owner = ProviderStateOwner(parent: root, overrides: [provider]);

    expect(provider.readOwner(owner), notifier);
    expect(notifier.mounted, true);

    owner.dispose();

    expect(notifier.mounted, false);
  });
  test('cannot call markNeedsNotifyListeners after dispose', () {
    final owner = ProviderStateOwner();
    final provider = TestProvider((ref) {});
    ProviderBaseState providerBaseState;
    provider.onInitState.thenAnswer((state) {
      providerBaseState = state;
    });

    provider.readOwner(owner);

    expect(providerBaseState.dirty, false);
    providerBaseState.markNeedsNotifyListeners();
    expect(providerBaseState.dirty, true);

    owner.update();

    expect(providerBaseState.dirty, false);

    owner.dispose();

    expect(
      () => providerBaseState.markNeedsNotifyListeners(),
      throwsStateError,
    );
  });
  test('owner.ref uses the override', () {
    final provider = Provider((_) => 42);
    final owner = ProviderStateOwner();
    final owner2 = ProviderStateOwner(overrides: [
      provider.overrideForSubtree(
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

    owner.update([]);
    owner2.update([
      provider.overrideForSubtree(
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

    owner.update(
      [provider],
    );

    expect(callCount, 0);

    owner.dispose();

    expect(callCount, 0);
    expect(provider.readOwner(owner), 0);
    expect(callCount, 1);
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
      onDispose1(),
      onDispose2(),
      onDispose3(),
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
      onDispose1(),
      onDispose2(),
      onDispose3(),
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

    owner.update([
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

    owner.dispose();
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
    expect(() => ref.onDispose(() {}), throwsA(isA<AssertionError>()));
    expect(() => ref.dependOn(other), throwsA(isA<AssertionError>()));
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
    test('calls markNeedsUpdate at most once until update is called', () {
      final rootNeedsUpdate = MockMarkNeedsUpdate();
      final ownerNeedsUpdate = MockMarkNeedsUpdate();
      final counter = Counter();
      final provider = StateNotifierProvider<Counter>((_) => counter);
      final root = ProviderStateOwner(markNeedsUpdate: rootNeedsUpdate);
      final owner = ProviderStateOwner(
        parent: root,
        markNeedsUpdate: ownerNeedsUpdate,
        overrides: [
          provider,
          provider.value,
        ],
      );
      final listener = ListenerMock();

      provider.value.watchOwner(owner, listener);

      verify(listener(0)).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(rootNeedsUpdate);
      verifyNoMoreInteractions(ownerNeedsUpdate);

      counter.increment();

      verify(ownerNeedsUpdate()).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(rootNeedsUpdate);
      verifyNoMoreInteractions(ownerNeedsUpdate);

      counter.increment();

      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(rootNeedsUpdate);
      verifyNoMoreInteractions(ownerNeedsUpdate);

      owner.update();

      verify(listener(2)).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(rootNeedsUpdate);
      verifyNoMoreInteractions(ownerNeedsUpdate);

      counter.increment();

      verify(ownerNeedsUpdate()).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(rootNeedsUpdate);
      verifyNoMoreInteractions(ownerNeedsUpdate);
    });
    test('noop inside initState', () {
      final rootNeedsUpdate = MockMarkNeedsUpdate();
      final ownerNeedsUpdate = MockMarkNeedsUpdate();
      final provider = TestProvider((ref) {});
      final root = ProviderStateOwner(markNeedsUpdate: rootNeedsUpdate);
      final owner = ProviderStateOwner(
        parent: root,
        markNeedsUpdate: ownerNeedsUpdate,
        overrides: [
          provider,
        ],
      );
      TestProviderState state;
      when(provider.onInitState(any)).thenAnswer((i) {
        state = i.positionalArguments.first as TestProviderState;

        expect(state.dirty, true);
        state..markNeedsNotifyListeners()..markNeedsNotifyListeners();
      });
      final listener = ListenerMock();

      provider.watchOwner(owner, listener);

      verify(listener(null)).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(rootNeedsUpdate);
      verifyNoMoreInteractions(ownerNeedsUpdate);
      expect(state.dirty, false);

      owner.update();

      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(rootNeedsUpdate);
      verifyNoMoreInteractions(ownerNeedsUpdate);
      expect(state.dirty, false);
    });
    test('noop if no provider was "dirty"', () {
      final counter = Counter();
      final provider = StateNotifierProvider<Counter>((_) => counter);
      final owner = ProviderStateOwner();
      final listener = ListenerMock();

      provider.value.watchOwner(owner, listener);

      verify(listener(0)).called(1);
      verifyNoMoreInteractions(listener);

      owner.update();
      verifyNoMoreInteractions(listener);

      counter..increment()..increment();

      verifyNoMoreInteractions(listener);

      owner.update();

      verify(listener(2)).called(1);
      verifyNoMoreInteractions(listener);

      owner.update();

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

      owner.update([
        futureProvider.debugOverrideWithValue(AsyncValue.data(42)),
      ]);

      verify(listener(AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);
    });
    test('on update`', () async {
      final owner = ProviderStateOwner();
      final counter = Counter();
      final provider = StateNotifierProvider<Counter>((_) => counter);
      final listener = ListenerMock();

      provider.value.watchOwner(owner, listener);

      verify(listener(0)).called(1);
      verifyNoMoreInteractions(listener);

      counter.increment();
      verifyNoMoreInteractions(listener);

      counter.increment();
      verifyNoMoreInteractions(listener);

      owner.update();

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

      final listener = ListenerMock('first');
      final listener2 = ListenerMock('second');
      final listener3 = ListenerMock('third');

      provider3.value.watchOwner(owner, listener3);
      provider2.value.watchOwner(owner, listener2);
      provider.value.watchOwner(owner, listener);

      verify(listener(0)).called(1);
      verifyNoMoreInteractions(listener);
      verify(listener2(0)).called(1);
      verifyNoMoreInteractions(listener2);
      verify(listener3(0)).called(1);
      verifyNoMoreInteractions(listener3);

      counter3.increment();
      counter2.increment();
      counter.increment();

      owner.update();

      verifyInOrder([
        listener(1),
        listener2(1),
        listener3(1),
      ]);
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

class MockMarkNeedsUpdate extends Mock {
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

class TestProviderValue<T> extends ProviderBaseSubscription {
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
  TestProvider(this.create);

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
    extends ProviderBaseState<TestProviderValue<T>, T, TestProvider<T>> {
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
