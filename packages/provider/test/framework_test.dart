import 'package:mockito/mockito.dart';
import 'package:provider/src/internals.dart';
import 'package:test/test.dart';
import 'package:provider/provider.dart';

void main() {
  group('onError', () {
    // TODO error handling initState
    // TODO error handling didUpdateProvider
    // TODO error handling dispose
    // TODO error handling watchOwner callback
    // TODO error handling state.onDispose callback
    // TODO error handling state.onChange (if any) callback
    // TODO no onError fallback to zone
  });
  // TODO test dependOn disposes the provider state (keep alive?)
  // TODO circular dependencies
  // TODO: updating overrides / dispose don't compute provider states if not loaded yet
  test('dispose providers in dependency order (simple)', () {
    final owner = ProviderStateOwner();
    final onDispose1 = OnDisposeMock();
    final onDispose2 = OnDisposeMock();
    final onDispose3 = OnDisposeMock();

    final provider1 = Provider((state) {
      state.onDispose(onDispose1);
      return 1;
    });

    final provider2 = Provider((state) {
      final value = state.dependOn(provider1).value;
      state.onDispose(onDispose2);
      return value + 1;
    });

    final provider3 = Provider((state) {
      final value = state.dependOn(provider2).value;
      state.onDispose(onDispose3);
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

    final provider1 = Provider((state) {
      state.onDispose(onDispose1);
      return 1;
    });

    final provider2 = Provider((state) {
      state.onDispose(onDispose2);
      return () => state.dependOn(provider1).value + 1;
    });

    final provider3 = Provider((state) {
      state.onDispose(onDispose3);
      return () => state.dependOn(provider2).value() + 1;
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
    final provider1 = TestProvider((state) {
      return () => state.dependOn(provider).value + 1;
    });
    final provider2 = TestProvider((state) {
      return () => state.dependOn(provider1).value() + 1;
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

    ProviderValue<int> other;
    ProviderValue<int> other2;

    final provider1 = Provider((state) {
      other = state.dependOn(provider);
      other2 = state.dependOn(provider);
      return other.value;
    });

    expect(provider1.readOwner(owner), 42);
    expect(other, other2);

    owner.dispose();
  });
  test('ProviderState is unusable after dispose (dependOn/onDispose)', () {
    final owner = ProviderStateOwner();
    ProviderState state;
    final provider = Provider((s) {
      state = s;
      return 42;
    });
    final other = Provider((_) => 42);

    expect(provider.readOwner(owner), 42);
    owner.dispose();

    expect(state.mounted, isFalse);
    expect(() => state.onDispose(() {}), throwsA(isA<AssertionError>()));
    expect(() => state.dependOn(other), throwsA(isA<AssertionError>()));
  });
}

class OnDisposeMock extends Mock {
  void call();
}

class MockDidUpdateProvider extends Mock {
  void call();
}

class TestProviderValue<T> extends BaseProviderValue {
  TestProviderValue(this.value);

  final T value;
}

class TestProvider<T> extends AlwaysAliveProvider<TestProviderValue<T>, T> {
  TestProvider(this.create);

  final T Function(ProviderState state) create;
  final MockDidUpdateProvider onDidUpdateProvider = MockDidUpdateProvider();

  @override
  TestProviderState<T> createState() {
    return TestProviderState<T>();
  }
}

class TestProviderState<T>
    extends BaseProviderState<TestProviderValue<T>, T, TestProvider<T>> {
  @override
  void didUpdateProvider(TestProvider<T> oldProvider) {
    super.didUpdateProvider(oldProvider);
    provider.onDidUpdateProvider?.call();
  }

  @override
  TestProviderValue<T> createProviderValue() {
    return TestProviderValue<T>($state);
  }

  @override
  T initState() {
    return provider.create(ProviderState(this));
  }
}
