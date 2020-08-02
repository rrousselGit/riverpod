import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('ScopedProvider', () {
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
