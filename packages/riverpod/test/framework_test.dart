import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  group('onError', () {
    // TODO error handling initState
    // TODO error handling didUpdateProvider
    // TODO error handling dispose
    // TODO error handling watchOwner callback
    // TODO error handling ref.onDispose callback
    // TODO error handling ref.onChange (if any) callback
    // TODO no onError fallback to zone
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

    owner.updateOverrides([]);
    owner2.updateOverrides([
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
      overrides: [other.overrideForSubtree(other)],
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
      overrides: [provider.overrideForSubtree(provider)],
    );

    expect(callCount, 0);

    owner.updateOverrides(
      [provider.overrideForSubtree(provider)],
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
    final ProviderReference = provider.readOwner(owner);

    expect(
      () => ProviderReference.dependOn(provider2),
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
      provider.overrideForSubtree(provider),
      provider1.overrideForSubtree(provider1),
      provider2.overrideForSubtree(provider2),
    ]);

    expect(provider2.readOwner(owner)(), 3);

    verifyZeroInteractions(provider.onDidUpdateProvider);
    verifyZeroInteractions(provider1.onDidUpdateProvider);
    verifyZeroInteractions(provider2.onDidUpdateProvider);

    owner.updateOverrides([
      provider.overrideForSubtree(provider),
      provider1.overrideForSubtree(provider1),
      provider2.overrideForSubtree(provider2),
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
}

class OnDisposeMock extends Mock {
  void call();
}

class MockDidUpdateProvider extends Mock {
  void call();
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
  void didUpdateProvider(TestProvider<T> oldProvider) {
    super.didUpdateProvider(oldProvider);
    provider.onDidUpdateProvider?.call();
  }

  @override
  TestProviderValue<T> createProviderSubscription() {
    return TestProviderValue<T>($state, onDispose: provider.onValueDispose);
  }

  @override
  T initState() {
    return provider.create(ProviderReference(this));
  }
}
