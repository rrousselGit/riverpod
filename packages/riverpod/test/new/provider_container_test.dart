import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  tearDown(() {
    // Verifies that there is no container leak.
    expect(DebugRiverpodDevtoolBiding.containers, isEmpty);
  });

  group('ProviderContainer', () {
    group('constructor', () {
      test('registers itself in the container list', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        expect(DebugRiverpodDevtoolBiding.containers, [container]);
      });

      test('throws if "parent" is disposed', () {
        // TODO changelog

        final root = ProviderContainer();
        root.dispose();

        expect(
          () => ProviderContainer(parent: root),
          throwsStateError,
        );

        expect(
          root.children,
          isEmpty,
          reason: 'Invalid containers should not be added as children',
        );
        expect(
          DebugRiverpodDevtoolBiding.containers,
          isEmpty,
          reason: 'Invalid containers should not be added to the global list',
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

      group('overrides', () {
        test(
            'throws if the same provider is overridden twice in the same container',
            () {
          // TODO changelog
          final provider = Provider((ref) => 0);

          expect(
            () => ProviderContainer(
              overrides: [
                provider.overrideWithValue(42),
                provider.overrideWithValue(21),
              ],
            ),
            throwsStateError,
          );
        });

        test(
            'throws if the same family is overridden twice in the same container',
            () {
          // TODO changelog
          final provider = Provider.family<int, int>((ref, id) => 0);

          expect(
            () => ProviderContainer(
              overrides: [
                provider.overrideWith((ref, arg) => arg),
                provider.overrideWith((ref, arg) => arg),
              ],
            ),
            throwsStateError,
          );
        });

        test(
            'supports overriding an already overridden provider/family in a different container',
            () {
          final provider = Provider((ref) => 0);
          final family = Provider.family<int, int>((ref, id) => 0);
          final root = ProviderContainer(
            overrides: [
              provider.overrideWithValue(42),
              family.overrideWith((ref, arg) => arg),
            ],
          );
          addTearDown(root.dispose);

          final container = ProviderContainer(
            parent: root,
            overrides: [
              provider.overrideWithValue(21),
              family.overrideWith((ref, arg) => arg * 2),
            ],
          );
          addTearDown(container.dispose);
        });
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
      test(
          'after a child container is disposed, '
          'ref.watch keeps working on providers associated with the ancestor container',
          () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) => ref.watch(dep));
        final listener = Listener<int>();
        final child = ProviderContainer.test(parent: container);

        container.listen<int>(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, 0));

        child.dispose();

        container.read(dep.notifier).state++;
        await container.pump();

        verifyOnly(listener, listener(0, 1));
      });

      test('unregister itself from the container list', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        expect(DebugRiverpodDevtoolBiding.containers, [container]);

        container.dispose();

        expect(DebugRiverpodDevtoolBiding.containers, isEmpty);
      });

      test('Disposes its children first', () {
        final rootOnDispose = OnDisposeMock();
        final childOnDispose = OnDisposeMock();
        final child2OnDispose = OnDisposeMock();
        final provider = Provider((ref) {
          ref.onDispose(rootOnDispose.call);
          return 0;
        });

        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            provider.overrideWith((ref) {
              ref.onDispose(childOnDispose.call);
              return 0;
            }),
          ],
        );
        final container2 = ProviderContainer.test(
          parent: root,
          overrides: [
            provider.overrideWith((ref) {
              ref.onDispose(child2OnDispose.call);
              return 0;
            }),
          ],
        );

        root.listen(provider, (previous, next) {});
        container.listen(provider, (previous, next) {});
        container2.listen(provider, (previous, next) {});

        container2.dispose();

        verifyOnly(child2OnDispose, child2OnDispose.call());
        verifyZeroInteractions(childOnDispose);
        verifyZeroInteractions(rootOnDispose);
        expect(container.disposed, false);
        expect(root.disposed, false);

        root.dispose();

        verifyInOrder([
          childOnDispose.call(),
          rootOnDispose.call(),
        ]);

        expect(container.disposed, true);
        expect(root.disposed, true);
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

    group('.pump', () {
      test(
          'Waits for providers associated with this container and its parents to rebuild',
          () async {
        final dep = StateProvider((ref) => 0);
        final a = Provider((ref) => ref.watch(dep));
        final b = Provider((ref) => ref.watch(dep));
        final aListener = Listener<int>();
        final bListener = Listener<int>();

        final root = ProviderContainer.test();
        final scoped = ProviderContainer.test(parent: root, overrides: [b]);

        scoped.listen(a, aListener.call, fireImmediately: true);
        scoped.listen(b, bListener.call, fireImmediately: true);

        verifyOnly(aListener, aListener(null, 0));
        verifyOnly(bListener, bListener(null, 0));

        root.read(dep.notifier).state++;
        await scoped.pump();

        verifyOnly(aListener, aListener(0, 1));
        verifyOnly(bListener, bListener(0, 1));

        scoped.read(dep.notifier).state++;
        await scoped.pump();

        verifyOnly(aListener, aListener(1, 2));
        verifyOnly(bListener, bListener(1, 2));
      });
    });

    test('depth', () {
      final root = ProviderContainer.test();
      final a = ProviderContainer.test(parent: root);
      final b = ProviderContainer.test(parent: a);
      final c = ProviderContainer.test(parent: a);

      final root2 = ProviderContainer.test();

      expect(root.depth, 0);
      expect(root2.depth, 0);
      expect(a.depth, 1);
      expect(b.depth, 2);
      expect(c.depth, 2);
    });
  });
}

class _EmptyObserver extends ProviderObserver {}
