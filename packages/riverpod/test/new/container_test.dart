import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

void main() {
  group('ProviderContainer', () {
    group('constructor', () {
      test('throws if "parent" is disposed', () {
        // TODO changelog

        final root = ProviderContainer();
        root.dispose();

        expect(
          () => ProviderContainer(parent: root),
          throwsStateError,
        );
      });

      test('if parent is null, assign "root" to "null"', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        expect(container.root, null);
      });

      test('if parent is not null, assign "root" to "parent.root"', () {
        final root = ProviderContainer();
        addTearDown(root.dispose);
        final container = ProviderContainer(parent: root);
        addTearDown(container.dispose);

        expect(container.root, root);
      });

      test('assign "parent" to "this.parent"', () {
        final root = ProviderContainer();
        addTearDown(root.dispose);
        final container = ProviderContainer(parent: root);
        addTearDown(container.dispose);

        expect(container.parent, root);
      });

      test('Adds "this" to "root.children"', () {
        final root = ProviderContainer();
        addTearDown(root.dispose);
        final container = ProviderContainer(parent: root);
        addTearDown(container.dispose);

        expect(root.children, [container]);
      });
    });

    group('.test', () {
      test('Auto-disposes the provider when the test ends', () {
        late ProviderContainer container;

        addTearDown(() => expect(container.disposed, true));

        container = ProviderContainer.test();

        addTearDown(() => expect(container.disposed, false));
      });

      test('Passes parameters', () {
        final provider = Provider((ref) => 0);
        final observer = _EmptyObserver();

        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          observers: [observer],
          overrides: [
            provider.overrideWithValue(1),
          ],
        );

        expect(container.root, root);
        expect(container.observers, [observer]);
        expect(container.read(provider), 1);
      });
    });

    group('dispose', () {
      test('throws if a child is not disposed', () {
        final root = ProviderContainer.test();
        ProviderContainer.test(parent: root);

        expect(root.dispose, throwsStateError);
      });

      test('removes "this" from "root.children"', () {
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(parent: root);
        final leaf = ProviderContainer.test(parent: container);
        final leaf2 = ProviderContainer.test(parent: container);

        expect(root.children, [container]);
        expect(container.children, [leaf, leaf2]);
        expect(leaf.children, isEmpty);
        expect(leaf2.children, isEmpty);

        leaf.dispose();

        expect(root.children, [container]);
        expect(container.children, [leaf2]);

        leaf2.dispose();

        expect(root.children, [container]);
        expect(container.children, isEmpty);

        container.dispose();

        expect(root.children, isEmpty);
      });
    });

    group('exists', () {
      test('simple use-case', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);

        expect(container.exists(provider), false);
        expect(container.getAllProviderElements(), isEmpty);

        container.read(provider);

        expect(container.exists(provider), true);
      });

      test('handles autoDispose', () async {
        final provider = Provider.autoDispose((ref) => 0);
        final container = ProviderContainer.test(
          overrides: [
            provider.overrideWith((ref) => 42),
          ],
        );

        expect(container.exists(provider), false);
        expect(container.getAllProviderElements(), isEmpty);

        container.read(provider);

        expect(container.exists(provider), true);

        await container.pump();

        expect(container.getAllProviderElements(), isEmpty);
        expect(container.exists(provider), false);
        expect(container.getAllProviderElements(), isEmpty);
      });

      test('Handles uninitialized overrideWith', () {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test(
          overrides: [
            provider.overrideWith((ref) => 42),
          ],
        );

        expect(container.exists(provider), false);
        expect(container.getAllProviderElements(), isEmpty);

        container.read(provider);

        expect(container.exists(provider), true);
      });

      test('handles nested providers', () {
        final provider = Provider((ref) => 0);
        final provider2 = Provider((ref) => 0);
        final root = ProviderContainer.test();
        final container =
            ProviderContainer.test(parent: root, overrides: [provider2]);

        expect(container.exists(provider), false);
        expect(container.exists(provider2), false);
        expect(container.getAllProviderElements(), isEmpty);
        expect(root.getAllProviderElements(), isEmpty);

        container.read(provider);

        expect(container.exists(provider), true);
        expect(container.exists(provider2), false);
        expect(container.getAllProviderElements(), isEmpty);
        expect(root.getAllProviderElements().map((e) => e.origin), [provider]);

        container.read(provider2);

        expect(container.exists(provider2), true);
        expect(
          container.getAllProviderElements().map((e) => e.origin),
          [provider2],
        );
        expect(root.getAllProviderElements().map((e) => e.origin), [provider]);
      });
    });
  });
}

class _EmptyObserver extends ProviderObserver {}
