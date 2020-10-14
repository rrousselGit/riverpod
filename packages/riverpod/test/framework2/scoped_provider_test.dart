import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../uni_directional_test.dart';
import '../utils.dart';

void main() {
  group('ScopedProvider', () {
    test('create is nullable and default to throw UnsupportedError', () {
      final provider = ScopedProvider<int>(null);
      final container = ProviderContainer();

      expect(
        () => container.read(provider),
        throwsA(isProviderException(isUnsupportedError)),
      );
    });

    test('use the deepest override', () {
      final provider = ScopedProvider((watch) => 0);
      final root = ProviderContainer(overrides: [
        provider.overrideWithValue(1),
      ]);
      final mid = ProviderContainer(
        parent: root,
        overrides: [
          provider.overrideWithValue(42),
        ],
      );
      final container = ProviderContainer(parent: mid);

      expect(container.read(provider), 42);

      expect(container.debugProviderValues, {provider: 42});
      expect(mid.debugProviderValues, isEmpty);
      expect(root.debugProviderValues, isEmpty);
    });

    test('can read both parent and child simultaneously', () async {
      final provider = ScopedProvider((watch) => 0);
      final root = ProviderContainer(overrides: [
        provider.overrideWithValue(21),
      ]);
      final container = ProviderContainer(parent: root, overrides: [
        provider.overrideWithValue(42),
      ]);

      expect(container.read(provider), 42);
      expect(root.read(provider), 21);
      expect(container.read(provider), 42);
      expect(root.read(provider), 21);
    });

    test('updating parent override when there is a child override is no-op',
        () async {
      final provider = ScopedProvider((watch) => 0);
      final root = ProviderContainer(overrides: [
        provider.overrideWithValue(21),
      ]);
      final container = ProviderContainer(parent: root, overrides: [
        provider.overrideWithValue(42),
      ]);
      var mayHaveChanged = false;

      final sub = container.listen(
        provider,
        mayHaveChanged: (_) => mayHaveChanged = true,
      );

      expect(sub.read(), 42);

      root.updateOverrides([
        provider.overrideWithValue(22),
      ]);

      expect(sub.read(), 42);
      expect(mayHaveChanged, false);
    });

    test('are auto disposed', () async {
      final provider = ScopedProvider((watch) => 0);
      final container = ProviderContainer();

      final sub = container.listen(provider);
      final element = container.readProviderElement(provider);

      expect(element.mounted, true);
      expect(sub.read(), 0);

      sub.close();
      await Future<void>.value();

      expect(element.mounted, false);

      container.dispose();

      expect(element.mounted, false);
    });

    test('overridesAs are auto disposed', () async {
      final provider = ScopedProvider((watch) => 0);
      final container = ProviderContainer(overrides: [
        provider.overrideAs((ref) => 42),
      ]);

      final sub = container.listen(provider);
      final element = container.readProviderElement(provider);

      expect(element.mounted, true);
      expect(sub.read(), 42);

      sub.close();
      await Future<void>.value();

      expect(element.mounted, false);
    });

    test('are disposed on nested containers', () {
      final provider = ScopedProvider((watch) => 0);
      final root = ProviderContainer(overrides: [
        provider.overrideWithValue(1),
      ]);
      final mid = ProviderContainer(
        parent: root,
        overrides: [
          provider.overrideWithValue(42),
        ],
      );
      final container = ProviderContainer(parent: mid);

      final element = container.readProviderElement(provider);

      expect(element.mounted, true);

      container.dispose();

      expect(element.mounted, false);
    });

    test('can update multiple ScopeProviders at one', () {
      final provider = ScopedProvider<int>(null);
      final provider2 = ScopedProvider<int>(null);

      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(21),
        provider2.overrideWithValue(42),
      ]);

      final sub = container.listen(provider);
      final sub2 = container.listen(provider2);

      expect(sub.read(), 21);
      expect(sub2.read(), 42);

      container.updateOverrides([
        provider.overrideWithValue(22),
        provider2.overrideWithValue(43),
      ]);

      expect(sub.flush(), true);
      expect(sub.read(), 22);
      expect(sub2.flush(), true);
      expect(sub2.read(), 43);
    });

    test('handles parent override update', () {
      final provider = ScopedProvider((watch) => 0);
      final root = ProviderContainer(overrides: [
        provider.overrideWithValue(1),
      ]);
      final mid = ProviderContainer(
        parent: root,
        overrides: [
          provider.overrideWithValue(42),
        ],
      );
      final container = ProviderContainer(parent: mid);

      final sub = container.listen(provider);

      expect(sub.read(), 42);

      mid.updateOverrides([
        provider.overrideWithValue(21),
      ]);

      expect(sub.flush(), true);
      expect(sub.read(), 21);
    });

    test('are mounted on the closest container', () {
      final root = ProviderContainer();
      final container = ProviderContainer(parent: root);
      final provider = ScopedProvider((watch) => 0);

      expect(container.read(provider), 0);

      expect(container.debugProviderValues, {provider: 0});
      expect(root.debugProviderValues, isEmpty);
    });

    test('can be overriden on non-root container', () {
      final provider = ScopedProvider((watch) => 0);
      final root = ProviderContainer();
      final container = ProviderContainer(parent: root, overrides: [
        provider.overrideWithValue(42),
      ]);

      expect(container.read(provider), 42);
    });

    test('can listen to other scoped providers', () {
      final mayHaveChanged = MayHaveChangedMock<int>();
      final provider = ScopedProvider((watch) => 0);
      final provider2 = ScopedProvider((watch) {
        return watch(provider) * 2;
      });
      final root = ProviderContainer();
      final container = ProviderContainer(parent: root, overrides: [
        provider.overrideWithValue(1),
      ]);

      final sub = container.listen(provider2, mayHaveChanged: mayHaveChanged);

      expect(sub.read(), 2);
      verifyZeroInteractions(mayHaveChanged);

      container.updateOverrides([
        provider.overrideWithValue(2),
      ]);

      verifyOnly(mayHaveChanged, mayHaveChanged(sub));

      expect(sub.read(), 4);
    });

    test('can listen to other normal providers', () {
      final mayHaveChanged = MayHaveChangedMock<int>();
      final provider = StateProvider((ref) => 1);
      final provider2 = ScopedProvider((watch) {
        return watch(provider).state * 2;
      });
      final root = ProviderContainer();
      final container = ProviderContainer(parent: root);

      final sub = container.listen(provider2, mayHaveChanged: mayHaveChanged);

      expect(sub.read(), 2);
      verifyZeroInteractions(mayHaveChanged);

      root.read(provider).state++;

      verifyOnly(mayHaveChanged, mayHaveChanged(sub));

      expect(sub.read(), 4);
    });

    test('compare result with ==', () {
      final mayHaveChanged = MayHaveChangedMock<int>();
      final provider = StateProvider((ref) => 1);
      final provider2 = ScopedProvider((watch) {
        return watch(provider).state * 2;
      });
      final root = ProviderContainer();
      final container = ProviderContainer(parent: root);

      final sub = container.listen(provider2, mayHaveChanged: mayHaveChanged);

      expect(sub.read(), 2);
      verifyZeroInteractions(mayHaveChanged);

      root.read(provider).state = 1;

      verifyOnly(mayHaveChanged, mayHaveChanged(sub));

      expect(sub.flush(), false);
    });

    test('compare result with == cross override', () {
      final mayHaveChanged = MayHaveChangedMock<int>();
      final provider = ScopedProvider((watch) => 0);
      final container = ProviderContainer(overrides: [
        provider.overrideAs((watch) => 2),
      ]);

      final sub = container.listen(provider, mayHaveChanged: mayHaveChanged);

      expect(sub.read(), 2);
      verifyZeroInteractions(mayHaveChanged);

      container.updateOverrides([
        provider.overrideAs((watch) => 2),
      ]);

      verifyOnly(mayHaveChanged, mayHaveChanged(sub));

      expect(sub.flush(), false);
    });

    group('overrideAs', () {
      test('is re-evaluated on override change', () {
        final mayHaveChanged = MayHaveChangedMock<int>();
        final provider = ScopedProvider((watch) => 0);
        final container = ProviderContainer(overrides: [
          provider.overrideAs((watch) => 2),
        ]);

        final sub = container.listen(provider, mayHaveChanged: mayHaveChanged);

        expect(sub.read(), 2);
        verifyZeroInteractions(mayHaveChanged);

        container.updateOverrides([
          provider.overrideAs((watch) => 4),
        ]);

        verifyOnly(mayHaveChanged, mayHaveChanged(sub));

        expect(sub.read(), 4);
      });
    });
  });
}
