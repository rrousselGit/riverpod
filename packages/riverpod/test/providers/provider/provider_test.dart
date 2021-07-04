import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('Provider', () {
    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () {
        final provider = Provider((ref) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider), 0);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider)
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWithValue', () {
        final provider = Provider((ref) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithValue(42),
        ]);

        expect(container.read(provider), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider)
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWithProvider', () {
        final provider = Provider((ref) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider(Provider((ref) => 42)),
        ]);

        expect(container.read(provider), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider)
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });
    });

    test('can be refreshed', () {}, skip: true);

    group('override', () {
      test('does not notify listeners if updated with the same value', () {
        final provider = Provider((ref) => 0);
        final container = createContainer(overrides: [
          provider.overrideWithValue(42),
        ]);
        final listener = Listener<int>();

        addTearDown(container.dispose);

        container.listen(provider, listener, fireImmediately: true);

        verifyOnly(listener, listener(42));

        container.updateOverrides([
          provider.overrideWithValue(42),
        ]);

        expect(container.read(provider), 42);
        verifyNoMoreInteractions(listener);
      });

      test('notify listeners when value changes', () {
        final provider = Provider((ref) => 0);
        final container = createContainer(overrides: [
          provider.overrideWithValue(42),
        ]);
        final listener = Listener<int>();

        addTearDown(container.dispose);

        container.listen(provider, listener, fireImmediately: true);

        verifyOnly(listener, listener(42));

        container.updateOverrides([
          provider.overrideWithValue(21),
        ]);

        verifyOnly(listener, listener(21));
      });
    });

    test('can specify name', () {
      final provider = Provider(
        (_) => 0,
        name: 'example',
      );

      expect(provider.name, 'example');

      final provider2 = Provider((_) => 0);

      expect(provider2.name, isNull);
    });

    test('is AlwaysAliveProviderBase', () {
      // ignore: unused_local_variable, testing that Provider can be assigned to AlwaysAliveProviderBase
      final AlwaysAliveProviderBase provider = Provider<int>((_) => 42);
    });
  });

  test('dispose', () {
    final container = createContainer();
    final onDispose = OnDisposeMock();
    final provider = Provider((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    expect(container.read(provider), 42);

    verifyZeroInteractions(onDispose);

    container.dispose();

    verify(onDispose()).called(1);
  });

  test('Provider can be overriden by anything', () {
    final provider = Provider((_) => 42);
    final AlwaysAliveProviderBase<int> override = Provider((_) {
      return 21;
    });
    final container = createContainer(overrides: [
      provider.overrideWithProvider(override),
    ]);

    expect(container.read(provider), 21);
  });

  test('Read creates the value only once', () {
    final container = createContainer();
    var callCount = 0;
    final provider = Provider((ref) {
      callCount++;
      return 42;
    });

    expect(callCount, 0);
    expect(container.read(provider), 42);
    expect(callCount, 1);

    expect(container.read(provider), 42);
    expect(callCount, 1);
  });

  test("rebuild don't notify clients if == doesn't change", () {
    final container = createContainer();
    final counter = Counter();
    final other = StateNotifierProvider<Counter, int>((ref) => counter);
    var buildCount = 0;
    final provider = Provider((ref) {
      buildCount++;
      return ref.watch(other).isEven;
    });
    final listener = Listener<bool>();

    final sub = container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(true));
    expect(sub.read(), true);
    expect(buildCount, 1);

    counter.increment();
    counter.increment();

    expect(sub.read(), true);
    expect(buildCount, 2);
    verifyNoMoreInteractions(listener);
  });

  test('rebuild notify clients if == did change', () {
    final container = createContainer();
    final counter = Counter();
    final other = StateNotifierProvider<Counter, int>((ref) => counter);
    final provider = Provider((ref) {
      return ref.watch(other).isEven;
    });
    final listener = Listener<bool>();

    final sub = container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(true));
    expect(sub.read(), true);

    counter.increment();

    expect(sub.read(), false);
    verifyOnly(listener, listener(false));
  });
}
