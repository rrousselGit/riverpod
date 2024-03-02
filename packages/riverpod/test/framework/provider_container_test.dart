import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('ProviderContainer', () {
    group('invalidate', () {
      test('can disposes of the element if not used anymore', () async {
        final provider = Provider.autoDispose((r) {
          r.keepAlive();
          return 0;
        });
        final container = createContainer();

        container.read(provider);
        container.invalidate(provider);

        await container.pump();

        expect(container.getAllProviderElements(), isEmpty);
      });
    });

    test('Supports unmounting containers in reverse order', () {
      final container = createContainer();

      final child = createContainer(parent: container);

      container.dispose();
      child.dispose();
    });

    group('when unmounting providers', () {
      test(
          'cleans up all the StateReaders of a provider in the entire ProviderContainer tree',
          () async {
        // Regression test for https://github.com/rrousselGit/riverpod/issues/1943
        final a = createContainer();
        // b/c voluntarily do not use the Provider, but a/d do. This is to test
        // that the disposal logic correctly cleans up the StateReaders
        // in all ProviderContainers associated with the provider, even if
        // some links between two ProviderContainers are not using the provider.
        final b = createContainer(parent: a);
        final c = createContainer(parent: b);
        final d = createContainer(parent: c);

        final provider = Provider.autoDispose((ref) => 3);

        final subscription = d.listen(
          provider,
          (previous, next) {},
          fireImmediately: true,
        );

        expect(a.hasStateReaderFor(provider), true);
        expect(b.hasStateReaderFor(provider), false);
        expect(c.hasStateReaderFor(provider), false);
        expect(d.hasStateReaderFor(provider), true);

        subscription.close();

        expect(a.hasStateReaderFor(provider), true);
        expect(b.hasStateReaderFor(provider), false);
        expect(c.hasStateReaderFor(provider), false);
        expect(d.hasStateReaderFor(provider), true);

        await a.pump();

        expect(a.hasStateReaderFor(provider), false);
        expect(b.hasStateReaderFor(provider), false);
        expect(c.hasStateReaderFor(provider), false);
        expect(d.hasStateReaderFor(provider), false);

        d.listen(
          provider,
          (previous, next) {},
          fireImmediately: true,
        );

        expect(a.hasStateReaderFor(provider), true);
        expect(b.hasStateReaderFor(provider), false);
        expect(c.hasStateReaderFor(provider), false);
        expect(d.hasStateReaderFor(provider), true);
      });
    });

    group('exists', () {
      test('simple use-case', () {
        final container = createContainer();
        final provider = Provider((ref) => 0);

        expect(container.exists(provider), false);
        expect(container.getAllProviderElements(), isEmpty);

        container.read(provider);

        expect(container.exists(provider), true);
      });

      test('handles autoDispose', () async {
        final provider = Provider.autoDispose((ref) => 0);
        final container = createContainer(
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
        final container = createContainer(
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
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider2]);

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

    group('debugReassemble', () {
      test(
          'reload providers if the debugGetCreateSourceHash of a provider returns a different value',
          () {
        final noDebugGetCreateSourceHashBuild = OnBuildMock();
        final noDebugGetCreateSourceHash = Provider((ref) {
          noDebugGetCreateSourceHashBuild();
          return 0;
        });
        final constantHashBuild = OnBuildMock();
        final constantHash = Provider.internal(
          name: null,
          dependencies: null,
          allTransitiveDependencies: null,
          debugGetCreateSourceHash: () => 'hash',
          (ref) {
            constantHashBuild();
            return 0;
          },
        );
        var hashResult = '42';
        final changingHashBuild = OnBuildMock();
        final changingHash = Provider.internal(
          name: null,
          dependencies: null,
          allTransitiveDependencies: null,
          debugGetCreateSourceHash: () => hashResult,
          (ref) {
            changingHashBuild();
            return 0;
          },
        );
        final container = ProviderContainer();

        container.read(noDebugGetCreateSourceHash);
        container.read(constantHash);
        container.read(changingHash);

        clearInteractions(noDebugGetCreateSourceHashBuild);
        clearInteractions(constantHashBuild);
        clearInteractions(changingHashBuild);

        hashResult = 'new hash';
        container.debugReassemble();
        container.read(noDebugGetCreateSourceHash);
        container.read(constantHash);
        container.read(changingHash);

        verifyOnly(changingHashBuild, changingHashBuild());
        verifyNoMoreInteractions(constantHashBuild);
        verifyNoMoreInteractions(noDebugGetCreateSourceHashBuild);

        container.debugReassemble();
        container.read(noDebugGetCreateSourceHash);
        container.read(constantHash);
        container.read(changingHash);

        verifyNoMoreInteractions(changingHashBuild);
        verifyNoMoreInteractions(constantHashBuild);
        verifyNoMoreInteractions(noDebugGetCreateSourceHashBuild);
      });
    });

    test('invalidate triggers a rebuild on next frame', () async {
      final container = createContainer();
      final listener = Listener<int>();
      var result = 0;
      final provider = Provider((r) => result);

      container.listen(provider, listener.call);
      verifyZeroInteractions(listener);

      container.invalidate(provider);
      container.invalidate(provider);
      result = 1;

      verifyZeroInteractions(listener);

      await container.pump();

      verifyOnly(listener, listener(0, 1));
    });

    test(
        'when using overrideWithProvider, handles overriding with a more specific provider type',
        () {
      final fooProvider = Provider<Foo>((ref) => Foo());

      final container = createContainer(
        overrides: [
          // ignore: deprecated_member_use_from_same_package
          fooProvider.overrideWithProvider(
            Provider<Bar>((ref) => Bar()),
          ),
        ],
      );

      expect(container.read(fooProvider), isA<Bar>());
    });

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
        isA<ProviderElementBase<Object?>>()
            .having((e) => e.origin, 'origin', provider),
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
        isA<ProviderElementBase<Object?>>()
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
      final provider = Provider((ref) => ref.watch(dep));
      final listener = Listener<int>();
      final child = createContainer(parent: container);

      container.listen<int>(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      child.dispose();

      container.read(dep.notifier).state++;
      await container.pump();

      verifyOnly(listener, listener(0, 1));
    });

    test(
        'flushes listened-to providers even if they have no external listeners',
        () async {
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) => ref.watch(dep));
      final another = StateProvider<int>((ref) {
        ref.listen(provider, (prev, value) => ref.controller.state++);
        return 0;
      });
      final container = createContainer();

      expect(container.read(another), 0);

      container.read(dep.notifier).state = 42;

      expect(container.read(another), 1);
    });

    test(
        'flushes listened-to providers even if they have no external listeners (with ProviderListenable)',
        () async {
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) => ref.watch(dep));
      final another = StateProvider<int>((ref) {
        ref.listen(provider, (prev, value) => ref.controller.state++);
        return 0;
      });
      final container = createContainer();

      expect(container.read(another), 0);

      container.read(dep.notifier).state = 42;

      expect(container.read(another), 1);
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

        final root = createContainer();
        final scoped = createContainer(parent: root, overrides: [b]);

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
          isA<ProviderElement<Object?>>()
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
          isA<ProviderElement<Object?>>()
              .having((e) => e.origin, 'origin', scopedProvider),
        );
      });

      test(
          'list only elements associated with the container (ignoring inherited and descendent elements)',
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
          isA<ProviderElement<Object?>>()
              .having((e) => e.provider, 'provider', provider),
        );
        expect(
          mid.getAllProviderElements().single,
          isA<ProviderElement<Object?>>()
              .having((e) => e.provider, 'provider', provider2),
        );
        expect(
          leaf.getAllProviderElements().single,
          isA<ProviderElement<Object?>>()
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
            isA<AutoDisposeProviderElementMixin<int>>(),
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
            isA<AutoDisposeProviderElementMixin<int>>(),
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
          isA<ProviderElement<Object?>>()
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
          isA<ProviderElement<Object?>>()
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

      container.listen<void>(provider, listener.call);

      verifyZeroInteractions(listener);

      container.read(provider.notifier).state++;

      verifyOnly(listener, listener(any, any));
    });

    test(
      'can close a ProviderSubscription<Object?> multiple times with no effect',
      () {
        final container = createContainer();
        final provider =
            StateNotifierProvider<StateController<int>, int>((ref) {
          return StateController(0);
        });
        final listener = Listener<int>();

        final controller = container.read(provider.notifier);

        final sub = container.listen(provider, listener.call);

        sub.close();
        sub.close();

        controller.state++;

        verifyZeroInteractions(listener);
      },
    );

    test(
      'closing an already closed ProviderSubscription<Object?> does not remove subscriptions with the same listener',
      () {
        final container = createContainer();
        final provider =
            StateNotifierProvider<StateController<int>, int>((ref) {
          return StateController(0);
        });
        final listener = Listener<int>();

        final controller = container.read(provider.notifier);

        final sub = container.listen(provider, listener.call);
        container.listen(provider, listener.call);

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
          return ref.watch(dep);
        });

        container.read(provider);

        expect(buildCount, 1);

        container.read(dep.notifier).state++;
        await container.pump();

        expect(buildCount, 1);
      },
    );
  });
}

class Foo {}

class Bar extends Foo {}
