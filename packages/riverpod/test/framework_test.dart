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
    // TODO error handling context.onDispose callback
    // TODO error handling state.onChange (if any) callback
    // TODO no onError fallback to zone
  });
  test('owner.context uses the override', () {
    final provider = Provider((_) => 42);
    final owner = ProviderStateOwner();
    final owner2 = ProviderStateOwner(overrides: [
      provider.overrideForSubtree(
        Provider((_) => 21),
      ),
    ]);

    final context = owner.context;
    final context2 = owner2.context;

    expect(context, isNot(context2));
    expect(owner.context, context);
    expect(owner2.context, context2);

    expect(context.dependOn(provider).value, 42);
    expect(context2.dependOn(provider).value, 21);

    owner.updateOverrides([]);
    owner2.updateOverrides([
      provider.overrideForSubtree(
        Provider((_) => 21),
      ),
    ]);

    expect(owner.context, context);
    expect(owner2.context, context2);
    expect(context.dependOn(provider).value, 42);
    expect(context2.dependOn(provider).value, 21);
  });

  test('context.dependOn disposes the provider state', () {
    var didDispose = false;
    final provider = TestProvider((context) {
      context.onDispose(() => didDispose = true);
      return 0;
    });
    final other = Provider((context) => context.dependOn(provider));

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
    final provider = TestProvider((context) => 0);
    final provider2 = TestProvider((context) => 1);
    final owner = ProviderStateOwner();

    final value1 = owner.context.dependOn(provider);
    final value2 = owner.context.dependOn(provider);
    final value21 = owner.context.dependOn(provider2);
    final value22 = owner.context.dependOn(provider2);

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

    final provider1 = Provider((context) {
      return context.dependOn(provider).value() + 1;
    });
    final provider2 = Provider((context) {
      return context.dependOn(provider1).value + 1;
    });
    provider = Provider((context) {
      return () => context.dependOn(provider2).value + 1;
    });

    final owner = ProviderStateOwner();
    expect(
      () => provider.readOwner(owner)(),
      throwsA(isA<CircularDependencyError>()),
    );
  });
  test('circular dependencies #2', () {
    final owner = ProviderStateOwner();

    final provider = Provider((context) => context);
    final provider1 = Provider((context) => context);
    final provider2 = Provider((context) => context);

    provider1.readOwner(owner).dependOn(provider);
    provider2.readOwner(owner).dependOn(provider1);
    final providerContext = provider.readOwner(owner);

    expect(
      () => providerContext.dependOn(provider2),
      throwsA(isA<CircularDependencyError>()),
    );
  });
  test('dispose providers in dependency order (simple)', () {
    final owner = ProviderStateOwner();
    final onDispose1 = OnDisposeMock();
    final onDispose2 = OnDisposeMock();
    final onDispose3 = OnDisposeMock();

    final provider1 = Provider((context) {
      context.onDispose(onDispose1);
      return 1;
    });

    final provider2 = Provider((context) {
      final value = context.dependOn(provider1).value;
      context.onDispose(onDispose2);
      return value + 1;
    });

    final provider3 = Provider((context) {
      final value = context.dependOn(provider2).value;
      context.onDispose(onDispose3);
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

    final provider1 = Provider((context) {
      context.onDispose(onDispose1);
      return 1;
    });

    final provider2 = Provider((context) {
      context.onDispose(onDispose2);
      return () => context.dependOn(provider1).value + 1;
    });

    final provider3 = Provider((context) {
      context.onDispose(onDispose3);
      return () => context.dependOn(provider2).value() + 1;
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
    final provider1 = TestProvider((context) {
      return () => context.dependOn(provider).value + 1;
    });
    final provider2 = TestProvider((context) {
      return () => context.dependOn(provider1).value() + 1;
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

    final provider1 = Provider((context) {
      other = context.dependOn(provider);
      other2 = context.dependOn(provider);
      return other.value;
    });

    expect(provider1.readOwner(owner), 42);
    expect(other, other2);

    owner.dispose();
  });
  test('ProviderContext is unusable after dispose (dependOn/onDispose)', () {
    final owner = ProviderStateOwner();
    ProviderContext context;
    final provider = Provider((s) {
      context = s;
      return 42;
    });
    final other = Provider((_) => 42);

    expect(provider.readOwner(owner), 42);
    owner.dispose();

    expect(context.mounted, isFalse);
    expect(() => context.onDispose(() {}), throwsA(isA<AssertionError>()));
    expect(() => context.dependOn(other), throwsA(isA<AssertionError>()));
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

  final T Function(ProviderContext context) create;
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
    return provider.create(ProviderContext(this));
  }
}
