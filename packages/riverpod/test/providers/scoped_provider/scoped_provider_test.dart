import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../legacy/uni_directional_test.dart';
import '../../utils.dart';

void main() {
  group('ScopedProvider', () {
    test('create is nullable and default to throw UnsupportedError', () {
      final provider = ScopedProvider<int>(null);
      final container = createContainer();

      expect(
        () => container.read(provider),
        throwsA(isProviderException(isUnsupportedError)),
      );
    });

    test('use the deepest override', () {
      final provider = ScopedProvider((watch) => 0);
      final root = createContainer(overrides: [
        provider.overrideWithValue(1),
      ]);
      final mid = createContainer(
        parent: root,
        overrides: [
          provider.overrideWithValue(42),
        ],
      );
      final container = createContainer(parent: mid);

      expect(container.read(provider), 42);

      expect(container.getAllProviderElements(), [
        isA<ProviderElementBase<int>>()
            .having((e) => e.origin, 'origin', provider)
            .having((e) => e.getExposedValue(), 'getExposedValue()', 42)
      ]);
      expect(mid.getAllProviderElements(), isEmpty);
      expect(root.getAllProviderElements(), isEmpty);
    });

    test('are mounted on the closest container', () {
      final root = createContainer();
      final container = createContainer(parent: root);
      final provider = ScopedProvider((watch) => 0);

      expect(container.read(provider), 0);

      expect(container.getAllProviderElements(), [
        isA<ProviderElementBase<int>>()
            .having((e) => e.origin, 'origin', provider)
            .having((e) => e.getExposedValue(), 'getExposedValue()', 0)
      ]);
      expect(root.getAllProviderElements(), isEmpty);
    });

    test('can read both parent and child simultaneously', () async {
      final provider = ScopedProvider((watch) => 0);
      final root = createContainer(overrides: [
        provider.overrideWithValue(21),
      ]);
      final container = createContainer(parent: root, overrides: [
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
      final root = createContainer(overrides: [
        provider.overrideWithValue(21),
      ]);
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithValue(42),
      ]);
      final listener = Listener<int>();

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(42));

      root.updateOverrides([
        provider.overrideWithValue(22),
      ]);

      await container.pump();

      verifyNoMoreInteractions(listener);
    });

    test('are auto disposed', () async {
      final provider = ScopedProvider((watch) => 0);
      final container = createContainer();

      final sub = container.listen(provider, (_) {});
      final element = container.readProviderElement(provider);

      expect(element.mounted, true);
      expect(sub.read(), 0);

      sub.close();
      await container.pump();

      expect(element.mounted, false);

      container.dispose();

      expect(element.mounted, false);
    });

    test('overridesAs are auto disposed', () async {
      final provider = ScopedProvider((watch) => 0);
      final container = createContainer(overrides: [
        provider.overrideAs((ref) => 42),
      ]);

      final sub = container.listen(provider, (_) {});
      final element = container.readProviderElement(provider);

      expect(element.mounted, true);
      expect(sub.read(), 42);

      sub.close();
      await container.pump();

      expect(element.mounted, false);
    });

    test('are disposed on nested containers', () {
      final provider = ScopedProvider((watch) => 0);
      final root = createContainer(overrides: [
        provider.overrideWithValue(1),
      ]);
      final mid = createContainer(
        parent: root,
        overrides: [
          provider.overrideWithValue(42),
        ],
      );
      final container = createContainer(parent: mid);

      final element = container.readProviderElement(provider);

      expect(element.mounted, true);

      container.dispose();

      expect(element.mounted, false);
    });

    test('can update multiple ScopeProviders at one', () {
      final provider = ScopedProvider<int>(null);
      final provider2 = ScopedProvider<int>(null);

      final container = createContainer(overrides: [
        provider.overrideWithValue(21),
        provider2.overrideWithValue(42),
      ]);

      final listener = Listener<int>();
      final listener2 = Listener<int>();

      container.listen(provider, listener, fireImmediately: true);
      container.listen(provider2, listener2, fireImmediately: true);

      verifyOnly(listener, listener(21));
      verifyOnly(listener2, listener2(42));

      container.updateOverrides([
        provider.overrideWithValue(22),
        provider2.overrideWithValue(43),
      ]);

      verifyInOrder([
        listener(22),
        listener2(43),
      ]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
    });

    test('handles parent override update', () {
      final provider = ScopedProvider((watch) => 0);
      final root = createContainer(overrides: [
        provider.overrideWithValue(1),
      ]);
      final mid = createContainer(
        parent: root,
        overrides: [
          provider.overrideWithValue(42),
        ],
      );
      final container = createContainer(parent: mid);
      final listener = Listener<int>();

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(42));

      mid.updateOverrides([
        provider.overrideWithValue(21),
      ]);

      verifyOnly(listener, listener(21));
    });

    test('can be overriden on non-root container', () {
      final provider = ScopedProvider((watch) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithValue(42),
      ]);

      expect(container.read(provider), 42);
    });

    test('can listen to other scoped providers', () async {
      final listener = Listener<int>();
      final provider = ScopedProvider((watch) => 0);
      final provider2 = ScopedProvider((watch) {
        return watch(provider) * 2;
      });
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithValue(1),
      ]);

      container.listen(provider2, listener, fireImmediately: true);

      verifyOnly(listener, listener(2));

      container.updateOverrides([
        provider.overrideWithValue(2),
      ]);

      await container.pump();

      verifyOnly(listener, listener(4));
    });

    test('can listen to other normal providers', () async {
      final listener = Listener<int>();
      final provider = StateProvider((ref) => 1);
      final provider2 = ScopedProvider((watch) {
        return watch(provider).state * 2;
      });
      final root = createContainer();
      final container = createContainer(parent: root);

      container.listen(provider2, listener, fireImmediately: true);

      verifyOnly(listener, listener(2));

      root.read(provider).state++;

      await container.pump();

      verifyOnly(listener, listener(4));
    });

    test('compare result with ==', () async {
      final listener = Listener<int>();
      final provider = StateProvider((ref) => 1);
      final provider2 = ScopedProvider((watch) {
        return watch(provider).state * 2;
      });
      final root = createContainer();
      final container = createContainer(parent: root);

      container.listen(provider2, listener, fireImmediately: true);

      verifyOnly(listener, listener(2));

      root.read(provider).state = 1;

      await container.pump();

      verifyNoMoreInteractions(listener);
    });

    test('compare result with == cross override', () async {
      final listener = Listener<int>();
      final provider = ScopedProvider((watch) => 0);
      final container = createContainer(overrides: [
        provider.overrideAs((watch) => 2),
      ]);

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(2));

      container.updateOverrides([
        provider.overrideAs((watch) => 2),
      ]);

      await container.pump();

      verifyNoMoreInteractions(listener);
    });

    group('overrideAs', () {
      test('is re-evaluated on override change', () {
        final provider = ScopedProvider((watch) => 0);
        final listener = Listener<int>();
        final container = createContainer(overrides: [
          provider.overrideAs((watch) => 2),
        ]);

        container.listen(provider, listener, fireImmediately: true);

        verifyOnly(listener, listener(2));

        container.updateOverrides([
          provider.overrideAs((watch) => 4),
        ]);

        verifyOnly(listener, listener(4));
      });

      test('does not call listeners if the new override is the same as before',
          () {
        final provider = ScopedProvider((watch) => 0);
        final listener = Listener<int>();
        final container = createContainer(overrides: [
          provider.overrideAs((watch) => 2),
        ]);

        container.listen(provider, listener, fireImmediately: true);

        verifyOnly(listener, listener(2));

        container.updateOverrides([
          provider.overrideAs((watch) => 2),
        ]);

        verifyNoMoreInteractions(listener);
      });
    });
  });
}
