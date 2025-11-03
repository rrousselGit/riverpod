// Tests related to scoping providers

import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart' show ProviderContainerTest;
import 'package:riverpod/src/internals.dart'
    show
        $ProviderElement,
        ProviderElement,
        ProviderFamily,
        InternalProviderContainer;
import 'package:test/test.dart';

import '../src/core/provider_container_test.dart';

Future<void> main() async {
  test('Supports reading a provider out of scope, '
      'then adding a scope override', () {
    // Regression test for https://github.com/rrousselGit/riverpod/issues/4324
    final root = ProviderContainer.test();
    final provider = Provider((ref) => 0, dependencies: []);
    final transitive = Provider(
      (ref) => ref.watch(provider),
      dependencies: [provider],
    );

    root.read(transitive);

    final leaf = ProviderContainer.test(
      parent: root,
      overrides: [provider.overrideWithValue(42)],
    );

    expect(leaf.read(transitive), 42);
  });

  test('does not throw when scoping a provider with no dependencies', () {
    final a = Provider((ref) => 0);
    final b = Provider.family((ref, _) => 0);
    final root = ProviderContainer.test();
    final container = ProviderContainer.test(parent: root, overrides: [a, b]);

    expect(container.read(a), 0);
    expect(container.read(b(0)), 0);
  });

  test('reading a provider from a scoped container, '
      'then adding a new container with an override, '
      'then reading from the new container correctly auto-scope again', () {
    final a = Provider((ref) => 0, dependencies: const []);
    final b = Provider((ref) => ref.watch(a) + 10, dependencies: [a]);

    final root = ProviderContainer.test();
    final mid = ProviderContainer.test(
      parent: root,
      overrides: [a.overrideWithValue(42)],
    );

    expect(mid.read(b), 52);

    final child = ProviderContainer.test(
      parent: mid,
      overrides: [a.overrideWithValue(84)],
    );

    expect(child.read(b), 94);
  });

  test(
    'reading a provider from a scoped container, '
    'then reading from container further down the tree correctly auto-scope again',
    () {
      final a = Provider((ref) => 0, dependencies: const []);
      final b = Provider((ref) => ref.watch(a) + 10, dependencies: [a]);

      final root = ProviderContainer.test();
      final mid = ProviderContainer.test(
        parent: root,
        overrides: [a.overrideWithValue(42)],
      );
      final child = ProviderContainer.test(
        parent: mid,
        overrides: [a.overrideWithValue(84)],
      );

      expect(mid.read(b), 52);
      expect(child.read(b), 94);
    },
  );

  test(
    'reading a family override from a scoped container, '
    'then adding a new container with the same family overridden again, '
    'then reading from the new container correctly obtains the new override',
    () {
      final a = Provider.family<int, int>(
        (ref, id) => id,
        dependencies: const [],
      );

      final root = ProviderContainer.test();
      final mid = ProviderContainer.test(
        parent: root,
        overrides: [a.overrideWith((ref, argument) => argument + 10)],
      );

      expect(mid.read(a(10)), 20);

      final override2 = a.overrideWith((ref, argument) => argument + 20);
      final child = ProviderContainer.test(parent: mid, overrides: [override2]);

      expect(
        child.pointerManager.familyPointers[a],
        isProviderDirectory(
          override: override2,
          targetContainer: child,
          pointers: {},
        ),
      );

      expect(child.read(a(10)), 30);
    },
  );

  test(
    'reading a family override from a scoped container, '
    'then reading from container further down the tree correctly uses the deepest override',
    () {
      final a = Provider.family<int, int>(
        (ref, id) => id,
        dependencies: const [],
      );

      final root = ProviderContainer.test();
      final mid = ProviderContainer.test(
        parent: root,
        overrides: [a.overrideWith((ref, argument) => argument + 10)],
      );

      final child = ProviderContainer.test(
        parent: mid,
        overrides: [a.overrideWith((ref, argument) => argument + 20)],
      );

      expect(mid.read(a(10)), 20);
      expect(child.read(a(10)), 30);
    },
  );

  test(
    'reading a family override from a scoped container, '
    'then reading from container further down the tree reuse the provider state when possible',
    () {
      final a = Provider.family<int, int>(
        (ref, id) => id,
        dependencies: const [],
      );
      var overrideBuildCount = 0;
      final root = ProviderContainer.test();
      final mid = ProviderContainer.test(
        parent: root,
        overrides: [
          a.overrideWith((ref, argument) {
            overrideBuildCount++;
            return argument + 10;
          }),
        ],
      );

      expect(overrideBuildCount, 0);
      expect(mid.read(a(10)), 20);
      expect(overrideBuildCount, 1);

      final child = ProviderContainer.test(parent: mid);

      expect(child.read(a(10)), 20);
      expect(overrideBuildCount, 1);
    },
  );

  group('Scoping non-family providers', () {
    test(
      'can override a provider with a reference to the provider directly',
      () {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();
        final child = ProviderContainer.test(overrides: [provider]);

        expect(child.read(provider), 0);

        expect(child.getAllProviderElements(), [
          isA<$ProviderElement<Object?>>().having(
            (e) => e.provider,
            'provider',
            provider,
          ),
        ]);
        expect(container.getAllProviderElements(), isEmpty);
      },
    );

    test('use latest override on mount', () {
      final provider = Provider((ref) => 0, dependencies: const []);
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [provider.overrideWithValue(42)],
      );

      container.updateOverrides([provider.overrideWithValue(21)]);

      expect(container.read(provider), 21);
    });

    test('updating scoped override does not mount the provider', () {
      final provider = Provider((ref) => 0, dependencies: const []);
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [provider.overrideWithValue(42)],
      );

      container.updateOverrides([provider.overrideWithValue(21)]);

      expect(container.getAllProviderElements(), isEmpty);
      expect(root.getAllProviderElements(), isEmpty);
    });

    test(
      'does not re-initialize a provider if read by an intermediary container',
      () {
        var callCount = 0;
        final provider = Provider((ref) {
          callCount++;
          return 42;
        }, dependencies: const []);
        final root = ProviderContainer.test();
        final mid = ProviderContainer.test(parent: root, overrides: [provider]);
        final container = ProviderContainer.test(parent: mid);

        expect(mid.read(provider), 42);
        expect(callCount, 1);

        expect(container.read(provider), 42);
        expect(callCount, 1);

        expect(root.getAllProviderElements(), isEmpty);
      },
    );
  });

  group('Scoping family', () {
    test('use latest override on mount', () {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider = Provider.family<String, int>(
        (ref, value) => '$value ${ref.watch(dep)}',
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(1), provider],
      );

      container.updateOverrides([dep.overrideWithValue(2), provider]);

      expect(container.read(provider(0)), '0 2');
    });

    test('updating scoped override does not mount the provider', () {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider = Provider.family<String, int>(
        (ref, value) => '$value ${ref.watch(dep)}',
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(1), provider],
      );

      container.updateOverrides([dep.overrideWithValue(2), provider]);

      expect(container.getAllProviderElements(), isEmpty);
      expect(root.getAllProviderElements(), isEmpty);
    });

    test('can override a family with a reference to the provider directly', () {
      final provider = Provider.family<int, int>((ref, param) => 0);
      final container = ProviderContainer.test();
      final child = ProviderContainer.test(overrides: [provider]);

      expect(child.read(provider(0)), 0);

      expect(child.getAllProviderElements(), [
        isA<$ProviderElement<Object?>>().having(
          (e) => e.provider,
          'provider',
          provider(0),
        ),
      ]);
      expect(container.getAllProviderElements(), isEmpty);
    });

    test(
      'does not re-initialize a provider if read by an intermediary container',
      () {
        final dep = Provider((ref) => 0, dependencies: const []);
        var callCount = 0;
        final provider = Provider.family<String, int>((ref, value) {
          callCount++;
          return '$value ${ref.watch(dep)}';
        }, dependencies: [dep]);
        final root = ProviderContainer.test();
        final mid = ProviderContainer.test(
          parent: root,
          overrides: [dep.overrideWithValue(1), provider],
        );
        final container = ProviderContainer.test(parent: mid);

        expect(mid.read(provider(0)), '0 1');
        expect(callCount, 1);

        expect(container.read(provider(0)), '0 1');
        expect(callCount, 1);
      },
    );
  });

  group('When specifying "dependencies"', () {
    test(
      'a family can read itself, even if not present in the dependencies list',
      () {
        final dep = Provider((ref) => 'foo');
        late final ProviderFamily<String, int> provider;
        provider = Provider.family<String, int>((ref, id) {
          if (id == 0) return ref.watch(dep);
          return ref.watch(provider(0));
        }, dependencies: [dep]);
        final container = ProviderContainer.test();

        expect(container.read(provider(42)), 'foo');
      },
    );

    test('auto scope direct provider dependencies', () {
      final dep = Provider((ref) => 0, name: 'dep', dependencies: const []);
      var buildCount = 0;
      final provider = Provider(name: 'provider', dependencies: [dep], (ref) {
        buildCount++;
        return ref.watch(dep);
      });
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );
      final child = ProviderContainer.test(parent: container);
      final subChild = ProviderContainer.test(parent: child);

      expect(buildCount, 0);
      expect(container.read(provider), 42);
      expect(buildCount, 1);
      expect(root.read(provider), 0);
      expect(buildCount, 2);
      expect(child.read(provider), 42);
      expect(buildCount, 2);
      expect(subChild.read(provider), 42);
      expect(buildCount, 2);

      final lateChild = ProviderContainer.test(parent: container);

      expect(lateChild.read(provider), 42);
      expect(buildCount, 2);
    });

    test(
      'auto scope still works if the first read of the auto-override is through a child container',
      () {
        final dep = Provider((ref) => 0, name: 'dep', dependencies: const []);
        var buildCount = 0;
        final provider = Provider(dependencies: [dep], name: 'provider', (ref) {
          buildCount++;
          return ref.watch(dep);
        });
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [dep.overrideWithValue(42)],
        );
        final child = ProviderContainer.test(parent: container);
        final subChild = ProviderContainer.test(parent: child);

        expect(subChild.read(provider), 42);
        expect(buildCount, 1);
        expect(child.read(provider), 42);
        expect(buildCount, 1);
        expect(container.read(provider), 42);
        expect(buildCount, 1);
        expect(root.read(provider), 0);
        expect(buildCount, 2);
      },
    );

    test('auto scope transitive provider dependency', () {
      var depBuildCount = 0;
      final dep = Provider(name: 'dep', (ref) {
        depBuildCount++;
        return 0;
      }, dependencies: const []);
      var dep2BuildCount = 0;
      final dep2 = Provider.family<int, int>(
        (ref, multiplier) {
          dep2BuildCount++;
          return ref.watch(dep) * multiplier;
        },
        name: 'dep2',
        dependencies: [dep],
      );
      var dep3BuildCount = 0;
      final dep3 = Provider(
        (ref) {
          dep3BuildCount++;
          return ref.watch(dep2(2));
        },
        name: 'dep3',
        dependencies: [dep2],
      );
      var buildCount = 0;
      final provider = Provider(dependencies: [dep3], name: 'provider', (ref) {
        buildCount++;
        return ref.watch(dep3).toString();
      });

      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );
      final child = ProviderContainer.test(parent: container);
      final subChild = ProviderContainer.test(parent: child);

      expect(buildCount, 0);

      expect(container.read(provider), '84');
      expect(container.read(dep3), 84);
      expect(container.read(dep2(2)), 84);
      expect(container.read(dep), 42);
      expect(buildCount, 1);
      expect(dep3BuildCount, 1);
      expect(dep2BuildCount, 1);
      expect(depBuildCount, 0);

      expect(root.read(provider), '0');
      expect(root.read(dep3), 0);
      expect(root.read(dep2(2)), 0);
      expect(root.read(dep), 0);
      expect(buildCount, 2);
      expect(dep3BuildCount, 2);
      expect(dep2BuildCount, 2);
      expect(depBuildCount, 1);

      expect(child.read(provider), '84');
      expect(child.read(dep3), 84);
      expect(child.read(dep2(2)), 84);
      expect(child.read(dep), 42);
      expect(buildCount, 2);
      expect(dep3BuildCount, 2);
      expect(dep2BuildCount, 2);
      expect(depBuildCount, 1);

      expect(subChild.read(provider), '84');
      expect(subChild.read(dep3), 84);
      expect(subChild.read(dep2(2)), 84);
      expect(subChild.read(dep), 42);
      expect(buildCount, 2);
      expect(dep3BuildCount, 2);
      expect(dep2BuildCount, 2);
      expect(depBuildCount, 1);

      final lateChild = ProviderContainer.test(parent: container);

      expect(lateChild.read(provider), '84');
      expect(container.read(dep3), 84);
      expect(buildCount, 2);
      expect(dep3BuildCount, 2);
    });

    test(
      'when provider depends on multiple overrides, is placed on the deepest container',
      () {
        final dep = Provider((ref) => 0, name: 'dep', dependencies: const []);
        final dep2 = Provider((ref) => 0, name: 'dep2', dependencies: const []);
        final a = Provider(
          (ref) => ref.watch(dep) + ref.watch(dep2),
          dependencies: [dep, dep2],
          name: 'a',
        );
        final b = Provider(
          (ref) => ref.watch(dep) - ref.watch(dep2),
          dependencies: [
            dep2,
            dep,
          ], // checking that the 'dependencies' order doesn't matter
          name: 'b',
        );
        final root = ProviderContainer.test();
        final mid = ProviderContainer.test(
          parent: root,
          overrides: [dep.overrideWithValue(42)],
        );
        final mid2 = ProviderContainer.test(
          parent: mid,
          overrides: [dep2.overrideWithValue(21)],
        );
        final container = ProviderContainer.test(parent: mid2);

        expect(container.read(a), 63);
        expect(container.read(b), 21);

        expect(container.getAllProviderElements(), isEmpty);
        expect(
          mid2.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having((e) => e.origin, 'origin', dep2),
            isA<ProviderElement>().having((e) => e.origin, 'origin', a),
            isA<ProviderElement>().having((e) => e.origin, 'origin', b),
          ]),
        );
        expect(mid.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', dep),
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      },
    );

    test(
      'skips containers with overrides that do not match the "dependencies"',
      () {
        final dep = Provider((ref) => 0, name: 'dep', dependencies: const []);
        final dep2 = Provider((ref) => 0, name: 'dep2', dependencies: const []);
        final a = Provider(
          (ref) => ref.watch(dep),
          dependencies: [dep],
          name: 'a',
        );
        final root = ProviderContainer.test();
        final mid = ProviderContainer.test(
          parent: root,
          overrides: [dep.overrideWithValue(42)],
        );
        final mid2 = ProviderContainer.test(
          parent: mid,
          overrides: [dep2.overrideWithValue(21)],
        );
        final container = ProviderContainer.test(parent: mid2);

        expect(container.read(a), 42);

        expect(container.getAllProviderElements(), isEmpty);
        expect(mid2.getAllProviderElements(), isEmpty);
        expect(
          mid.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having((e) => e.origin, 'origin', dep),
            isA<ProviderElement>().having((e) => e.origin, 'origin', a),
          ]),
        );
        expect(root.getAllProviderElements(), isEmpty);
      },
    );

    test(
      'when a provider with dependencies is overridden with a value, '
      'it is no longer automatically overridden if a lower container overrides a dependency',
      () {
        final dep = Provider((ref) => 0, dependencies: const []);
        final provider = Provider((ref) => ref.watch(dep), dependencies: [dep]);
        final root = ProviderContainer.test();
        final mid = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWithValue(42)],
        );
        final container = ProviderContainer.test(
          parent: mid,
          overrides: [dep.overrideWithValue(84)],
        );

        expect(container.read(provider), 42);
        expect(mid.read(provider), 42);

        expect(container.getAllProviderElements(), isEmpty);
        expect(mid.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
        ]);
      },
    );

    test('auto scope direct family dependencies', () {
      final family = Provider.family<int, int>(
        (ref, id) => id * 2,
        dependencies: const [],
      );
      final provider = Provider(
        (ref) => ref.watch(family(21)),
        dependencies: [family],
      );
      final root = ProviderContainer.test();
      final mid = ProviderContainer.test(parent: root, overrides: [family]);
      final container = ProviderContainer.test(parent: mid);

      expect(container.read(provider), 42);
      expect(mid.read(provider), 42);

      expect(container.getAllProviderElements(), isEmpty);
      expect(
        mid.getAllProviderElements(),
        unorderedEquals(<Object>[
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          isA<ProviderElement>().having((e) => e.origin, 'origin', family(21)),
        ]),
      );
    });

    test('auto scope transitive family dependencies', () {
      final family = Provider.family<int, int>(
        (ref, id) => id * 2,
        dependencies: [],
      );
      final dep = Provider(
        (ref) => ref.watch(family(21)),
        dependencies: [family],
      );
      final provider = Provider((ref) => ref.watch(dep), dependencies: [dep]);
      final root = ProviderContainer.test();
      final mid = ProviderContainer.test(parent: root, overrides: [family]);
      final container = ProviderContainer.test(parent: mid);

      expect(container.read(provider), 42);
      expect(mid.read(provider), 42);

      expect(container.getAllProviderElements(), isEmpty);
      expect(
        mid.getAllProviderElements(),
        unorderedEquals(<Object>[
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          isA<ProviderElement>().having((e) => e.origin, 'origin', dep),
          isA<ProviderElement>().having((e) => e.origin, 'origin', family(21)),
        ]),
      );
    });

    test('can auto-scope autoDispose providers', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider = Provider.autoDispose(
        (ref) => ref.watch(dep),
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider), 42);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object>[
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          isA<ProviderElement>().having((e) => e.origin, 'origin', dep),
        ]),
      );
      expect(root.getAllProviderElements(), isEmpty);

      await container.pump();

      expect(container.getAllProviderElements(), [
        isA<ProviderElement>().having((e) => e.origin, 'origin', dep),
      ]);
      expect(root.getAllProviderElements(), isEmpty);
    });
  });

  test('does not auto-scope provider overrides', () {
    final a = Provider((ref) => 0, dependencies: const []);
    final another = Provider((ref) => 42, dependencies: const []);
    final b = Provider((ref) => ref.watch(a), dependencies: [a]);
    final c = Provider((ref) => ref.watch(a), dependencies: [a]);

    final root = ProviderContainer.test(
      overrides: [
        b.overrideWithValue(21),
        c.overrideWith((ref) => ref.watch(another) + 10),
      ],
    );
    final container = ProviderContainer.test(
      parent: root,
      overrides: [a.overrideWithValue(42), another.overrideWithValue(84)],
    );

    expect(container.read(a), 42);
    expect(container.read(b), 21);
    expect(container.read(c), 52);
  });

  test('does not auto-scope family overrides', () {
    final a = Provider((ref) => 0, dependencies: const []);
    final another = Provider((ref) => 42, dependencies: const []);
    final b = Provider.family<int, int>(
      (ref, _) => ref.watch(a),
      dependencies: [a, another],
    );

    final root = ProviderContainer.test(
      overrides: [b.overrideWith((ref, value) => ref.watch(another) + value)],
    );
    final container = ProviderContainer.test(
      parent: root,
      overrides: [a.overrideWithValue(42), another.overrideWithValue(84)],
    );

    expect(container.read(a), 42);
    expect(container.read(b(10)), 52);
  });

  test(
    'scoped autoDispose override preserve the override after one disposal',
    () async {
      final provider = Provider.autoDispose((ref) => 0, dependencies: const []);

      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [provider],
      );

      container.read(provider);
      expect(root.getAllProviderElements(), isEmpty);
      expect(container.getAllProviderElements(), isNotEmpty);

      await container.pump();

      expect(root.getAllProviderElements(), isEmpty);
      expect(container.getAllProviderElements(), isEmpty);

      container.read(provider);

      expect(root.getAllProviderElements(), isEmpty);
      expect(container.getAllProviderElements(), isNotEmpty);
    },
  );

  test(
    'scoped autoDispose override  through intermediary unused container preserve the override after one disposal',
    () async {
      final provider = Provider.autoDispose((ref) => 0, dependencies: const []);

      final root = ProviderContainer.test();
      final mid = ProviderContainer.test(parent: root, overrides: [provider]);
      final container = ProviderContainer.test(parent: mid);

      container.read(provider);
      expect(root.getAllProviderElements(), isEmpty);
      expect(mid.getAllProviderElements(), isNotEmpty);
      expect(container.getAllProviderElements(), isEmpty);

      await container.pump();

      expect(root.getAllProviderElements(), isEmpty);
      expect(mid.getAllProviderElements(), isEmpty);
      expect(container.getAllProviderElements(), isEmpty);

      container.read(provider);

      expect(root.getAllProviderElements(), isEmpty);
      expect(mid.getAllProviderElements(), isNotEmpty);
      expect(container.getAllProviderElements(), isEmpty);
    },
  );

  test(
    'scoped autoDispose override preserve family override after one disposal',
    () async {
      final provider = Provider.autoDispose.family<int, int>(
        (ref, _) => 0,
        dependencies: const [],
      );

      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [provider],
      );

      container.read(provider(0));
      expect(root.getAllProviderElements(), isEmpty);
      expect(container.getAllProviderElements(), isNotEmpty);

      await container.pump();

      expect(root.getAllProviderElements(), isEmpty);
      expect(container.getAllProviderElements(), isEmpty);

      container.read(provider(0));

      expect(root.getAllProviderElements(), isEmpty);
      expect(container.getAllProviderElements(), isNotEmpty);
    },
  );

  test(
    'scoped autoDispose override through intermediary unused container preserve family  override after one disposal',
    () async {
      final provider = Provider.autoDispose.family<int, int>(
        (ref, _) => 0,
        dependencies: const [],
      );

      final root = ProviderContainer.test();
      final mid = ProviderContainer.test(parent: root, overrides: [provider]);
      final container = ProviderContainer.test(parent: mid);

      container.read(provider(0));
      expect(root.getAllProviderElements(), isEmpty);
      expect(mid.getAllProviderElements(), isNotEmpty);
      expect(container.getAllProviderElements(), isEmpty);

      await container.pump();

      expect(root.getAllProviderElements(), isEmpty);
      expect(mid.getAllProviderElements(), isEmpty);
      expect(container.getAllProviderElements(), isEmpty);

      container.read(provider(0));

      expect(root.getAllProviderElements(), isEmpty);
      expect(mid.getAllProviderElements(), isNotEmpty);
      expect(container.getAllProviderElements(), isEmpty);
    },
  );
}
