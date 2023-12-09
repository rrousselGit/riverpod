import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test(
      'It is possible to read provider sub-values by specifying the provider in `dependencies`',
      () {
    final dep = StateProvider((ref) => 0);
    final provider = Provider(
      (ref) => ref.watch(dep.notifier),
      dependencies: [dep],
    );
    final container = createContainer();

    expect(container.read(provider).state, 0);
  });

  group('scoping mechanism', () {
    test('use the deepest override', () {
      final provider = Provider((ref) => 0);
      final root = createContainer(
        overrides: [provider.overrideWithValue(1)],
      );
      final mid = createContainer(
        parent: root,
        overrides: [
          provider.overrideWithValue(42),
        ],
      );
      final container = createContainer(parent: mid);

      expect(container.read(provider), 42);

      expect(container.getAllProviderElements(), isEmpty);
      expect(mid.getAllProviderElements(), [
        isA<ProviderElementBase<int>>()
            .having((e) => e.origin, 'origin', provider)
            .having((e) => e.readSelf(), 'readSelf()', 42),
      ]);
      expect(root.getAllProviderElements(), isEmpty);
    });

    test('can read both parent and child simultaneously', () async {
      final provider = Provider((ref) => 0);
      final root = createContainer(
        overrides: [provider.overrideWithValue(21)],
      );
      final container = createContainer(
        parent: root,
        overrides: [provider.overrideWithValue(42)],
      );

      expect(container.read(provider), 42);
      expect(root.read(provider), 21);
      expect(container.read(provider), 42);
      expect(root.read(provider), 21);
    });

    test('updating parent override when there is a child override is no-op',
        () async {
      final provider = Provider((ref) => 0);
      final root = createContainer(
        overrides: [provider.overrideWithValue(21)],
      );
      final container = createContainer(
        parent: root,
        overrides: [provider.overrideWithValue(42)],
      );
      final listener = Listener<int>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 42));

      root.updateOverrides([
        provider.overrideWithValue(22),
      ]);

      await container.pump();

      verifyNoMoreInteractions(listener);
    });

    test('supports auto-dispose', () async {
      final provider = Provider.autoDispose((ref) => 0);
      final container = createContainer();

      final sub = container.listen(provider, (_, __) {});
      final element = container.readProviderElement(provider);

      expect(element.mounted, true);
      expect(sub.read(), 0);

      sub.close();
      await container.pump();

      expect(element.mounted, false);

      container.dispose();

      expect(element.mounted, false);
    });

    test('are disposed on nested containers', () {
      final provider = Provider((ref) => 0);
      final root = createContainer(
        overrides: [provider.overrideWithValue(1)],
      );
      final container = createContainer(
        parent: root,
        overrides: [
          provider.overrideWithValue(42),
        ],
      );

      final element = container.readProviderElement(provider);

      expect(element.mounted, true);

      container.dispose();

      expect(element.mounted, false);
    });

    test('can update multiple ScopeProviders at once', () {
      final provider = Provider<int>((ref) => -1);
      final provider2 = Provider<int>((ref) => -1);

      final container = createContainer(
        overrides: [
          provider.overrideWithValue(21),
          provider2.overrideWithValue(42),
        ],
      );

      final listener = Listener<int>();
      final listener2 = Listener<int>();

      container.listen(provider, listener.call, fireImmediately: true);
      container.listen(provider2, listener2.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 21));
      verifyOnly(listener2, listener2(null, 42));

      container.updateOverrides([
        provider.overrideWithValue(22),
        provider2.overrideWithValue(43),
      ]);

      verifyInOrder([
        listener(21, 22),
        listener2(42, 43),
      ]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
    });

    test('handles parent override update', () {
      final provider = Provider((ref) => 0);
      final root = createContainer(
        overrides: [provider.overrideWithValue(1)],
      );
      final mid = createContainer(
        parent: root,
        overrides: [
          provider.overrideWithValue(42),
        ],
      );
      final container = createContainer(parent: mid);
      final listener = Listener<int>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 42));

      mid.updateOverrides([
        provider.overrideWithValue(21),
      ]);

      verifyOnly(listener, listener(42, 21));
    });

    test('can be overridden on non-root container', () {
      final provider = Provider((ref) => 0);
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [provider.overrideWithValue(42)],
      );

      expect(container.read(provider), 42);
    });

    test('can listen to other scoped providers', () async {
      final listener = Listener<int>();
      final provider = Provider((ref) => 0);
      final provider2 = Provider((ref) {
        return ref.watch(provider) * 2;
      });
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [
          provider.overrideWithValue(1),
          provider2,
        ],
      );

      container.listen(provider2, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 2));

      container.updateOverrides([
        provider.overrideWithValue(2),
        provider2,
      ]);

      await container.pump();

      verifyOnly(listener, listener(2, 4));
    });

    test('can listen to other normal providers', () async {
      final listener = Listener<int>();
      final provider = StateProvider((ref) => 1);
      final provider2 = Provider((ref) {
        return ref.watch(provider) * 2;
      });
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider2]);

      container.listen(provider2, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 2));

      root.read(provider.notifier).state++;

      await container.pump();

      verifyOnly(listener, listener(2, 4));
    });
  });
}
