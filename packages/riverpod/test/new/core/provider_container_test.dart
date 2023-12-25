import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

import '../utils.dart';

const _sentinel = Object();

TypeMatcher<ProviderPointer> isPointer({
  Object? override = _sentinel,
  Object? element = _sentinel,
  Object? targetContainer = _sentinel,
}) {
  var matcher = isA<ProviderPointer>();

  if (override != _sentinel) {
    matcher = matcher.having((p) => p.providerOverride, 'override', override);
  }

  if (element != _sentinel) {
    matcher = matcher.having((p) => p.element, 'element', element);
  }

  if (targetContainer != _sentinel) {
    matcher = matcher.having(
      (p) => p.targetContainer,
      'targetContainer',
      targetContainer,
    );
  }

  return matcher;
}

TypeMatcher<TransitiveFamilyOverride> isTransitiveFamilyOverride(
  Object? family,
) {
  return isA<TransitiveFamilyOverride>().having((f) => f.from, 'from', family);
}

TypeMatcher<TransitiveProviderOverride> isTransitiveProviderOverride(
  Object? provider,
) {
  return isA<TransitiveProviderOverride>()
      .having((f) => f.origin, 'origin', provider);
}

TypeMatcher<ProviderDirectory> isProviderDirectory({
  Object? override = _sentinel,
  Object? pointers = _sentinel,
  Object? targetContainer = _sentinel,
}) {
  var matcher = isA<ProviderDirectory>();

  if (override != _sentinel) {
    matcher = matcher.having((p) => p.familyOverride, 'override', override);
  }

  if (pointers != _sentinel) {
    matcher = matcher.having((p) => p.pointers, 'pointers', pointers);
  }

  if (targetContainer != _sentinel) {
    matcher = matcher.having(
      (p) => p.targetContainer,
      'targetContainer',
      targetContainer,
    );
  }

  return matcher;
}

void main() {
  tearDown(() {
    // Verifies that there is no container leak.
    expect(DebugRiverpodDevtoolBiding.containers, isEmpty);
  });

  group('ProviderPointerManager', () {
    group('isLocallyMounted', () {
      final a = Provider(
        (_) => 0,
        dependencies: const [],
      );
      final b = Provider.family<int, int>(
        (_, __) => 0,
        dependencies: const [],
      );
      final c = Provider.family<int, int>(
        (_, __) => 0,
        dependencies: const [],
      )(42);

      test('returns true if in the root container', () {
        final container = ProviderContainer.test();

        expect(container.pointerManager.isLocallyMounted(a), true);
        expect(container.pointerManager.isLocallyMounted(b), true);
        expect(container.pointerManager.isLocallyMounted(c), true);
      });

      test('returns false if the provider is not mounted', () {
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            // An unrelated override, added to avoid the container optimizing
            // pointers away.
            Provider((ref) => null, dependencies: const []),
          ],
        );

        expect(container.pointerManager.isLocallyMounted(a), false);
        expect(container.pointerManager.isLocallyMounted(b), false);
        expect(container.pointerManager.isLocallyMounted(c), false);
      });

      test('returns false if mounted but in a different container', () {
        final root = ProviderContainer.test();

        root.read(a);
        root.read(b(21));
        root.read(c);

        // Creating after reads, to inherit elements from root
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            // An unrelated override, added to avoid the container optimizing
            // pointers away.
            Provider((ref) => null, dependencies: const []),
          ],
        );

        expect(container.pointerManager.isLocallyMounted(a), false);
        expect(container.pointerManager.isLocallyMounted(b), false);
        expect(container.pointerManager.isLocallyMounted(c), false);
      });

      test('returns true if mounted in the same container', () {
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            a.overrideWithValue(42),
            b.overrideWith((ref, args) => 0),
            c.overrideWithValue(42),
          ],
        );

        expect(container.pointerManager.isLocallyMounted(a), true);
        expect(container.pointerManager.isLocallyMounted(b), true);
        expect(container.pointerManager.isLocallyMounted(b(21)), true);
        expect(container.pointerManager.isLocallyMounted(c), true);
      });
    });

    group('hasLocallyOverriddenDependency', () {
      final dependency = Provider(
        (_) => 0,
        dependencies: const [],
      );
      final transitiveDependency = Provider(
        (_) => 0,
        dependencies: const [],
      );

      final a = Provider(
        (_) => 0,
        dependencies: [dependency, transitiveDependency],
      );

      test('always returns false if has no dependency', () {
        final provider = Provider((_) => 0);
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            // Unrelated override, to avoid the container optimizing the pointer away
            Provider((ref) => null, dependencies: const []),
          ],
        );

        expect(
          container.pointerManager.hasLocallyOverriddenDependency(provider),
          false,
        );
      });

      test('returns false if the root container', () {
        final root = ProviderContainer.test(
          overrides: [
            dependency.overrideWithValue(42),
          ],
        );

        expect(
          root.pointerManager.hasLocallyOverriddenDependency(a),
          false,
        );
      });

      test(
          'returns true in a scoped container with overridden direct dependency',
          () {
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            dependency.overrideWithValue(42),
          ],
        );

        expect(
          container.pointerManager.hasLocallyOverriddenDependency(a),
          true,
        );
      });

      test(
          'returns true in a scoped container with overridden transitive dependency',
          () {
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            transitiveDependency.overrideWithValue(42),
          ],
        );

        expect(
          container.pointerManager.hasLocallyOverriddenDependency(a),
          true,
        );
      });
    });

    group('upsertDirectory', () {
      test('handles auto-scoping', () {
        final dep = Provider(
          (_) => 0,
          dependencies: const [],
        );
        final family = Provider.family<int, int>(
          (ref, id) => 0,
          dependencies: [dep],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [dep.overrideWithValue(42)],
        );

        final directory = container.pointerManager.upsertDirectory(family(42));

        expect(
          directory,
          isProviderDirectory(
            targetContainer: container,
            override: isTransitiveFamilyOverride(family),
            pointers: isEmpty,
          ),
        );

        expect(
          container.pointerManager.familyPointers,
          {family: directory},
        );

        // Check that the root was unaffected
        expect(
          root.pointerManager.familyPointers,
          isEmpty,
        );
        expect(
          root.pointerManager.orphanPointers.pointers,
          isEmpty,
        );
      });

      test('on orphans, return orphanPointers', () {
        final provider = Provider((_) => 0);
        final container = ProviderContainer.test();

        final directory = container.pointerManager.upsertDirectory(provider);

        expect(container.pointerManager.orphanPointers, directory);

        expect(
          directory,
          isProviderDirectory(
            targetContainer: container,
            override: null,
            pointers: isEmpty,
          ),
        );
      });

      test('on families, adds a new directory if not already present', () {
        final provider = Provider.family<int, int>((ref, _) => 0);
        final container = ProviderContainer.test();

        final directory = container.pointerManager.upsertDirectory(
          provider(42),
        );

        expect(
          container.pointerManager.familyPointers,
          {provider: directory},
        );

        expect(
          directory,
          isProviderDirectory(
            targetContainer: container,
            override: null,
            pointers: isEmpty,
          ),
        );
      });

      test('returns existing directory if called twice', () {
        final provider = Provider.family<int, int>((ref, _) => 0);
        final container = ProviderContainer.test();

        final directory =
            container.pointerManager.upsertDirectory(provider(42));
        final directory2 =
            container.pointerManager.upsertDirectory(provider(42));

        expect(directory2, same(directory));
      });

      test('returns override directory if present', () {
        final provider = Provider.family<int, int>((ref, _) => 0);

        final container = ProviderContainer.test(
          overrides: [provider.overrideWith((ref, arg) => 0)],
        );

        final overrideDir = container.pointerManager.familyPointers[provider]!;

        final directory = container.pointerManager.upsertDirectory(
          provider(42),
        );

        expect(directory, same(overrideDir));

        expect(
          directory,
          isProviderDirectory(
            targetContainer: container,
            override: isNotNull,
            pointers: isEmpty,
          ),
        );
      });
    });

    group('upsertPointer', () {
      test('on scoped providers, has no impact on the ancestor container', () {
        final provider = Provider((_) => 0, dependencies: const []);
        final family = Provider.family<int, int>(
          (ref, id) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider, family],
        );

        container.pointerManager.upsertPointer(provider);
        container.pointerManager.upsertPointer(family(42));

        expect(root.pointerManager.familyPointers, isEmpty);
        expect(root.pointerManager.orphanPointers.pointers, isEmpty);

        expect(
          container.pointerManager.orphanPointers.pointers,
          {
            provider: isPointer(
              targetContainer: container,
              override: provider,
            ),
          },
        );
        expect(
          container.pointerManager.familyPointers,
          {
            family: isProviderDirectory(
              targetContainer: container,
              override: family,
              pointers: {family(42): isPointer(targetContainer: container)},
            ),
          },
        );
      });

      test('handles auto-scoping', () {
        final dep = Provider(
          (_) => 0,
          dependencies: const [],
        );
        final family = Provider.family<int, int>(
          (ref, id) => 0,
          dependencies: [dep],
        );
        final provider = Provider((_) => 0, dependencies: [dep]);
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [dep.overrideWithValue(42)],
        );

        final pointer = container.pointerManager.upsertPointer(family(42));
        final pointer2 = container.pointerManager.upsertPointer(provider);

        expect(
          pointer,
          isPointer(
            targetContainer: container,
            override: isTransitiveProviderOverride(family(42)),
          ),
        );
        expect(
          pointer2,
          isPointer(
            targetContainer: container,
            override: isTransitiveProviderOverride(provider),
          ),
        );

        expect(
          container.pointerManager.familyPointers,
          {
            family: isProviderDirectory(
              targetContainer: container,
              override: isTransitiveFamilyOverride(family),
              pointers: {
                family(42): pointer,
              },
            ),
          },
        );
        expect(
          container.pointerManager.orphanPointers,
          isProviderDirectory(
            targetContainer: root,
            override: null,
            pointers: {
              provider: pointer2,
              dep: isNotNull,
            },
          ),
        );

        // Check that the root was unaffected
        expect(
          root.pointerManager.familyPointers,
          isEmpty,
        );
        expect(
          root.pointerManager.orphanPointers.pointers,
          isEmpty,
        );
      });

      test(
          'have ancestors and children share their pointers when not overridden',
          () {
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            // An unrelated override, added to avoid the container optimizing
            Provider((_) => 0, dependencies: const []),
          ],
        );
        final provider = Provider((ref) => 0);
        final family = Provider.family<int, int>((ref, id) => 0);

        root.read(provider);
        root.read(family(42));
        container.read(provider);
        container.read(family(42));

        expect(
          container.pointerManager.orphanPointers.pointers[provider],
          same(root.pointerManager.orphanPointers.pointers[provider]),
        );

        expect(
          container.pointerManager.familyPointers[family]!.pointers,
          {
            family(42): same(
              root.pointerManager.familyPointers[family]!.pointers[family(42)],
            ),
          },
        );
      });

      test('on orphans, insert in orphanPointers', () {
        final provider = Provider((_) => 0);
        final container = ProviderContainer.test();

        final pointer = container.pointerManager.upsertPointer(provider);

        expect(
          container.pointerManager.orphanPointers.pointers,
          {provider: pointer},
        );

        expect(
          pointer,
          isPointer(
            targetContainer: container,
            override: null,
            element: isNotNull,
          ),
        );
      });

      test('on families, adds a new pointer if not already present', () {
        final provider = Provider.family<int, int>((ref, _) => 0);
        final container = ProviderContainer.test();

        final pointer = container.pointerManager.upsertPointer(
          provider(42),
        );

        expect(
          container.pointerManager.familyPointers[provider]!.pointers,
          {provider(42): pointer},
        );

        expect(
          pointer,
          isPointer(
            targetContainer: container,
            override: null,
            element: isNotNull,
          ),
        );
      });
    });

    group('remove', () {
      test('if called on a provider that is not mounted, is no-op', () {});

      test('removes non-family providers from orphan list', () {
        final provider = Provider((_) => 0);
        final container = ProviderContainer.test();

        final pointer = container.pointerManager.upsertPointer(provider);

        expect(
          container.pointerManager.orphanPointers.pointers,
          {provider: isPointer()},
        );

        final removed = container.pointerManager.remove(provider);

        expect(removed, pointer);
        expect(
          container.pointerManager.orphanPointers.pointers,
          isEmpty,
        );
      });

      test('removes family providers from family list', () {
        final family = Provider.family<int, int>((ref, _) => 0);
        final container = ProviderContainer.test();

        final pointer = container.pointerManager.upsertPointer(family(42));
        // Mounting two values to avoid testing for empty families
        container.pointerManager.upsertPointer(family(21));

        expect(
          container.pointerManager.familyPointers[family]!.pointers,
          {family(42): isPointer(), family(21): isPointer()},
        );

        final removed = container.pointerManager.remove(family(42));

        expect(removed, pointer);
        expect(
          container.pointerManager.familyPointers[family]!.pointers,
          {family(21): isPointer()},
        );
      });

      test('if a family becomes empty after a remove, remove the directory',
          () {
        final family = Provider.family<int, int>((ref, _) => 0);
        final container = ProviderContainer.test();

        final pointer = container.pointerManager.upsertPointer(family(42));

        expect(
          container.pointerManager.familyPointers,
          {family: isProviderDirectory()},
        );

        final removed = container.pointerManager.remove(family(42));

        expect(removed, pointer);
        expect(
          container.pointerManager.familyPointers,
          isEmpty,
        );
      });

      test('if a family is not empty after a remove, keep the directory', () {
        final family = Provider.family<int, int>((ref, _) => 0);
        final container = ProviderContainer.test();

        final pointer = container.pointerManager.upsertPointer(family(42));
        container.pointerManager.upsertPointer(family(21));

        expect(
          container.pointerManager.familyPointers,
          {
            family: isProviderDirectory(
              pointers: {
                family(42): isPointer(),
                family(21): isPointer(),
              },
            ),
          },
        );

        final removed = container.pointerManager.remove(family(42));

        expect(removed, pointer);
        expect(
          container.pointerManager.familyPointers,
          {
            family: isProviderDirectory(pointers: {family(21): isPointer()}),
          },
        );
      });

      test('if an orphan provider is from an override, keep the pointer', () {
        final provider = Provider((_) => 0);
        final override = provider.overrideWithValue(42);
        final container = ProviderContainer.test(
          overrides: [override],
        );

        final pointer = container.pointerManager.upsertPointer(provider);

        expect(
          container.pointerManager.orphanPointers.pointers,
          {provider: isPointer(override: override)},
        );

        final removed = container.pointerManager.remove(provider);

        expect(removed, pointer);
        expect(
          container.pointerManager.orphanPointers.pointers,
          {provider: isPointer(override: override)},
        );
      });

      test('if a family provider is from a manual override, keep the pointer',
          () {
        final family = Provider.family<int, int>((ref, _) => 0);
        final override = family(21).overrideWith((ref) => 42);
        final container = ProviderContainer.test(
          overrides: [override],
        );

        final pointer = container.pointerManager.upsertPointer(family(21));

        expect(
          container.pointerManager.familyPointers[family]!.pointers,
          {family(21): isPointer(override: override)},
        );

        final removed = container.pointerManager.remove(family(21));

        expect(removed, pointer);
        expect(
          container.pointerManager.familyPointers,
          {
            family: isProviderDirectory(
              pointers: {family(21): isPointer(override: override)},
            ),
          },
        );
      });

      test(
          'if a family becomes empty after a remove but is from a manual override, '
          'keep the directory', () {
        final family = Provider.family<int, int>((ref, _) => 0);
        final override = family.overrideWith((ref, _) => 42);
        final container = ProviderContainer.test(
          overrides: [override],
        );

        final pointer = container.pointerManager.upsertPointer(family(21));

        expect(
          container.pointerManager.familyPointers,
          {
            family: isProviderDirectory(
              override: override,
              pointers: {family(21): isPointer()},
            ),
          },
        );

        final removed = container.pointerManager.remove(family(21));

        expect(removed, pointer);
        expect(
          container.pointerManager.familyPointers,
          {
            family: isProviderDirectory(
              override: override,
              pointers: isEmpty,
            ),
          },
        );
      });

      test(
          'if an orphan is from a transitive override, '
          'removes the pointer', () {
        final dep = Provider(
          (_) => 0,
          dependencies: const [],
        );
        final provider = Provider<int>((ref) => 0, dependencies: [dep]);
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [dep],
        );

        final pointer = container.pointerManager.upsertPointer(provider);

        expect(
          container.pointerManager.orphanPointers.pointers,
          {
            dep: isPointer(override: dep),
            provider: isPointer(
              override: isTransitiveProviderOverride(provider),
            ),
          },
        );

        final removed = container.pointerManager.remove(provider);

        expect(removed, pointer);
        expect(
          container.pointerManager.orphanPointers.pointers,
          {dep: isPointer(override: dep)},
        );
      });

      test(
          'if a family is from a transitive override and becomes empty, '
          'remove the directory', () {
        final dep = Provider(
          (_) => 0,
          dependencies: const [],
        );
        final family = Provider.family<int, int>(
          (ref, _) => 0,
          dependencies: [dep],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [dep],
        );

        final pointer = container.pointerManager.upsertPointer(family(42));

        expect(
          container.pointerManager.familyPointers,
          {
            family: isProviderDirectory(
              override: isTransitiveFamilyOverride(family),
              pointers: {family(42): isPointer()},
            ),
          },
        );

        final removed = container.pointerManager.remove(family(42));

        expect(removed, pointer);
        expect(
          container.pointerManager.familyPointers,
          isEmpty,
        );
      });
    });
  });

  group('ProviderContainer', () {
    group('constructor', () {
      test('throws if trying to scope a provider/family with no dependencies',
          () {
        // TODO changelog

        final provider = Provider((_) => 0);
        final family = Provider.family<int, int>((ref, _) => 0);

        final root = ProviderContainer.test();

        expect(
          () => ProviderContainer.test(
            parent: root,
            overrides: [provider],
          ),
          throwsA(isA<AssertionError>()),
        );

        expect(
          () => ProviderContainer.test(
            parent: root,
            overrides: [family],
          ),
          throwsA(isA<AssertionError>()),
        );

        expect(
          () => ProviderContainer.test(
            parent: root,
            overrides: [family(21)],
          ),
          throwsA(isA<AssertionError>()),
        );
      });

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
            () => ProviderContainer.test(
              overrides: [
                provider.overrideWithValue(42),
                provider.overrideWithValue(21),
              ],
            ),
            throwsA(isA<AssertionError>()),
          );
        });

        test(
            'throws if the same family is overridden twice in the same container',
            () {
          // TODO changelog
          final provider = Provider.family<int, int>((ref, id) => 0);

          expect(
            () => ProviderContainer.test(
              overrides: [
                provider.overrideWith((ref, arg) => arg),
                provider.overrideWith((ref, arg) => arg),
              ],
            ),
            throwsA(isA<AssertionError>()),
          );
        });

        test(
            'supports overriding an already overridden provider/family in a different container',
            () {
          final provider = Provider(
            (ref) => 0,
            dependencies: const [],
          );
          final family = Provider.family<int, int>(
            (ref, id) => 0,
            dependencies: const [],
          );
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

        test(
            'supports overriding a provider from a family, and then the family',
            () {
          final family = Provider.family<int, int>((ref, id) => 0);
          final root = ProviderContainer(
            overrides: [
              family(42).overrideWithValue(42),
              family.overrideWith((ref, arg) => arg),
            ],
          );
          addTearDown(root.dispose);
        });
      });
    });

    // TODO test that reading a provider with deps does not mount those deps if unused by the provider

    group('pointers', () {
      test('has "container" pointing to "this"', () {
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            // An unrelated override, added to avoid the container optimizing
            Provider((_) => 0, dependencies: const []),
          ],
        );

        expect(root.pointerManager.container, root);
        expect(container.pointerManager.container, container);
      });

      group('at the root, ', () {
        test('orphansPointers.container points to the root', () {
          final root = ProviderContainer.test();

          expect(root.pointerManager.orphanPointers.targetContainer, root);
        });
      });

      group('on scoped containers', () {
        test('inherits overrides from its parents', () {
          final a = Provider((_) => 0, name: 'a');
          final aOverride = a.overrideWithValue(1);
          final b = Provider(
            (_) => 0,
            name: 'b',
            dependencies: const [],
          );
          final bOverride = b.overrideWithValue(2);
          final c = Provider(
            (_) => 0,
            name: 'c',
            dependencies: const [],
          );
          final cOverride = c.overrideWithValue(3);
          final aFamily =
              Provider.family<int, int>((_, __) => 0, name: 'aFamily');
          final aFamilyOverride = aFamily.overrideWith((_, __) => 1);
          final aValueOverride = aFamily(1).overrideWith((_) => 2);
          final bFamily = Provider.family<int, int>(
            (_, __) => 0,
            name: 'bFamily',
            dependencies: const [],
          );
          final bFamilyOverride = bFamily.overrideWith((_, __) => 2);
          final bValueOverride = bFamily(2).overrideWith((_) => 3);
          final cFamily = Provider.family<int, int>(
            (_, __) => 0,
            name: 'cFamily',
            dependencies: const [],
          );
          final cFamilyOverride = cFamily.overrideWith((_, __) => 3);
          final cValueOverride = cFamily(3).overrideWith((_) => 4);

          final root = ProviderContainer.test(
            overrides: [aOverride, aFamilyOverride, aValueOverride],
          );
          final mid = ProviderContainer.test(
            parent: root,
            overrides: [bOverride, bFamilyOverride, bValueOverride],
          );
          final container = ProviderContainer.test(
            parent: mid,
            overrides: [cOverride, cFamilyOverride, cValueOverride],
          );

          expect(
            container.pointerManager.familyPointers,
            {
              aFamily: isProviderDirectory(
                override: aFamilyOverride,
                targetContainer: root,
                pointers: {
                  aFamily(1): isPointer(
                    override: aValueOverride,
                    targetContainer: root,
                    element: null,
                  ),
                },
              ),
              bFamily: isProviderDirectory(
                override: bFamilyOverride,
                targetContainer: mid,
                pointers: {
                  bFamily(2): isPointer(
                    override: bValueOverride,
                    targetContainer: mid,
                    element: null,
                  ),
                },
              ),
              cFamily: isProviderDirectory(
                override: cFamilyOverride,
                targetContainer: container,
                pointers: {
                  cFamily(3): isPointer(
                    override: cValueOverride,
                    targetContainer: container,
                    element: null,
                  ),
                },
              ),
            },
          );

          expect(
            container.pointerManager.orphanPointers,
            isProviderDirectory(
              targetContainer: root,
              override: null,
              pointers: {
                a: isPointer(
                  override: aOverride,
                  targetContainer: root,
                  element: null,
                ),
                b: isPointer(
                  override: bOverride,
                  targetContainer: mid,
                  element: null,
                ),
                c: isPointer(
                  override: cOverride,
                  targetContainer: container,
                  element: null,
                ),
              },
            ),
          );
        });

        test('with no overrides, uses an identical content as its parent', () {
          final root = ProviderContainer.test();
          final mid = ProviderContainer.test(
            parent: root,
            overrides: [Provider((_) => 0, dependencies: const [])],
          );
          final container = ProviderContainer.test(parent: mid);
          final container2 = ProviderContainer.test(parent: mid, overrides: []);

          expect(
            container.pointerManager.orphanPointers,
            same(mid.pointerManager.orphanPointers),
          );
          expect(
            container.pointerManager.familyPointers,
            same(mid.pointerManager.familyPointers),
          );

          expect(
            container2.pointerManager.familyPointers,
            same(mid.pointerManager.familyPointers),
          );
          expect(
            container2.pointerManager.orphanPointers,
            same(mid.pointerManager.orphanPointers),
          );
        });

        // TODO throw if trying to cope a provider/family with no dependencies

        test('orphanPointers.containers are always equal to root', () {
          final root = ProviderContainer.test();
          final provider = Provider(
            (_) => 0,
            dependencies: const [],
          );
          final container = ProviderContainer.test(
            parent: root,
            overrides: [provider],
          );

          expect(root.pointerManager.orphanPointers.targetContainer, root);
          expect(
            container.pointerManager.orphanPointers.targetContainer,
            root,
          );

          expect(
            container.pointerManager.orphanPointers.pointers,
            {
              provider: isPointer(
                targetContainer: container,
                override: provider,
                element: null,
              ),
            },
          );
        });
      });

      test('adds non-family provider overrides to orphanPointers', () {
        final provider = Provider(
          (_) => 0,
          dependencies: const [],
        );
        final override = provider.overrideWithValue(42);
        final root = ProviderContainer.test(
          overrides: [override],
        );
        final root2 = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root2,
          overrides: [override],
        );

        expect(
          root.pointerManager.orphanPointers,
          isProviderDirectory(
            targetContainer: root,
            override: null,
            pointers: {
              provider: isPointer(
                targetContainer: root,
                override: override,
                element: null,
              ),
            },
          ),
        );

        expect(
          root2.pointerManager.orphanPointers.pointers,
          isEmpty,
        );
        expect(
          container.pointerManager.orphanPointers,
          isProviderDirectory(
            targetContainer: root2,
            override: null,
            pointers: {
              provider: isPointer(
                targetContainer: container,
                override: override,
                element: null,
              ),
            },
          ),
        );
      });

      test('adds family overrides to familyPointers', () {
        final provider = Provider.family<int, int>(
          (ref, _) => 0,
          dependencies: const [],
        );
        final override = provider.overrideWith((ref, arg) => 0);
        final root = ProviderContainer.test(
          overrides: [override],
        );
        final root2 = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root2,
          overrides: [override],
        );

        expect(
          root.pointerManager.familyPointers,
          {
            provider: isProviderDirectory(
              override: override,
              targetContainer: root,
              pointers: isEmpty,
            ),
          },
        );

        expect(
          root2.pointerManager.familyPointers,
          isEmpty,
        );
        expect(
          container.pointerManager.familyPointers,
          {
            provider: isProviderDirectory(
              override: override,
              targetContainer: container,
              pointers: isEmpty,
            ),
          },
        );
      });

      test('adds family provider overrides to familyPointers.pointers', () {
        final provider = Provider.family<int, int>(
          (ref, _) => 0,
          dependencies: const [],
        );
        final override = provider(42).overrideWith((ref) => 0);
        final root = ProviderContainer.test(
          overrides: [override],
        );
        final root2 = ProviderContainer.test();

        final container = ProviderContainer.test(
          parent: root2,
          overrides: [override],
        );

        expect(
          root.pointerManager.familyPointers,
          {
            provider: isProviderDirectory(
              override: null,
              targetContainer: root,
              pointers: {
                provider(42): isPointer(
                  targetContainer: root,
                  override: override,
                  element: null,
                ),
              },
            ),
          },
        );

        expect(
          container.pointerManager.familyPointers,
          isNot(root2.pointerManager.familyPointers),
        );

        expect(
          root2.pointerManager.familyPointers,
          isEmpty,
        );

        expect(
          container.pointerManager.familyPointers,
          {
            provider: isProviderDirectory(
              override: null,
              targetContainer: root2,
              pointers: {
                provider(42): isPointer(
                  targetContainer: container,
                  override: override,
                  element: null,
                ),
              },
            ),
          },
        );
      });

      test(
          'can override a family and a provider from that family in the same container',
          () {
        final family = Provider.family<String, int>((ref, a) => 'Hello $a');
        final familyOverride = family.overrideWith((ref, a) => 'Hi $a');
        final beforeOverride = family(42).overrideWithValue('Bonjour 42');
        final afterOverride = family(21).overrideWithValue('Ola 42');

        final container = ProviderContainer.test(
          overrides: [
            beforeOverride,
            familyOverride,
            afterOverride,
          ],
        );

        expect(container.pointerManager.familyPointers, {
          family: isProviderDirectory(
            override: familyOverride,
            targetContainer: container,
            pointers: {
              family(42): isPointer(
                override: beforeOverride,
                targetContainer: container,
                element: null,
              ),
              family(21): isPointer(
                override: afterOverride,
                targetContainer: container,
                element: null,
              ),
            },
          ),
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
        final provider = Provider(
          (ref) => 0,
          dependencies: const [],
        );
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

      test('does not compute provider states if not loaded yet', () {
        var callCount = 0;
        final provider = Provider((_) => callCount++);

        final container = ProviderContainer.test(
          overrides: [provider],
        );

        container.dispose();

        expect(callCount, 0);
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
        final provider = Provider(
          (ref) {
            ref.onDispose(rootOnDispose.call);
            return 0;
          },
          dependencies: const [],
        );

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
        final provider2 = Provider(
          (ref) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider2],
        );

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
        final b = Provider(
          (ref) => ref.watch(dep),
          dependencies: const [],
        );
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

    group('updateOverrides', () {
      test('is not allowed to remove overrides ', () {
        final provider = Provider((_) => 0);

        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(42)],
        );

        expect(container.read(provider), 42);

        expect(
          () => container.updateOverrides([]),
          throwsA(isAssertionError),
        );
      });

      test('changing the override type at a given index throws', () {
        final provider = Provider((ref) => 0);
        final family = Provider.family<int, int>((ref, value) => 0);
        final container = ProviderContainer.test(overrides: [family]);

        expect(
          () => container.updateOverrides([provider]),
          throwsA(isA<AssertionError>()),
        );
      });

      test('does not compute provider states if not loaded yet', () {
        var callCount = 0;
        final provider = Provider((_) => callCount++);

        final container = ProviderContainer.test(
          overrides: [provider],
        );

        container.updateOverrides([provider]);

        expect(callCount, 0);

        container.dispose();

        expect(callCount, 0);
      });

      test('does not notify listeners if updated with the same value', () {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(42)],
        );
        final listener = Listener<int>();

        addTearDown(container.dispose);

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, 42));

        container.updateOverrides([
          provider.overrideWithValue(42),
        ]);

        expect(container.read(provider), 42);
        verifyNoMoreInteractions(listener);
      });

      test('notify listeners when value changes', () {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(42)],
        );
        final listener = Listener<int>();

        addTearDown(container.dispose);

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, 42));

        container.updateOverrides([
          provider.overrideWithValue(21),
        ]);

        verifyOnly(listener, listener(42, 21));
      });

      test('updating parent override when there is a child override is no-op',
          () async {
        final provider = Provider(
          (ref) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test(
          overrides: [provider.overrideWithValue(21)],
        );
        final container = ProviderContainer.test(
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

      test('can update multiple ScopeProviders at once', () {
        final provider = Provider<int>((ref) => -1);
        final provider2 = Provider<int>((ref) => -1);

        final container = ProviderContainer.test(
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

      test(
          'if listened from a child container, '
          'updating the parent override correctly notifies listeners', () {
        final provider = Provider(
          (ref) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test(
          overrides: [provider.overrideWithValue(1)],
        );
        final mid = ProviderContainer.test(
          parent: root,
          overrides: [
            provider.overrideWithValue(42),
          ],
        );
        final container = ProviderContainer.test(parent: mid);
        final listener = Listener<int>();

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, 42));

        mid.updateOverrides([
          provider.overrideWithValue(21),
        ]);

        verifyOnly(listener, listener(42, 21));
      });

      test('throws if used on a disposed container', () {
        final container = ProviderContainer.test();
        container.dispose();

        expect(
          () => container.updateOverrides([]),
          throwsStateError,
        );
      });
    });

    group('listen', () {
      test('can downcast the listener value', () {
        final container = ProviderContainer.test();
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
          final container = ProviderContainer.test();
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
          final container = ProviderContainer.test();
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
    });
  });
}

class _EmptyObserver extends ProviderObserver {}
