import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';
import 'uni_directional_test.dart';

void main() {
  group('ProviderContainer', () {
    test(
        'when the same provider is overridden multiple times at once, uses the latest override',
        () {
      final provider = Provider((ref) => 0);
      final container = createContainer(
        overrides: [
          provider.overrideWithValue(21),
          provider.overrideWithValue(42),
        ],
      );

      expect(container.read(provider), 42);
      expect(container.getAllProviderElements(), [
        isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider),
      ]);
    });

    test(
        'when the same family is overridden multiple times at once, uses the latest override',
        () {
      final provider = Provider.family<int, int>((ref, value) => 0);
      final container = createContainer(
        overrides: [
          provider.overrideWithProvider((value) => Provider((ref) => 21)),
          provider.overrideWithProvider((value) => Provider((ref) => 42)),
        ],
      );

      expect(container.read(provider(0)), 42);
      expect(container.getAllProviderElements(), [
        isA<ProviderElementBase>()
            .having((e) => e.origin, 'origin', provider(0)),
      ]);
    });

    group('validate that properties respect `dependencies`', () {
      test('on reading an element, asserts that dependencies are respected',
          () {
        final dep = Provider((ref) => 0);
        final provider = Provider((ref) => ref.watch(dep));

        final root = createContainer();
        final container = createContainer(
          parent: root,
          overrides: [dep.overrideWithValue(42)],
        );

        expect(
          () => container.readProviderElement(provider),
          throwsA(isA<AssertionError>()),
        );
      });

      test(
          'on reading an element, asserts that transitive dependencies are also respected',
          () {
        final transitiveDep = Provider((ref) => 0);
        final dep = Provider((ref) => ref.watch(transitiveDep));
        final provider = Provider((ref) => ref.watch(dep));

        final root = createContainer();
        final container = createContainer(
          parent: root,
          overrides: [transitiveDep.overrideWithValue(42)],
        );

        expect(
          () => container.readProviderElement(provider),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('updateOverrides', () {
      test('is not allowed to remove overrides ', () {
        final provider = Provider((_) => 0);

        final container =
            createContainer(overrides: [provider.overrideWithValue(42)]);

        expect(container.read(provider), 42);

        expect(
          () => container.updateOverrides([]),
          throwsA(isAssertionError),
        );
      });
    });

    test(
        'after a child container is disposed, ref.watch keeps working on providers associated with the ancestor container',
        () async {
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) => ref.watch(dep.state).state);
      final listener = Listener<int>();
      final child = createContainer(parent: container);

      container.listen<int>(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      child.dispose();

      container.read(dep.state).state++;
      await container.pump();

      verifyOnly(listener, listener(0, 1));
    });

    test('flushes listened providers even if they have no external listeners',
        () async {
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) => ref.watch(dep.state).state);
      final another = StateProvider<int>((ref) {
        ref.listen(provider, (prev, value) => ref.controller.state++);
        return 0;
      });
      final container = createContainer();

      expect(container.read(another.state).state, 0);

      container.read(dep.state).state = 42;

      expect(container.read(another.state).state, 1);
    });

    group('.pump', () {
      test(
          'waits for providers to rebuild or get disposed, no matter from which container they are associated in the graph',
          () async {
        final dep = StateProvider((ref) => 0);
        final a = Provider((ref) => ref.watch(dep.state).state);
        final b = Provider((ref) => ref.watch(dep.state).state);
        final aListener = Listener<int>();
        final bListener = Listener<int>();

        final root = createContainer();
        final scoped = createContainer(parent: root, overrides: [b]);

        scoped.listen(a, aListener, fireImmediately: true);
        scoped.listen(b, bListener, fireImmediately: true);

        verifyOnly(aListener, aListener(null, 0));
        verifyOnly(bListener, bListener(null, 0));

        root.read(dep.state).state++;
        await root.pump();

        verifyOnly(aListener, aListener(0, 1));
        verifyOnly(bListener, bListener(0, 1));

        scoped.read(dep.state).state++;
        await scoped.pump();

        verifyOnly(aListener, aListener(1, 2));
        verifyOnly(bListener, bListener(1, 2));
      });
    });

    test('depth', () {
      final root = createContainer();
      final a = createContainer(parent: root);
      final b = createContainer(parent: a);
      final c = createContainer(parent: a);

      final root2 = createContainer();

      expect(root.depth, 0);
      expect(root2.depth, 0);
      expect(a.depth, 1);
      expect(b.depth, 2);
      expect(c.depth, 2);
    });

    group('getAllProviderElements', () {
      test('list scoped providers that depends on nothing', () {
        final scopedProvider = Provider<int>((ref) => 0);
        final parent = createContainer();
        final child = createContainer(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElements().single,
          isA<ProviderElement>()
              .having((e) => e.origin, 'origin', scopedProvider),
        );
      });

      test(
          'list scoped providers that depends on providers from another container',
          () {
        final dependency = Provider((ref) => 0);
        final scopedProvider = Provider<int>((ref) => ref.watch(dependency));
        final parent = createContainer();
        final child = createContainer(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElements().single,
          isA<ProviderElement>()
              .having((e) => e.origin, 'origin', scopedProvider),
        );
      });

      test(
          'list only elements associated with the container (ingoring inherited and descendent elements)',
          () {
        final provider = Provider((ref) => 0);
        final provider2 = Provider((ref) => 0);
        final provider3 = Provider((ref) => 0);
        final root = createContainer();
        final mid = createContainer(parent: root, overrides: [provider2]);
        final leaf = createContainer(parent: mid, overrides: [provider3]);

        leaf.read(provider);
        leaf.read(provider2);
        leaf.read(provider3);

        expect(
          root.getAllProviderElements().single,
          isA<ProviderElement>()
              .having((e) => e.provider, 'provider', provider),
        );
        expect(
          mid.getAllProviderElements().single,
          isA<ProviderElement>()
              .having((e) => e.provider, 'provider', provider2),
        );
        expect(
          leaf.getAllProviderElements().single,
          isA<ProviderElement>()
              .having((e) => e.provider, 'provider', provider3),
        );
      });

      test('list the currently mounted providers', () async {
        final container = ProviderContainer();
        final unrelated = Provider((_) => 42);
        final provider = Provider.autoDispose((ref) => 0);

        expect(container.read(unrelated), 42);
        var sub = container.listen(provider, (_, __) {});

        expect(
          container.getAllProviderElements(),
          unorderedMatches(<Matcher>[
            isA<ProviderElementBase<int>>(),
            isA<AutoDisposeProviderElementBase<int>>(),
          ]),
        );

        sub.close();
        await container.pump();

        expect(
          container.getAllProviderElements(),
          [isA<ProviderElementBase<int>>()],
        );

        sub = container.listen(provider, (_, __) {});

        expect(
          container.getAllProviderElements(),
          unorderedMatches(<Matcher>[
            isA<ProviderElementBase<int>>(),
            isA<AutoDisposeProviderElementBase<int>>(),
          ]),
        );
      });
    });

    group('getAllProviderElementsInOrder', () {
      test('list scoped providers that depends on nothing', () {
        final scopedProvider = Provider<int>((ref) => 0);
        final parent = createContainer();
        final child = createContainer(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElementsInOrder().single,
          isA<ProviderElement>()
              .having((e) => e.origin, 'origin', scopedProvider),
        );
      });

      test(
          'list scoped providers that depends on providers from another container',
          () {
        final dependency = Provider((ref) => 0);
        final scopedProvider = Provider<int>((ref) => ref.watch(dependency));
        final parent = createContainer();
        final child = createContainer(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElementsInOrder().single,
          isA<ProviderElement>()
              .having((e) => e.origin, 'origin', scopedProvider),
        );
      });
    });

    test(
        'does not re-initialize a provider if read by a child container after the provider was initialized',
        () {
      final root = createContainer();
      // the child must be created before the provider is initialized
      final child = createContainer(parent: root);

      var buildCount = 0;
      final provider = Provider((ref) {
        buildCount++;
        return 0;
      });

      expect(root.read(provider), 0);

      expect(buildCount, 1);

      expect(child.read(provider), 0);

      expect(buildCount, 1);
    });

    test('can downcast the listener value', () {
      final container = createContainer();
      final provider = StateProvider<int>((ref) => 0);
      final listener = Listener<void>();

      container.listen<void>(provider, listener);

      verifyZeroInteractions(listener);

      container.read(provider.state).state++;

      verifyOnly(listener, listener(any, any));
    });

    test(
      'can close a ProviderSubscription multiple times with no effect',
      () {
        final container = createContainer();
        final provider =
            StateNotifierProvider<StateController<int>, int>((ref) {
          return StateController(0);
        });
        final listener = Listener<int>();

        final controller = container.read(provider.notifier);

        final sub = container.listen(provider, listener);

        sub.close();
        sub.close();

        controller.state++;

        verifyZeroInteractions(listener);
      },
    );

    test(
      'closing an already closed ProviderSubscription does not remove subscriptions with the same listener',
      () {
        final container = createContainer();
        final provider =
            StateNotifierProvider<StateController<int>, int>((ref) {
          return StateController(0);
        });
        final listener = Listener<int>();

        final controller = container.read(provider.notifier);

        final sub = container.listen(provider, listener);
        container.listen(provider, listener);

        controller.state++;

        verify(listener(0, 1)).called(2);
        verifyNoMoreInteractions(listener);

        sub.close();
        sub.close();

        controller.state++;

        verifyOnly(listener, listener(1, 2));
      },
    );

    test('builds providers at most once per container', () {
      var result = 42;
      final container = createContainer();
      var callCount = 0;
      final provider = Provider((_) {
        callCount++;
        return result;
      });

      expect(callCount, 0);
      expect(container.read(provider), 42);
      expect(callCount, 1);
      expect(container.read(provider), 42);
      expect(callCount, 1);

      final container2 = createContainer();

      result = 21;
      expect(container2.read(provider), 21);
      expect(callCount, 2);
      expect(container2.read(provider), 21);
      expect(callCount, 2);
      expect(container.read(provider), 42);
      expect(callCount, 2);
    });
    test(
      'does not refresh providers if their dependencies changes but they have no active listeners',
      () async {
        final container = createContainer();

        var buildCount = 0;
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          buildCount++;
          return ref.watch(dep.state).state;
        });

        container.read(provider);

        expect(buildCount, 1);

        container.read(dep.state).state++;
        await container.pump();

        expect(buildCount, 1);
      },
    );
  });
}
