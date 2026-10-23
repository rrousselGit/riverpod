// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod/src/internals.dart' show $ProviderElement, $ResultData;
import 'package:test/test.dart';
import 'package:trotter/trotter.dart';

import '../utils.dart';

const _sentinel = Object();

TypeMatcher<$ProviderPointer> isPointer({
  Object? override = _sentinel,
  Object? element = _sentinel,
  Object? targetContainer = _sentinel,
}) {
  var matcher = isA<$ProviderPointer>();

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

TypeMatcher<TransitiveProviderOverride> isTransitiveProviderOverride([
  Object? provider = _sentinel,
]) {
  var matcher = isA<TransitiveProviderOverride>();

  if (provider != _sentinel) {
    matcher = matcher.having((f) => f.origin, 'origin', provider);
  }

  return matcher;
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
  group('ProviderPointerManager', () {
    group('findDeepestTransitiveDependencyProviderContainer', () {
      final transitiveDependency = Provider((_) => 0, dependencies: const []);
      final dependency = Provider(
        (_) => 0,
        dependencies: [transitiveDependency],
      );

      final a = Provider((_) => 0, dependencies: [dependency]);

      test('always returns null if has no dependency', () {
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
          container.pointerManager
              .findDeepestTransitiveDependencyProviderContainer(provider),
          null,
        );
      });

      test(
        'returns null if the dependency is overridden in the root container',
        () {
          final root = ProviderContainer.test(
            overrides: [dependency.overrideWithValue(42)],
          );

          expect(
            root.pointerManager
                .findDeepestTransitiveDependencyProviderContainer(a),
            null,
          );
        },
      );

      test(
        "for direct dependencies, returns the dependency's container if overridden",
        () {
          final root = ProviderContainer.test();
          final container = ProviderContainer.test(
            parent: root,
            overrides: [dependency.overrideWithValue(42)],
          );
          final leaf = ProviderContainer.test(
            parent: container,
            overrides: [
              // Unrelated override, to avoid the container optimizing the pointer away
              Provider((ref) => null, dependencies: const []),
            ],
          );

          expect(
            leaf.pointerManager
                .findDeepestTransitiveDependencyProviderContainer(a),
            container,
          );
        },
      );

      test(
        "for transitive dependencies, returns the dependency's container if overridden",
        () {
          final root = ProviderContainer.test();
          final container = ProviderContainer.test(
            parent: root,
            overrides: [transitiveDependency.overrideWithValue(42)],
          );
          final leaf = ProviderContainer.test(
            parent: container,
            overrides: [
              // Unrelated override, to avoid the container optimizing the pointer away
              Provider((ref) => null, dependencies: const []),
            ],
          );

          expect(
            leaf.pointerManager
                .findDeepestTransitiveDependencyProviderContainer(a),
            container,
          );
        },
      );

      test(
        'if multiple dependencies are overridden, returns the deepest container',
        () {
          final dep2 = Provider((_) => 0, dependencies: const []);
          final root = ProviderContainer.test();
          final container = ProviderContainer.test(
            parent: root,
            overrides: [dependency.overrideWithValue(42)],
          );
          final container2 = ProviderContainer.test(
            parent: container,
            overrides: [dep2.overrideWithValue(42)],
          );
          final leaf = ProviderContainer.test(
            parent: container2,
            overrides: [
              // Unrelated override, to avoid the container optimizing the pointer away
              Provider((ref) => null, dependencies: const []),
            ],
          );

          final b = Provider((_) => 0, dependencies: [dep2]);

          expect(
            leaf.pointerManager
                .findDeepestTransitiveDependencyProviderContainer(a),
            // Does not care about dep2, so points to 'container'
            container,
          );

          expect(
            leaf.pointerManager
                .findDeepestTransitiveDependencyProviderContainer(b),
            container2,
          );
        },
      );
    });

    group('upsertDirectory', () {
      test('handles auto-scoping', () {
        final dep = Provider((_) => 0, dependencies: const []);
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

        expect(container.pointerManager.familyPointers, {family: directory});

        // Check that the root was unaffected
        expect(root.pointerManager.familyPointers, isEmpty);
        expect(root.pointerManager.orphanPointers.pointers, isEmpty);
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

        expect(container.pointerManager.familyPointers, {provider: directory});

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

        final directory = container.pointerManager.upsertDirectory(
          provider(42),
        );
        final directory2 = container.pointerManager.upsertDirectory(
          provider(42),
        );

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

        expect(container.pointerManager.orphanPointers.pointers, {
          provider: isPointer(targetContainer: container, override: provider),
        });
        expect(container.pointerManager.familyPointers, {
          family: isProviderDirectory(
            targetContainer: container,
            override: family,
            pointers: {family(42): isPointer(targetContainer: container)},
          ),
        });
      });

      group('auto-scoping', () {
        test('handles auto-scoping', () {
          final dep = Provider((_) => 0, dependencies: const []);
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
            isPointer(targetContainer: container, override: null),
          );
          expect(
            pointer2,
            isPointer(
              targetContainer: container,
              override: isTransitiveProviderOverride(provider),
            ),
          );

          expect(container.pointerManager.familyPointers, {
            family: isProviderDirectory(
              targetContainer: container,
              override: isTransitiveFamilyOverride(family),
              pointers: {family(42): pointer},
            ),
          });
          expect(
            container.pointerManager.orphanPointers,
            isProviderDirectory(
              targetContainer: root,
              override: null,
              pointers: {provider: pointer2, dep: isNotNull},
            ),
          );

          // Check that the root was unaffected
          expect(root.pointerManager.familyPointers, isEmpty);
          expect(root.pointerManager.orphanPointers.pointers, isEmpty);
        });

        test('skips auto-scoping if the provider is manually overridden', () {
          final dep = Provider((_) => 0, dependencies: const []);
          final family = Provider.family<int, int>(
            (ref, id) => 0,
            dependencies: [dep],
          );
          final familyOverride = family.overrideWith((ref, arg) => 0);
          final provider = Provider((_) => 0, dependencies: [dep]);
          final providerOverride = provider.overrideWithValue(42);

          final root = ProviderContainer.test();
          final mid = ProviderContainer.test(
            parent: root,
            overrides: [familyOverride, providerOverride],
          );
          final container = ProviderContainer.test(
            parent: mid,
            overrides: [dep.overrideWithValue(42)],
          );

          container.pointerManager.upsertPointer(family(42));
          container.pointerManager.upsertPointer(provider);

          expect(container.pointerManager.familyPointers, {
            family: isProviderDirectory(
              targetContainer: mid,
              override: familyOverride,
              pointers: {
                family(42): isPointer(targetContainer: mid, override: null),
              },
            ),
          });
          expect(
            container.pointerManager.orphanPointers,
            isProviderDirectory(
              targetContainer: root,
              override: null,
              pointers: {
                provider: isPointer(
                  targetContainer: mid,
                  override: providerOverride,
                ),
                dep: isNotNull,
              },
            ),
          );
        });

        test('auto-scoping inserts at the correct container', () {
          final dep = Provider((_) => 0, dependencies: const [], name: 'dep');
          final dep2 = Provider((_) => 0, dependencies: const [], name: 'dep2');

          final a = Provider((ref) => 0, dependencies: [dep], name: 'a');
          final b = Provider((ref) => 0, dependencies: [dep2], name: 'b');
          final c = Provider.family(
            (ref, id) => 0,
            dependencies: [dep],
            name: 'c',
          );
          final d = Provider.family(
            (ref, id) => 0,
            dependencies: [dep2],
            name: 'd',
          );

          final root = ProviderContainer.test();
          final mid = ProviderContainer.test(parent: root, overrides: [dep]);
          final mid2 = ProviderContainer.test(parent: mid, overrides: [dep2]);
          final leaf = ProviderContainer.test(
            parent: mid2,
            overrides: [
              // Disable scoping optimization
              Provider((ref) => null, dependencies: const []),
            ],
          );

          leaf.pointerManager.upsertPointer(a);
          leaf.pointerManager.upsertPointer(b);
          leaf.pointerManager.upsertPointer(c(0));
          leaf.pointerManager.upsertPointer(d(0));

          expect(
            leaf.pointerManager.orphanPointers,
            isProviderDirectory(
              targetContainer: root,
              override: null,
              pointers: allOf(
                containsPair(
                  a,
                  isPointer(
                    targetContainer: mid,
                    override: isTransitiveProviderOverride(a),
                  ),
                ),
                containsPair(
                  b,
                  isPointer(
                    targetContainer: mid2,
                    override: isTransitiveProviderOverride(b),
                  ),
                ),
              ),
            ),
          );

          expect(leaf.pointerManager.familyPointers, {
            c: isProviderDirectory(
              targetContainer: mid,
              override: isTransitiveFamilyOverride(c),
              pointers: {c(0): isPointer(targetContainer: mid, override: null)},
            ),
            d: isProviderDirectory(
              targetContainer: mid2,
              override: isTransitiveFamilyOverride(d),
              pointers: {
                d(0): isPointer(targetContainer: mid2, override: null),
              },
            ),
          });
        });

        test('when overriding a family provider', () {
          final a = Provider.family.autoDispose<String, String>(
            (ref, value) => 'root $value',
            dependencies: [],
            name: 'a',
          );

          final b = Provider.family.autoDispose<String, String>(
            (ref, value) => ref.watch(a(value)),
            dependencies: [a],
            name: 'b',
          );

          final root = ProviderContainer.test();
          final container = ProviderContainer.test(
            parent: root,
            overrides: [a('42').overrideWith((ref) => 'override 42')],
          );

          expect(container.read(b('42')), 'override 42');
        });

        test(
          'when overriding both a family and one provider from said family',
          () {
            final a = Provider.family.autoDispose<String, String>(
              (ref, value) => 'root $value',
              dependencies: [],
              name: 'a',
            );
            final b = Provider.family.autoDispose<String, String>(
              (ref, value) => ref.watch(a(value)),
              dependencies: [a],
              name: 'b',
            );

            final root = ProviderContainer.test();
            final mid = ProviderContainer.test(
              parent: root,
              overrides: [a.overrideWith((ref, _) => 'mid')],
            );
            final container = ProviderContainer.test(
              parent: mid,
              overrides: [a('42').overrideWith((ref) => 'override 42')],
            );

            final mid2 = ProviderContainer.test(
              parent: root,
              overrides: [a('42').overrideWith((ref) => 'mid')],
            );
            final container2 = ProviderContainer.test(
              parent: mid2,
              overrides: [a.overrideWith((ref, value) => 'override $value')],
            );

            expect(container.read(b('42')), 'override 42');
            expect(container2.read(b('21')), 'override 21');
          },
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

          expect(container.pointerManager.familyPointers[family]!.pointers, {
            family(42): same(
              root.pointerManager.familyPointers[family]!.pointers[family(42)],
            ),
          });
        },
      );

      test('on orphans, insert in orphanPointers', () {
        final provider = Provider((_) => 0);
        final container = ProviderContainer.test();

        final pointer = container.pointerManager.upsertPointer(provider);

        expect(container.pointerManager.orphanPointers.pointers, {
          provider: pointer,
        });

        expect(pointer, isPointer(targetContainer: container, override: null));
      });

      test('on families, adds a new pointer if not already present', () {
        final provider = Provider.family<int, int>((ref, _) => 0);
        final container = ProviderContainer.test();

        final pointer = container.pointerManager.upsertPointer(provider(42));

        expect(container.pointerManager.familyPointers[provider]!.pointers, {
          provider(42): pointer,
        });

        expect(
          pointer,
          isPointer(
            targetContainer: container,
            override: null,
            element: isNull,
          ),
        );
      });
    });

    group('tryRemove', () {
      test('if called on a provider that is not mounted, is no-op', () {});

      test('removes non-family providers from orphan list', () {
        final provider = Provider((_) => 0);
        final container = ProviderContainer.test();

        final pointer = container.pointerManager.upsertPointer(provider);

        expect(container.pointerManager.orphanPointers.pointers, {
          provider: isPointer(),
        });

        final removed = container.pointerManager.tryRemove(provider);

        expect(removed, pointer);
        expect(container.pointerManager.orphanPointers.pointers, isEmpty);
      });

      test('removes family providers from family list', () {
        final family = Provider.family<int, int>((ref, _) => 0);
        final container = ProviderContainer.test();

        final pointer = container.pointerManager.upsertPointer(family(42));
        // Mounting two values to avoid testing for empty families
        container.pointerManager.upsertPointer(family(21));

        expect(container.pointerManager.familyPointers[family]!.pointers, {
          family(42): isPointer(),
          family(21): isPointer(),
        });

        final removed = container.pointerManager.tryRemove(family(42));

        expect(removed, pointer);
        expect(container.pointerManager.familyPointers[family]!.pointers, {
          family(21): isPointer(),
        });
      });

      test(
        'if a family becomes empty after a remove, remove the directory',
        () {
          final family = Provider.family<int, int>((ref, _) => 0);
          final container = ProviderContainer.test();

          final pointer = container.pointerManager.upsertPointer(family(42));

          expect(container.pointerManager.familyPointers, {
            family: isProviderDirectory(),
          });

          final removed = container.pointerManager.tryRemove(family(42));

          expect(removed, pointer);
          expect(container.pointerManager.familyPointers, isEmpty);
        },
      );

      test('if a family is not empty after a remove, keep the directory', () {
        final family = Provider.family<int, int>((ref, _) => 0);
        final container = ProviderContainer.test();

        final pointer = container.pointerManager.upsertPointer(family(42));
        container.pointerManager.upsertPointer(family(21));

        expect(container.pointerManager.familyPointers, {
          family: isProviderDirectory(
            pointers: {family(42): isPointer(), family(21): isPointer()},
          ),
        });

        final removed = container.pointerManager.tryRemove(family(42));

        expect(removed, pointer);
        expect(container.pointerManager.familyPointers, {
          family: isProviderDirectory(pointers: {family(21): isPointer()}),
        });
      });

      test('if an orphan provider is from an override, keep the pointer', () {
        final provider = Provider((_) => 0);
        final override = provider.overrideWithValue(42);
        final container = ProviderContainer.test(overrides: [override]);

        final pointer = container.pointerManager.upsertPointer(provider);

        expect(container.pointerManager.orphanPointers.pointers, {
          provider: isPointer(override: override),
        });

        final removed = container.pointerManager.tryRemove(provider);

        expect(removed, pointer);
        expect(container.pointerManager.orphanPointers.pointers, {
          provider: isPointer(override: override),
        });
      });

      test(
        'if a family provider is from a manual override, keep the pointer',
        () {
          final family = Provider.family<int, int>((ref, _) => 0);
          final override = family(21).overrideWith((ref) => 42);
          final container = ProviderContainer.test(overrides: [override]);

          final pointer = container.pointerManager.upsertPointer(family(21));

          expect(container.pointerManager.familyPointers[family]!.pointers, {
            family(21): isPointer(override: override),
          });

          final removed = container.pointerManager.tryRemove(family(21));

          expect(removed, pointer);
          expect(container.pointerManager.familyPointers, {
            family: isProviderDirectory(
              pointers: {family(21): isPointer(override: override)},
            ),
          });
        },
      );

      test(
        'if a family becomes empty after a remove but is from a manual override, '
        'keep the directory',
        () {
          final family = Provider.family<int, int>((ref, _) => 0);
          final override = family.overrideWith((ref, _) => 42);
          final container = ProviderContainer.test(overrides: [override]);

          final pointer = container.pointerManager.upsertPointer(family(21));

          expect(container.pointerManager.familyPointers, {
            family: isProviderDirectory(
              override: override,
              pointers: {family(21): isPointer()},
            ),
          });

          final removed = container.pointerManager.tryRemove(family(21));

          expect(removed, pointer);
          expect(container.pointerManager.familyPointers, {
            family: isProviderDirectory(override: override, pointers: isEmpty),
          });
        },
      );

      test('if an orphan is from a transitive override, '
          'removes the pointer', () {
        final dep = Provider((_) => 0, dependencies: const []);
        final provider = Provider<int>((ref) => 0, dependencies: [dep]);
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [dep],
        );

        final pointer = container.pointerManager.upsertPointer(provider);

        expect(container.pointerManager.orphanPointers.pointers, {
          dep: isPointer(override: dep),
          provider: isPointer(override: isTransitiveProviderOverride(provider)),
        });

        final removed = container.pointerManager.tryRemove(provider);

        expect(removed, pointer);
        expect(container.pointerManager.orphanPointers.pointers, {
          dep: isPointer(override: dep),
        });
      });

      test('if a family is from a transitive override and becomes empty, '
          'remove the directory', () {
        final dep = Provider((_) => 0, dependencies: const []);
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

        expect(container.pointerManager.familyPointers, {
          family: isProviderDirectory(
            override: isTransitiveFamilyOverride(family),
            pointers: {family(42): isPointer()},
          ),
        });

        final removed = container.pointerManager.tryRemove(family(42));

        expect(removed, pointer);
        expect(container.pointerManager.familyPointers, isEmpty);
      });
    });

    group('scoping an override overrides all the associated sub-providers', () {
      test('when passing the provider itself', () async {
        final provider = FutureProvider.autoDispose.family<int, int>(
          (ref, _) async => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        container.listen(provider(0), (_, _) {});

        expect(
          container.pointerManager.familyPointers[provider],
          isProviderDirectory(
            pointers: {provider(0): isPointer(element: isNotNull)},
          ),
        );

        expect(root.pointerManager.orphanPointers.pointers, isEmpty);
        expect(root.pointerManager.familyPointers, isEmpty);
      });
    });
  });

  group('ProviderContainer', () {
    group('constructor', () {
      test('throws if "parent" is disposed', () {
        final root = ProviderContainer();
        root.dispose();

        expect(() => ProviderContainer(parent: root), throwsStateError);

        expect(
          root.children,
          isEmpty,
          reason: 'Invalid containers should not be added as children',
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
          },
        );

        test(
          'throws if the same family is overridden twice in the same container',
          () {
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
          },
        );

        test(
          'supports overriding an already overridden provider/family in a different container',
          () {
            final provider = Provider((ref) => 0, dependencies: const []);
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
          },
        );

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
          },
        );

        test('Can override both the family as a provider of that family', () {
          final family = Provider.family<String, int>((ref, a) => 'Hello $a');
          final container = ProviderContainer.test(
            overrides: [
              // Provider overrides always takes over family overrides
              family(84).overrideWithValue('Bonjour 84'),
              family,
              family(21).overrideWithValue('Hi 21'),
            ],
          );

          expect(container.read(family(21)), 'Hi 21');
          expect(container.read(family(84)), 'Bonjour 84');
          expect(container.read(family(42)), 'Hello 42');
        });
      });
    });

    group('defaultOnError', () {
      test('does not report ProviderExceptions', () {
        final errors = <Object>[];
        final container = runZonedGuarded(
          ProviderContainer.test,
          (e, s) => errors.add(e),
        )!;

        final dep = Provider((ref) => throw Exception());
        final provider = Provider((ref) => ref.watch(dep));

        container.listen(provider, (previous, next) {}, fireImmediately: true);
        expect(errors, isEmpty);
      });
    });

    group('retry', () {
      test('inherits retry from parent if arg is null', () {
        Duration? rootRetry(int count, Object error) => Duration.zero;
        Duration? subRetry(int count, Object error) => Duration.zero;

        final root = ProviderContainer.test(retry: rootRetry);
        final container = ProviderContainer.test(parent: root);
        final container2 = ProviderContainer.test(
          parent: root,
          retry: subRetry,
        );

        expect(container.retry, root.retry);
        expect(container2.retry, subRetry);
      });
    });

    test(
      'Reading a provider with deps does not mount those deps if unused by the provider',
      () {
        final dep = Provider((_) => 0);
        final provider = Provider((ref) => 0, dependencies: [dep]);

        final container = ProviderContainer.test();

        container.read(provider);

        expect(
          container.pointerManager.listProviderPointers().map(
            (e) => e.element?.origin,
          ),
          [provider],
        );
      },
    );

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
        test(
          'Inheriting a transitively overridden family which contains family(arg) overrides '
          'preserves the family(arg) overrides.',
          () {
            final dep = Provider((_) => 0, dependencies: const []);
            final provider = Provider.family<String, int>(
              (ref, id) => 'root ${ref.watch(dep)}',
              dependencies: [dep],
            );

            final root = ProviderContainer.test(
              overrides: [
                provider(42).overrideWith((ref) {
                  return 'override ${ref.watch(dep)}';
                }),
              ],
            );

            final container = ProviderContainer.test(
              parent: root,
              overrides: [dep.overrideWithValue(42)],
            );

            expect(
              container.read(provider(42)),
              'override 0',
              reason:
                  'provider(42) is manually overridden, '
                  'so this disables auto-scoping',
            );
            expect(container.read(provider(21)), 'root 42');
            expect(root.read(provider(21)), 'root 0');
            expect(root.read(provider(42)), 'override 0');
          },
        );

        test('does not inherit transitive overrides', () {
          final unrelated = Provider((_) => 0, dependencies: const []);
          final dep = Provider((_) => 0, dependencies: const [], name: 'dep');
          final provider = Provider((_) => 0, dependencies: [dep], name: 'a');
          final family = Provider.family(
            (_, d) => 0,
            dependencies: [dep],
            name: 'b',
          );
          final root = ProviderContainer.test();
          final mid = ProviderContainer.test(parent: root, overrides: [dep]);

          mid.pointerManager.upsertPointer(provider);
          mid.pointerManager.upsertPointer(family(42));

          final container = ProviderContainer.test(
            parent: mid,
            overrides: [
              // An unrelated override, added to avoid the container optimizing
              unrelated,
            ],
          );

          expect(container.pointerManager.orphanPointers.pointers, {
            dep: isPointer(targetContainer: mid, override: dep),
            unrelated: isPointer(),
          });
          expect(container.pointerManager.familyPointers, isEmpty);
        });

        test('inherits overrides from its parents', () {
          final a = Provider((_) => 0, name: 'a');
          final aOverride = a.overrideWithValue(1);
          final b = Provider((_) => 0, name: 'b', dependencies: const []);
          final bOverride = b.overrideWithValue(2);
          final c = Provider((_) => 0, name: 'c', dependencies: const []);
          final cOverride = c.overrideWithValue(3);
          final aFamily = Provider.family<int, int>(
            (_, _) => 0,
            name: 'aFamily',
          );
          final aFamilyOverride = aFamily.overrideWith((_, _) => 1);
          final aValueOverride = aFamily(1).overrideWith((_) => 2);
          final bFamily = Provider.family<int, int>(
            (_, _) => 0,
            name: 'bFamily',
            dependencies: const [],
          );
          final bFamilyOverride = bFamily.overrideWith((_, _) => 2);
          final bValueOverride = bFamily(2).overrideWith((_) => 3);
          final cFamily = Provider.family<int, int>(
            (_, _) => 0,
            name: 'cFamily',
            dependencies: const [],
          );
          final cFamilyOverride = cFamily.overrideWith((_, _) => 3);
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

          expect(container.pointerManager.familyPointers, {
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
          });

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

        test('orphanPointers.containers are always equal to root', () {
          final root = ProviderContainer.test();
          final provider = Provider((_) => 0, dependencies: const []);
          final container = ProviderContainer.test(
            parent: root,
            overrides: [provider],
          );

          expect(root.pointerManager.orphanPointers.targetContainer, root);
          expect(container.pointerManager.orphanPointers.targetContainer, root);

          expect(container.pointerManager.orphanPointers.pointers, {
            provider: isPointer(
              targetContainer: container,
              override: provider,
              element: null,
            ),
          });
        });

        test('can scope a provider that is already scoped', () {
          final provider = Provider((_) => 0, dependencies: const []);
          final family = Provider.family<int, int>(
            (_, b) => 0,
            dependencies: const [],
          );
          final root = ProviderContainer.test();

          final providerOverride1 = provider.overrideWithValue(1);
          final familyOverride1 = family.overrideWith((ref, arg) => 1);
          final mid = ProviderContainer.test(
            parent: root,
            overrides: [providerOverride1, familyOverride1],
          );

          final providerOverride2 = provider.overrideWithValue(1);
          final familyOverride2 = family.overrideWith((ref, arg) => 1);
          final leaf = ProviderContainer.test(
            parent: mid,
            overrides: [providerOverride2, familyOverride2],
          );

          expect(leaf.pointerManager.orphanPointers.pointers, {
            provider: isPointer(
              targetContainer: leaf,
              override: providerOverride2,
              element: null,
            ),
          });
          expect(leaf.pointerManager.familyPointers, {
            family: isProviderDirectory(
              override: familyOverride2,
              targetContainer: leaf,
              pointers: isEmpty,
            ),
          });

          expect(mid.pointerManager.orphanPointers.pointers, {
            provider: isPointer(
              targetContainer: mid,
              override: providerOverride1,
              element: null,
            ),
          });
          expect(mid.pointerManager.familyPointers, {
            family: isProviderDirectory(
              override: familyOverride1,
              targetContainer: mid,
              pointers: isEmpty,
            ),
          });
        });

        test('child container uses root overrides', () {
          final provider = Provider((ref) => 0);
          final container = ProviderContainer.test(
            overrides: [provider.overrideWithValue(42)],
          );
          final child = ProviderContainer.test(parent: container);

          expect(child.read(provider), 42);
        });

        test('test two families one overridden the other not', () {
          final family = Provider.family<String, int>((ref, value) {
            return '$value';
          });
          final family2 = Provider.family<String, int>((ref, value) {
            return '$value 2';
          }, dependencies: const []);
          final root = ProviderContainer.test();
          final container = ProviderContainer.test(
            parent: root,
            overrides: [family2],
          );

          expect(container.read(family(0)), '0');
          expect(container.read(family2(0)), '0 2');

          expect(container.getAllProviderElements(), [
            isA<ProviderElement>().having(
              (e) => e.origin,
              'origin',
              family2(0),
            ),
          ]);
          expect(root.getAllProviderElements(), [
            isA<ProviderElement>().having((e) => e.origin, 'origin', family(0)),
          ]);
        });

        group('scoping mechanism', () {
          test('use the deepest override', () {
            final provider = Provider((ref) => 0, dependencies: const []);
            final root = ProviderContainer.test(
              overrides: [provider.overrideWithValue(1)],
            );
            final mid = ProviderContainer.test(
              parent: root,
              overrides: [provider.overrideWithValue(42)],
            );
            final container = ProviderContainer.test(parent: mid);

            expect(container.read(provider), 42);

            expect(container.getAllProviderElements(), isEmpty);
            expect(mid.getAllProviderElements(), [
              isA<ProviderElement>()
                  .having((e) => e.origin, 'origin', provider)
                  .having((e) => e.readSelf(), 'readSelf()', $ResultData(42)),
            ]);
            expect(root.getAllProviderElements(), isEmpty);
          });

          test('can read both parent and child simultaneously', () async {
            final provider = Provider((ref) => 0, dependencies: const []);
            final root = ProviderContainer.test(
              overrides: [provider.overrideWithValue(21)],
            );
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider.overrideWithValue(42)],
            );

            expect(container.read(provider), 42);
            expect(root.read(provider), 21);
            expect(container.read(provider), 42);
            expect(root.read(provider), 21);
          });

          test('can be overridden on non-root container', () {
            final provider = Provider((ref) => 0, dependencies: const []);
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider.overrideWithValue(42)],
            );

            expect(container.read(provider), 42);
          });

          test('can listen to other scoped providers', () async {
            final listener = Listener<int>();
            final provider = Provider((ref) => 0, dependencies: const []);
            final provider2 = Provider(
              (ref) => ref.watch(provider) * 2,
              dependencies: [provider],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider.overrideWithValue(1), provider2],
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
            final provider = settableProvider((ref) => 1);
            final provider2 = Provider(
              (ref) => ref.watch(provider) * 2,
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider2],
            );

            container.listen(provider2, listener.call, fireImmediately: true);

            verifyOnly(listener, listener(null, 2));

            root.read(provider.notifier).state++;

            await container.pump();

            verifyOnly(listener, listener(2, 4));
          });
        });
      });

      test('adds non-family provider overrides to orphanPointers', () {
        final provider = Provider((_) => 0, dependencies: const []);
        final override = provider.overrideWithValue(42);
        final root = ProviderContainer.test(overrides: [override]);
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

        expect(root2.pointerManager.orphanPointers.pointers, isEmpty);
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
        final root = ProviderContainer.test(overrides: [override]);
        final root2 = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root2,
          overrides: [override],
        );

        expect(root.pointerManager.familyPointers, {
          provider: isProviderDirectory(
            override: override,
            targetContainer: root,
            pointers: isEmpty,
          ),
        });

        expect(root2.pointerManager.familyPointers, isEmpty);
        expect(container.pointerManager.familyPointers, {
          provider: isProviderDirectory(
            override: override,
            targetContainer: container,
            pointers: isEmpty,
          ),
        });
      });

      test('adds family provider overrides to familyPointers.pointers', () {
        final provider = Provider.family<int, int>(
          (ref, _) => 0,
          dependencies: const [],
        );
        final override = provider(42).overrideWith((ref) => 0);
        final root = ProviderContainer.test(overrides: [override]);
        final root2 = ProviderContainer.test();

        final container = ProviderContainer.test(
          parent: root2,
          overrides: [override],
        );

        expect(root.pointerManager.familyPointers, {
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
        });

        expect(
          container.pointerManager.familyPointers,
          isNot(root2.pointerManager.familyPointers),
        );

        expect(root2.pointerManager.familyPointers, isEmpty);

        expect(container.pointerManager.familyPointers, {
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
        });
      });

      test(
        'can override a family and a provider from that family in the same container',
        () {
          final family = Provider.family<String, int>((ref, a) => 'Hello $a');
          final familyOverride = family.overrideWith((ref, a) => 'Hi $a');
          final beforeOverride = family(42).overrideWithValue('Bonjour 42');
          final afterOverride = family(21).overrideWithValue('Ola 42');

          final container = ProviderContainer.test(
            overrides: [beforeOverride, familyOverride, afterOverride],
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
        },
      );

      test('supports disposing of overridden families', () async {
        // Regression test for https://github.com/rrousselGit/riverpod/issues/2480
        final provider = Provider.autoDispose.family<int, int>(
          (ref, _) => -1,
          dependencies: const [],
        );

        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWith((ref, arg) => 0)],
        );

        container.read(provider(0));

        expect(container.pointerManager.readPointer(provider(0)), isNotNull);
        expect(container.pointerManager.familyPointers[provider], isNotNull);

        await container.pump();

        // The family pointer should still be there, as it comes from an override
        expect(container.pointerManager.familyPointers[provider], isNotNull);
        // The provider should've been disposed.
        expect(container.pointerManager.readPointer(provider(0)), isNull);
      });

      test('When a non-overridden autoDispose provider is disposed '
          'and the associated ProviderContainer has a child ProviderContainer which overrides said provider, '
          'the child container keeps its override', () async {
        // Regression test for https://github.com/rrousselGit/riverpod/issues/1519

        final provider = Provider.autoDispose(
          (ref) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final child = ProviderContainer.test(
          parent: root,
          overrides: [
            provider.overrideWith((ref) {
              ref.keepAlive();
              return 42;
            }),
          ],
        );

        root.read(provider);
        child.read(provider);

        await root.pump();

        expect(root.pointerManager.readPointer(provider), isNull);

        expect(
          child.pointerManager.readPointer(provider),
          isPointer(override: isNotNull, element: isNotNull),
        );
      });

      test(
        'cleans up the pointers of a provider in the entire ProviderContainer tree',
        () async {
          final unrelated = Provider((_) => 42, dependencies: const []);
          // Regression test for https://github.com/rrousselGit/riverpod/issues/1943
          final a = ProviderContainer.test();
          // b/c voluntarily do not use the Provider, but a/d do. This is to test
          // that the disposal logic correctly cleans up the StateReaders
          // in all ProviderContainers associated with the provider, even if
          // some links between two ProviderContainers are not using the provider.
          final b = ProviderContainer.test(parent: a, overrides: [unrelated]);
          final c = ProviderContainer.test(parent: b, overrides: [unrelated]);
          final d = ProviderContainer.test(parent: c, overrides: [unrelated]);

          final provider = Provider.autoDispose((ref) => 3);

          final subscription = d.listen(
            provider,
            (previous, next) {},
            fireImmediately: true,
          );

          expect(a.pointerManager.readPointer(provider), isNotNull);
          expect(b.pointerManager.readPointer(provider), isNull);
          expect(c.pointerManager.readPointer(provider), isNull);
          expect(d.pointerManager.readPointer(provider), isNotNull);

          subscription.close();

          expect(a.pointerManager.readPointer(provider), isNotNull);
          expect(b.pointerManager.readPointer(provider), isNull);
          expect(c.pointerManager.readPointer(provider), isNull);
          expect(d.pointerManager.readPointer(provider), isNotNull);

          await a.pump();

          expect(a.pointerManager.readPointer(provider), isNull);
          expect(b.pointerManager.readPointer(provider), isNull);
          expect(c.pointerManager.readPointer(provider), isNull);
          expect(d.pointerManager.readPointer(provider), isNull);

          d.listen(provider, (previous, next) {}, fireImmediately: true);

          expect(a.pointerManager.readPointer(provider), isNotNull);
          expect(b.pointerManager.readPointer(provider), isNull);
          expect(c.pointerManager.readPointer(provider), isNull);
          expect(d.pointerManager.readPointer(provider), isNotNull);
        },
      );
    });

    group('.test', () {
      test('Auto-disposes the provider when the test ends', () {
        late ProviderContainer container;

        addTearDown(() => expect(container.disposed, true));

        container = ProviderContainer.test();

        addTearDown(() => expect(container.disposed, false));
      });

      test('Passes parameters', () {
        final provider = Provider((ref) => 0, dependencies: const []);
        final observer = _EmptyObserver();

        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          observers: [observer],
          overrides: [provider.overrideWithValue(1)],
        );

        expect(container.root, root);
        expect(
          container.observers,
          anyOf([
            [observer],
            [observer, isA<DevtoolObserver>()],
          ]),
        );
        expect(container.read(provider), 1);
      });
    });

    group('dispose', () {
      test(
        'Handles cases where the ProviderContainer is disposed yet Scheduler.performDispose is invoked anyway',
        () async {
          // regression test for https://github.com/rrousselGit/riverpod/issues/1400
          final provider = Provider.autoDispose(
            (ref) => 0,
            dependencies: const [],
          );
          final root = ProviderContainer.test();
          final container = ProviderContainer.test(
            parent: root,
            overrides: [provider],
          );

          container.read(provider);
          container.dispose();

          await root.pump();
        },
      );

      test(
        'after a child container is disposed, '
        'ref.watch keeps working on providers associated with the ancestor container',
        () async {
          final container = ProviderContainer.test();
          final dep = settableProvider((ref) => 0);
          final provider = Provider((ref) => ref.watch(dep));
          final listener = Listener<int>();
          final child = ProviderContainer.test(parent: container);

          container.listen<int>(provider, listener.call, fireImmediately: true);

          verifyOnly(listener, listener(null, 0));

          child.dispose();

          container.read(dep.notifier).state++;
          await container.pump();

          verifyOnly(listener, listener(0, 1));
        },
      );

      test('does not compute provider states if not loaded yet', () {
        var callCount = 0;
        final provider = Provider((_) => callCount++);

        final container = ProviderContainer.test(overrides: [provider]);

        container.dispose();

        expect(callCount, 0);
      });

      test('Disposes its children first', () {
        final rootOnDispose = OnDisposeMock();
        final childOnDispose = OnDisposeMock();
        final child2OnDispose = OnDisposeMock();
        final provider = Provider((ref) {
          ref.onDispose(rootOnDispose.call);
          return 0;
        }, dependencies: const []);

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

        verifyInOrder([childOnDispose.call(), rootOnDispose.call()]);

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

      test(
        'ProviderContainer was disposed before Scheduler handled the dispose',
        () async {
          final container = ProviderContainer.test();
          final onDispose = OnDisposeMock();
          final provider = Provider.autoDispose((ref) {
            ref.onDispose(onDispose.call);
            return 42;
          });

          final sub = container.listen(provider, (prev, value) {});

          verifyNoMoreInteractions(onDispose);

          sub.close();
          verifyNoMoreInteractions(onDispose);

          container.dispose();

          verify(onDispose()).called(1);
          verifyNoMoreInteractions(onDispose);

          await container.pump();

          verifyNoMoreInteractions(onDispose);
        },
      );

      test(
        'Do not dispose twice when ProviderContainer is disposed first',
        () async {
          final onDispose = OnDisposeMock();
          final provider = Provider.autoDispose((ref) {
            ref.onDispose(onDispose.call);
            return 42;
          });
          final container = ProviderContainer.test();

          final sub = container.listen(provider, (_, _) {});
          sub.close();

          container.dispose();

          verify(onDispose()).called(1);
          verifyNoMoreInteractions(onDispose);

          await container.pump();

          verifyNoMoreInteractions(onDispose);
        },
      );

      test('disposing child container does not dispose the providers', () {
        final container = ProviderContainer.test();
        final child = ProviderContainer.test(parent: container);
        var disposed = false;
        final provider = Provider((ref) {
          ref.onDispose(() => disposed = true);
          return 0;
        });

        expect(child.read(provider), 0);

        child.dispose();

        expect(disposed, false);

        container.dispose();

        expect(disposed, true);
      });

      test('disposing an already disposed container is no-op', () {
        final container = ProviderContainer.test();

        container.dispose();
        container.dispose();
      });

      test('dispose providers in dependency order (simple)', () {
        final container = ProviderContainer.test();
        final onDispose1 = OnDisposeMock();
        final onDispose2 = OnDisposeMock();
        final onDispose3 = OnDisposeMock();

        final provider1 = Provider((ref) {
          ref.onDispose(onDispose1.call);
          return 1;
        });

        final provider2 = Provider((ref) {
          final value = ref.watch(provider1);
          ref.onDispose(onDispose2.call);
          return value + 1;
        });

        final provider3 = Provider((ref) {
          final value = ref.watch(provider2);
          ref.onDispose(onDispose3.call);
          return value + 1;
        });

        expect(container.read(provider3), 3);

        container.dispose();

        verifyInOrder([onDispose3(), onDispose2(), onDispose1()]);
        verifyNoMoreInteractions(onDispose1);
        verifyNoMoreInteractions(onDispose2);
        verifyNoMoreInteractions(onDispose3);
      });

      test('dispose', () {
        final container = ProviderContainer.test();
        final onDispose = OnDisposeMock();
        final provider = Provider((ref) {
          ref.onDispose(onDispose.call);
          return 42;
        });

        expect(container.read(provider), 42);

        verifyZeroInteractions(onDispose);

        container.dispose();

        verify(onDispose()).called(1);
      });
    });

    group('exists', () {
      test('exist listenables compare equal for the same provider', () {
        final provider = Provider((ref) => 0);

        expect(provider.exists, provider.exists);
        expect({provider.exists}, contains(provider.exists));
      });

      test('is reactive without initializing the provider', () async {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();
        final listener = Listener<bool>();

        expect(container.read(provider.exists), false);
        expect(
          container.getAllProviderElements().map((e) => e.origin),
          isNot(contains(provider)),
        );

        container.listen(provider.exists, listener.call);

        container.read(provider);

        verifyZeroInteractions(listener);
        await container.pump();
        verifyOnly(listener, listener(false, true));
        expect(container.exists(provider), true);
      });

      test(
        'reading existence preserves weak listeners before initialization',
        () {
          final provider = Provider((ref) => 42);
          final container = ProviderContainer.test();
          final listener = Listener<int>();

          container.listen(provider, listener.call, weak: true);

          container.read(provider.exists);
          verifyZeroInteractions(listener);

          expect(container.read(provider), 42);

          verifyOnly(listener, listener(null, 42));
        },
      );

      test('follows provider overrides in child containers', () async {
        final provider = Provider((ref) => 0);
        final root = ProviderContainer.test();
        final child = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWith((ref) => 1)],
        );
        final listener = Listener<bool>();

        child.listen(provider.exists, listener.call);

        root.read(provider);
        await root.pump();
        verifyZeroInteractions(listener);

        child.read(provider);
        await child.pump();
        verifyOnly(listener, listener(false, true));
      });

      test('reading inherited existence does not initialize the provider', () {
        final provider = Provider((ref) => 0);
        final unrelated = Provider((ref) => 0);
        final root = ProviderContainer.test();
        final child = ProviderContainer.test(
          parent: root,
          overrides: [unrelated.overrideWithValue(1)],
        );

        expect(child.read(provider.exists), isFalse);
        expect(root.getAllProviderElements(), isEmpty);
        expect(child.getAllProviderElements(), isEmpty);

        root.read(provider);

        expect(child.read(provider.exists), isTrue);
      });

      test('ref.listen existence does not keep its owner alive', () async {
        final other = Provider((ref) => 0);
        var disposed = false;
        late ProviderSubscription<bool> existenceSubscription;
        final provider = Provider.autoDispose((ref) {
          existenceSubscription = ref.listen(other.exists, (_, _) {});
          ref.onDispose(() => disposed = true);
          return 0;
        });
        final container = ProviderContainer.test();
        final subscription = container.listen(provider, (_, _) {});

        expect(disposed, isFalse);
        expect(existenceSubscription.closed, isFalse);

        subscription.close();
        await container.pump();

        expect(disposed, isTrue);
        expect(existenceSubscription.closed, isTrue);
        expect(container.read(provider.exists), isFalse);
      });

      test('notifies after an autoDispose provider is removed', () async {
        final provider = Provider.autoDispose((ref) => 0);
        final container = ProviderContainer.test();
        final listener = Listener<bool>();

        container.listen(provider.exists, listener.call);

        expect(container.read(provider.exists), false);
        final providerSub = container.listen(provider, (_, _) {});
        await container.pump();

        verifyOnly(listener, listener(false, true));

        providerSub.close();
        await Future<void>.delayed(.zero);

        verifyOnly(listener, listener(true, false));

        container.listen(provider, (_, _) {});
        await Future<void>.delayed(.zero);

        verifyOnly(listener, listener(false, true));
      });

      test(
        'closes ref.listen existence subscriptions when the provider is invalidated',
        () async {
          final other = Provider((ref) => 0);
          final subscriptions = <ProviderSubscription<bool>>[];
          final provider = Provider((ref) {
            subscriptions.add(ref.listen(other.exists, (_, _) {}));
            return 0;
          });
          final container = ProviderContainer.test();
          final providerSubscription = container.listen(provider, (_, _) {});

          expect(subscriptions.single.closed, isFalse);
          expect(
            container.pointerManager.readPointer(other)!.subscriptions,
            contains(subscriptions.single),
          );

          container.invalidate(provider);
          await container.pump();

          expect(subscriptions.first.closed, isTrue);
          expect(
            container.pointerManager.readPointer(other)!.subscriptions,
            contains(subscriptions.last),
          );
          expect(
            container.pointerManager.readPointer(other)!.subscriptions,
            isNot(contains(subscriptions.first)),
          );

          providerSubscription.close();
        },
      );

      test(
        'supports manually pausing and resuming ref.listen existence subscriptions',
        () {
          final other = Provider((ref) => 0);
          late ProviderSubscription<bool> subscription;
          final provider = Provider((ref) {
            subscription = ref.listen(other.exists, (_, _) {});
            return 0;
          });
          final container = ProviderContainer.test();
          final providerSubscription = container.listen(provider, (_, _) {});

          expect(subscription.isPaused, isFalse);

          subscription.pause();
          expect(subscription.isPaused, isTrue);

          subscription.resume();
          expect(subscription.isPaused, isFalse);

          providerSubscription.close();
        },
      );

      test(
        'removes an unmounted autoDispose pointer when its subscription closes',
        () {
          final provider = Provider.autoDispose((ref) => 0);
          final container = ProviderContainer.test();
          final sub = container.listen(provider.exists, (_, _) {});

          expect(container.pointerManager.readPointer(provider), isNotNull);
          expect(container.pointerManager.readElement(provider), isNull);

          sub.close();

          expect(container.pointerManager.readPointer(provider), isNull);
        },
      );

      test(
        'keeps an active pointer when its existence subscription closes',
        () {
          final provider = Provider.autoDispose((ref) => 0);
          final container = ProviderContainer.test();
          final sub = container.listen(provider.exists, (_, _) {});

          container.read(provider);
          sub.close();

          expect(container.pointerManager.readPointer(provider), isNotNull);
          expect(container.pointerManager.readElement(provider), isNotNull);
        },
      );

      test(
        'removes inherited pointers when an existence subscription closes',
        () {
          final provider = Provider.autoDispose((ref) => 0);
          final unrelated = Provider((ref) => 0);
          final root = ProviderContainer.test();
          final child = ProviderContainer.test(
            parent: root,
            overrides: [unrelated],
          );
          final sub = child.listen(provider.exists, (_, _) {});

          expect(root.pointerManager.readPointer(provider), isNotNull);
          expect(child.pointerManager.readPointer(provider), isNotNull);

          sub.close();

          expect(root.pointerManager.readPointer(provider), isNull);
          expect(child.pointerManager.readPointer(provider), isNull);
        },
      );

      test('supports fireImmediately', () {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();
        final listener = Listener<bool>();

        container.listen(provider.exists, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, false));
      });

      test('closes existence subscriptions when the container is disposed', () {
        final provider = Provider((ref) => 0);
        final overriddenProvider = Provider((ref) => 0);
        final family = Provider.family<int, int>((ref, value) => value);
        final container = ProviderContainer.test(
          overrides: [
            overriddenProvider.overrideWithValue(0),
            family.overrideWith((ref, value) => value),
          ],
        );
        final sub = container.listen(provider.exists, (_, _) {});
        final overriddenSub = container.listen(
          overriddenProvider.exists,
          (_, _) {},
        );
        final familySub = container.listen(family(0).exists, (_, _) {});

        container.dispose();

        expect(sub.closed, isTrue);
        expect(overriddenSub.closed, isTrue);
        expect(familySub.closed, isTrue);
      });

      test('supports select', () async {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();
        final listener = Listener<bool>();

        container.listen(
          provider.exists.select((exists) => exists),
          listener.call,
          fireImmediately: true,
        );

        verifyOnly(listener, listener(null, false));

        container.read(provider);
        await container.pump();

        verifyOnly(listener, listener(false, true));
      });

      test('weak selected existence can be read before any notification', () {
        var builds = 0;
        final provider = Provider((ref) => ++builds);
        final container = ProviderContainer.test();
        final sub = container.listen(
          provider.exists.select((exists) => exists),
          (_, _) {},
          weak: true,
        );

        expect(sub.read(), isFalse);
        expect(builds, 0);
      });

      test('closes selected existence subscriptions on container disposal', () {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();
        final sub = container.listen(
          provider.exists.select((exists) => exists),
          (_, _) {},
        );

        container.dispose();

        expect(sub.closed, isTrue);
      });

      test(
        'closes selected ref.listen existence subscriptions on rebuild',
        () async {
          final other = Provider((ref) => 0);
          final subscriptions = <ProviderSubscription<bool>>[];
          final notifications = <int>[];
          final provider = Provider((ref) {
            final build = subscriptions.length;
            subscriptions.add(
              ref.listen(
                other.exists.select((exists) => exists),
                (_, _) => notifications.add(build),
              ),
            );
            return 0;
          });
          final container = ProviderContainer.test();
          container.listen(provider, (_, _) {});

          container.invalidate(provider);
          await container.pump();
          expect(subscriptions, hasLength(2));

          container.read(other);
          await container.pump();

          expect(notifications, [1]);
          expect(subscriptions.first.closed, isTrue);
          expect(subscriptions.last.closed, isFalse);
        },
      );

      test('allows callbacks to initialize other observed providers', () async {
        final provider = Provider((ref) => 0);
        final dependency = Provider((ref) => 0);
        final container = ProviderContainer.test();
        final dependencyListener = Listener<bool>();
        final providerListener = Listener<bool>();

        final dependencySub = container.listen(
          dependency.exists,
          dependencyListener.call,
          fireImmediately: true,
        );
        final providerSub = container.listen(
          provider.exists,
          fireImmediately: true,
          (prev, next) {
            providerListener(prev, next);
            if (next) container.read(dependency);
          },
        );

        verifyOnly(providerListener, providerListener(null, false));
        verifyOnly(dependencyListener, dependencyListener(null, false));

        container.read(provider);
        await Future<void>.delayed(.zero);

        verifyOnly(dependencyListener, dependencyListener(false, true));
        verifyOnly(providerListener, providerListener(false, true));
      });

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
          overrides: [provider.overrideWith((ref) => 42)],
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
          overrides: [provider.overrideWith((ref) => 42)],
        );

        expect(container.exists(provider), false);
        expect(container.getAllProviderElements(), isEmpty);

        container.read(provider);

        expect(container.exists(provider), true);
      });

      test('handles nested providers', () {
        final provider = Provider((ref) => 0);
        final provider2 = Provider((ref) => 0, dependencies: const []);
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
        expect(container.getAllProviderElements().map((e) => e.origin), [
          provider2,
        ]);
        expect(root.getAllProviderElements().map((e) => e.origin), [provider]);
      });
    });

    group('.pump', () {
      test(
        'Waits for providers associated with this container and its parents to rebuild',
        () async {
          final dep = settableProvider((ref) => 0);
          final a = Provider((ref) => ref.watch(dep));
          final b = Provider((ref) => ref.watch(dep), dependencies: const []);
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
        },
      );
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

        expect(() => container.updateOverrides([]), throwsA(isAssertionError));
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

        final container = ProviderContainer.test(overrides: [provider]);

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

        container.updateOverrides([provider.overrideWithValue(42)]);

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

        container.updateOverrides([provider.overrideWithValue(21)]);

        verifyOnly(listener, listener(42, 21));
      });

      test(
        'updating parent override when there is a child override is no-op',
        () async {
          final provider = Provider((ref) => 0, dependencies: const []);
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

          root.updateOverrides([provider.overrideWithValue(22)]);

          await container.pump();

          verifyNoMoreInteractions(listener);
        },
      );

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

        verifyInOrder([listener(21, 22), listener2(42, 43)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('if listened from a child container, '
          'updating the parent override correctly notifies listeners', () {
        final provider = Provider((ref) => 0, dependencies: const []);
        final root = ProviderContainer.test(
          overrides: [provider.overrideWithValue(1)],
        );
        final mid = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWithValue(42)],
        );
        final container = ProviderContainer.test(parent: mid);
        final listener = Listener<int>();

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, 42));

        mid.updateOverrides([provider.overrideWithValue(21)]);

        verifyOnly(listener, listener(42, 21));
      });

      test('throws if used on a disposed container', () {
        final container = ProviderContainer.test();
        container.dispose();

        expect(() => container.updateOverrides([]), throwsStateError);
      });
    });

    group('invalidate', () {
      test(
        'can invalidate non-scoped family from a scoped container with overrides',
        () {
          final root = ProviderContainer.test();
          final family = Provider.family<Object?, int>(
            (ref, arg) => Object(),
            name: 'family',
          );
          final scoped = Provider(
            (ref) => 0,
            dependencies: const [],
            name: 'scoped',
          );
          final provider = Provider(
            (ref) => ref.watch(family(0)),
            name: 'provider',
          );
          final leaf = ProviderContainer.test(
            parent: root,
            overrides: [scoped.overrideWithValue(42)],
          );

          final initial = leaf.read(provider);
          leaf.invalidate(family);
          final afterInvalidate = leaf.read(provider);

          expect(initial, isNot(same(afterInvalidate)));
        },
      );

      test(
        'can invalidate a non-scoped family member from a scoped container with overrides',
        () {
          final root = ProviderContainer.test();
          final family = Provider.family<Object?, int>(
            (ref, arg) => Object(),
            name: 'family',
          );
          final scoped = Provider(
            (ref) => 0,
            dependencies: const [],
            name: 'scoped',
          );
          final leaf = ProviderContainer.test(
            parent: root,
            overrides: [scoped.overrideWithValue(42)],
          );

          final initial = root.read(family(0));
          leaf.invalidate(family(0));
          final afterInvalidate = root.read(family(0));

          expect(initial, isNot(same(afterInvalidate)));
        },
      );

      test(
        'can invalidate family members mounted after the scoped container was created',
        () {
          final root = ProviderContainer.test();
          final family = Provider.family<Object?, int>(
            (ref, arg) => Object(),
            name: 'family',
          );
          final scoped = Provider(
            (ref) => 0,
            dependencies: const [],
            name: 'scoped',
          );
          final leaf = ProviderContainer.test(
            parent: root,
            overrides: [scoped.overrideWithValue(42)],
          );

          // Mounts the family directory in both "root" and "leaf",
          // then adds a new member only visible in "root".
          leaf.read(family(0));
          final initial = root.read(family(1));
          leaf.invalidate(family);
          final afterInvalidate = root.read(family(1));

          expect(initial, isNot(same(afterInvalidate)));
        },
      );

      test(
        'can invalidate a non-scoped provider from a sibling scoped container with overrides',
        () {
          // Regression test for https://github.com/rrousselGit/riverpod/issues/4784
          var buildCount = 0;
          final provider = Provider((ref) => ++buildCount, name: 'provider');
          final scoped = Provider(
            (ref) => 0,
            dependencies: const [],
            name: 'scoped',
          );

          final root = ProviderContainer.test();
          final mid = ProviderContainer.test(
            parent: root,
            overrides: [scoped.overrideWithValue(0)],
          );
          final a = ProviderContainer.test(
            parent: mid,
            overrides: [scoped.overrideWithValue(1)],
          );
          final b = ProviderContainer.test(
            parent: mid,
            overrides: [scoped.overrideWithValue(2)],
          );

          expect(a.read(provider), 1);

          // "b" never read "provider", so its pointers do not know about it.
          b.invalidate(provider);

          expect(a.read(provider), 2);
        },
      );

      test(
        'does not invalidate scoped providers from unrelated containers',
        () {
          final root = ProviderContainer.test();
          var buildCount = 0;
          final scoped = Provider(
            (ref) => ++buildCount,
            dependencies: const [],
            name: 'scoped',
          );
          final a = ProviderContainer.test(
            parent: root,
            overrides: [scoped.overrideWithValue(42)],
          );
          final b = ProviderContainer.test(parent: root, overrides: [scoped]);

          expect(b.read(scoped), 1);

          // "scoped" is mounted in "b", which is not visible from "a".
          a.invalidate(scoped);

          expect(b.read(scoped), 1);
          expect(buildCount, 1);
        },
      );

      test('can disposes of the element if not used anymore', () async {
        final provider = Provider.autoDispose((r) {
          r.keepAlive();
          return 0;
        });
        final container = ProviderContainer.test();

        container.read(provider);
        container.invalidate(provider);

        await container.pump();

        expect(container.getAllProviderElements(), isEmpty);
      });

      test('supports asReload', () async {
        final container = ProviderContainer.test();
        final provider = FutureProvider<int>((r) async => 0);

        await container.read(provider.future);
        expect(container.read(provider), const AsyncValue.data(0));

        container.invalidate(provider, asReload: true);

        expect(
          container.read(provider),
          isA<AsyncLoading<int>>().having((e) => e.value, 'value', 0),
        );
      });

      test('invalidate triggers a rebuild on next frame', () async {
        final container = ProviderContainer.test();
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
    });

    group('listen', () {
      test(
        'when no onError is specified, fallbacks to handleUncaughtError',
        () async {
          final errors = <Object>[];
          final container = runZonedGuarded(
            ProviderContainer.test,
            (err, stack) => errors.add(err),
          )!;
          final isErrored = settableProvider((ref) => false);
          final dep = Provider<int>((ref) {
            if (ref.watch(isErrored)) throw UnimplementedError();
            return 0;
          });
          final listener = Listener<int>();

          container.listen(dep, listener.call);

          verifyZeroInteractions(listener);
          expect(errors, isEmpty);

          container.read(isErrored.notifier).state = true;

          await container.pump();

          verifyZeroInteractions(listener);
          expect(errors, [isUnimplementedError]);
        },
      );

      test(
        'when no onError is specified, selectors fallbacks to handleUncaughtError',
        () async {
          final errors = <Object>[];
          final container = runZonedGuarded(
            ProviderContainer.test,
            (err, stack) => errors.add(err),
          )!;
          final isErrored = settableProvider((ref) => false);
          final dep = Provider<int>((ref) {
            if (ref.watch(isErrored)) throw UnimplementedError();
            return 0;
          });
          final listener = Listener<int>();

          container.listen(dep.select((value) => value), listener.call);

          verifyZeroInteractions(listener);
          expect(errors, isEmpty);

          container.read(isErrored.notifier).state = true;

          await container.pump();

          verifyZeroInteractions(listener);
          expect(errors, [isUnimplementedError]);
        },
      );

      test('when rebuild throws, calls onError', () async {
        final container = ProviderContainer.test();
        final dep = settableProvider((ref) => 0);
        final provider = Provider((ref) {
          if (ref.watch(dep) != 0) {
            throw UnimplementedError();
          }
          return 0;
        });
        final errorListener = ErrorListener();
        final listener = Listener<int>();

        container.listen(provider, listener.call, onError: errorListener.call);

        verifyZeroInteractions(errorListener);
        verifyZeroInteractions(listener);

        container.read(dep.notifier).state++;
        await container.pump();

        verifyZeroInteractions(listener);
        verifyOnly(errorListener, errorListener(isUnimplementedError, any));
      });

      test('when rebuild throws on selector, calls onError', () async {
        final container = ProviderContainer.test();
        final dep = settableProvider((ref) => 0);
        final provider = Provider((ref) {
          if (ref.watch(dep) != 0) {
            throw UnimplementedError();
          }
          return 0;
        });
        final errorListener = ErrorListener();
        final listener = Listener<int>();

        container.listen(
          provider.select((value) => value),
          listener.call,
          onError: errorListener.call,
        );

        verifyZeroInteractions(errorListener);
        verifyZeroInteractions(listener);

        container.read(dep.notifier).state++;
        await container.pump();

        verifyZeroInteractions(listener);
        verifyOnly(errorListener, errorListener(isUnimplementedError, any));
      });

      test(
        'when using selectors, `previous` is the latest notification instead of latest event',
        () {
          final container = ProviderContainer.test();
          final provider = settableProvider((ref) => 0);
          final listener = Listener<bool>();

          container.listen<bool>(
            provider.select((value) => value.isEven),
            listener.call,
            fireImmediately: true,
          );

          verifyOnly(listener, listener(null, true));

          container.read(provider.notifier).state += 2;

          verifyNoMoreInteractions(listener);

          container.read(provider.notifier).state++;

          verifyOnly(listener, listener(true, false));
        },
      );

      test('expose previous and new value on change', () {
        final container = ProviderContainer.test();
        final provider = settableProvider((ref) => 0);
        final listener = Listener<int>();

        container.listen<int>(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, 0));

        container.read(provider.notifier).state++;

        verifyOnly(listener, listener(0, 1));
      });

      test('can downcast the value', () async {
        final listener = Listener<num>();
        final dep = settableProvider((ref) => 0);

        final container = ProviderContainer.test();

        container.listen<num>(dep, listener.call);

        verifyZeroInteractions(listener);

        container.read(dep.notifier).state++;
        await container.pump();

        verifyOnly(listener, listener(0, 1));
      });

      test(
        'if a listener adds a container.listen, the new listener is not called immediately',
        () {
          final provider = settableProvider((ref) => 0);
          final container = ProviderContainer.test();

          final listener = Listener<int>();

          container.listen<int>(provider, (prev, value) {
            listener(prev, value);
            container.listen<int>(provider, listener.call);
          });

          verifyZeroInteractions(listener);

          container.read(provider.notifier).state++;

          verify(listener(0, 1)).called(1);

          container.read(provider.notifier).state++;

          verify(listener(1, 2)).called(2);
        },
      );

      test(
        'if a listener removes another provider.listen, the removed listener is not called',
        () {
          final dep = settableProvider((ref) => 0);
          final container = ProviderContainer.test();

          final listener = Listener<int>();
          final listener2 = Listener<int>();

          final provider = Provider((ref) {
            ProviderSubscription<int>? a;
            ref.listen<int>(dep, (prev, value) {
              listener(prev, value);
              a?.close();
              a = null;
            });

            a = ref.listen<int>(dep, listener2.call);
          });
          container.listen(provider, (prev, value) {});

          verifyZeroInteractions(listener);
          verifyZeroInteractions(listener2);

          container.read(dep.notifier).state++;

          verifyOnly(listener, listener(0, 1));
          verifyZeroInteractions(listener2);

          container.read(dep.notifier).state++;

          verify(listener(1, 2)).called(1);
          verifyNoMoreInteractions(listener2);
        },
      );

      test(
        'if a listener adds a provider.listen, the new listener is not called immediately',
        () {
          final dep = settableProvider((ref) => 0);
          final container = ProviderContainer.test();

          final listener = Listener<int>();

          final provider = Provider((ref) {
            ref.listen<int>(dep, (prev, value) {
              listener(prev, value);
              ref.listen<int>(dep, listener.call);
            });
          });
          container.listen(provider, (prev, value) {});

          verifyZeroInteractions(listener);

          container.read(dep.notifier).state++;

          verify(listener(0, 1)).called(1);

          container.read(dep.notifier).state++;

          verify(listener(1, 2)).called(2);
        },
      );

      group('fireImmediately', () {
        test(
          'when no onError is specified, fallbacks to handleUncaughtError',
          () {
            final errors = <Object>[];
            final container = runZonedGuarded(
              ProviderContainer.test,
              (err, stack) => errors.add(err),
            )!;
            final dep = Provider<int>((ref) => throw UnimplementedError());
            final listener = Listener<int>();

            container.listen(dep, listener.call, fireImmediately: true);

            verifyZeroInteractions(listener);
            expect(errors, [isUnimplementedError]);
          },
        );

        test(
          'when no onError is specified on selectors, fallbacks to handleUncaughtError',
          () {
            final errors = <Object>[];
            final container = runZonedGuarded(
              ProviderContainer.test,
              (err, stack) => errors.add(err),
            )!;
            final dep = Provider<int>((ref) => throw UnimplementedError());
            final listener = Listener<int>();

            container.listen(
              dep.select((value) => value),
              listener.call,
              fireImmediately: true,
            );

            verifyZeroInteractions(listener);
            expect(errors, [isUnimplementedError]);
          },
        );

        test('on provider that threw, fireImmediately calls onError', () {
          final container = ProviderContainer.test();
          final provider = Provider<int>((ref) => throw UnimplementedError());
          final listener = Listener<int>();
          final errorListener = ErrorListener();

          container.listen(
            provider,
            listener.call,
            onError: errorListener.call,
            fireImmediately: true,
          );

          verifyZeroInteractions(listener);
          verifyOnly(
            errorListener,
            errorListener(isUnimplementedError, argThat(isNotNull)),
          );
        });

        test('supports selectors', () {
          final container = ProviderContainer.test();
          final provider = settableProvider<int>((ref) => 0);
          final listener = Listener<bool>();
          final listener2 = Listener<bool>();

          container.listen(
            provider.select((v) => v.isEven),
            listener.call,
            fireImmediately: true,
          );
          container.listen(provider.select((v) => v.isEven), listener2.call);

          verifyOnly(listener, listener(null, true));
          verifyZeroInteractions(listener2);

          container.read(provider.notifier).state = 21;

          verifyOnly(listener, listener(true, false));
          verifyOnly(listener2, listener2(true, false));
        });

        test('passing fireImmediately: false skips the initial value', () {
          final provider = settableProvider((ref) => 0);
          final listener = Listener<int>();

          final container = ProviderContainer.test();

          container.listen<int>(provider, listener.call);

          verifyZeroInteractions(listener);
        });

        test(
          'correctly listens to the provider if selector onError listener throws',
          () async {
            final dep = settableProvider<int>((ref) => 0);
            final provider = Provider<int>((ref) {
              if (ref.watch(dep) == 0) {
                throw UnimplementedError();
              }
              return ref.watch(dep);
            });
            final listener = Listener<int>();
            final errorListener = ErrorListener();
            var isFirstCall = true;

            final errors = <Object>[];
            final container = runZonedGuarded(
              ProviderContainer.test,
              (err, stack) => errors.add(err),
            )!;

            final sub = container.listen<int>(
              provider.select((value) => value),
              listener.call,
              onError: (err, stack) {
                errorListener(err, stack);
                if (isFirstCall) {
                  isFirstCall = false;
                  throw StateError('Some error');
                }
              },
              fireImmediately: true,
            );

            container.listen(
              provider,
              (prev, value) {},
              onError: (err, stack) {},
            );

            expect(sub, isNotNull);
            verifyZeroInteractions(listener);
            verifyOnly(
              errorListener,
              errorListener(argThat(isUnimplementedError), argThat(isNotNull)),
            );
            expect(errors, [isStateError]);

            container.read(dep.notifier).state++;
            await container.pump();

            verifyNoMoreInteractions(errorListener);
            verifyOnly(listener, listener(null, 1));
          },
        );

        test(
          'correctly listens to the provider if normal onError listener throws',
          () async {
            final dep = settableProvider<int>((ref) => 0);
            final provider = Provider<int>((ref) {
              if (ref.watch(dep) == 0) {
                throw UnimplementedError();
              }
              return ref.watch(dep);
            });
            final listener = Listener<int>();
            final errorListener = ErrorListener();
            var isFirstCall = true;

            final errors = <Object>[];
            final container = runZonedGuarded(
              ProviderContainer.test,
              (err, stack) => errors.add(err),
            )!;

            final sub = container.listen<int>(
              provider,
              listener.call,
              onError: (err, stack) {
                errorListener(err, stack);
                if (isFirstCall) {
                  isFirstCall = false;
                  throw StateError('Some error');
                }
              },
              fireImmediately: true,
            );

            container.listen(provider, (prev, value) {});

            expect(sub, isNotNull);
            verifyZeroInteractions(listener);
            verifyOnly(
              errorListener,
              errorListener(argThat(isUnimplementedError), argThat(isNotNull)),
            );
            expect(errors, [isStateError]);

            container.read(dep.notifier).state++;
            await container.pump();

            verifyNoMoreInteractions(errorListener);
            verifyOnly(listener, listener(null, 1));
          },
        );

        test(
          'correctly listens to the provider if selector listener throws',
          () {
            final provider = settableProvider((ref) => 0);
            final listener = Listener<int>();
            var isFirstCall = true;

            final errors = <Object>[];
            final container = runZonedGuarded(
              ProviderContainer.test,
              (err, stack) => errors.add(err),
            )!;

            final sub = container.listen<int>(
              provider.select((value) => value),
              (prev, value) {
                listener(prev, value);
                if (isFirstCall) {
                  isFirstCall = false;
                  throw StateError('Some error');
                }
              },
              fireImmediately: true,
            );

            expect(sub, isNotNull);
            verifyOnly(listener, listener(null, 0));
            expect(errors, [isStateError]);

            container.read(provider.notifier).state++;

            verifyOnly(listener, listener(0, 1));
          },
        );

        test('correctly listens to the provider if normal listener throws', () {
          final provider = settableProvider((ref) => 0);
          final listener = Listener<int>();
          var isFirstCall = true;

          final errors = <Object>[];
          final container = runZonedGuarded(
            ProviderContainer.test,
            (err, stack) => errors.add(err),
          )!;

          final sub = container.listen<int>(provider, (prev, notifier) {
            listener(prev, notifier);
            if (isFirstCall) {
              isFirstCall = false;
              throw StateError('Some error');
            }
          }, fireImmediately: true);

          expect(sub, isNotNull);
          verifyOnly(listener, listener(null, 0));
          expect(errors, [isStateError]);

          container.read(provider.notifier).state++;

          verifyOnly(listener, listener(0, 1));
        });
      });

      test('.read on closed subscription throws', () {
        final provider = settableProvider<int>((_) => 0);
        final container = ProviderContainer.test();
        final listener = Listener<int>();

        final sub = container.listen(
          provider,
          listener.call,
          fireImmediately: true,
        );

        verify(listener(null, 0)).called(1);
        verifyNoMoreInteractions(listener);

        sub.close();
        container.read(provider.notifier).state++;

        expect(sub.read, throwsStateError);

        verifyNoMoreInteractions(listener);
      });

      test('.read on closed selector subscription throws', () {
        final provider = settableProvider<int>((_) => 0);
        final container = ProviderContainer.test();
        final listener = Listener<int>();

        final sub = container.listen(
          provider.select((value) => value * 2),
          listener.call,
          fireImmediately: true,
        );

        verify(listener(null, 0)).called(1);
        verifyNoMoreInteractions(listener);

        sub.close();
        container.read(provider.notifier).state++;

        expect(sub.read, throwsStateError);
        verifyNoMoreInteractions(listener);
      });

      test("doesn't trow when creating a provider that failed", () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) {
          throw Error();
        });

        final sub = container.listen(provider, (_, _) {});

        expect(sub, isA<ProviderSubscription<Object?>>());
      });

      test('selectors can close listeners', () {
        final container = ProviderContainer.test();
        final provider = settableProvider<int>((ref) => 0);

        expect(
          container.readProviderElement(provider).hasNonWeakListeners,
          false,
        );

        final sub = container.listen<bool>(
          provider.select((count) => count.isEven),
          (prev, isEven) {},
        );

        expect(
          container.readProviderElement(provider).hasNonWeakListeners,
          true,
        );

        sub.close();

        expect(
          container.readProviderElement(provider).hasNonWeakListeners,
          false,
        );
      });

      test('can watch selectors', () async {
        final container = ProviderContainer.test();
        final provider = settableProvider<int>((ref) => 0);
        final isAdultSelector = Selector<int, bool>(false, (c) => c >= 18);
        final isAdultListener = Listener<bool>();

        final controller = container.read(provider.notifier);
        container.listen<bool>(
          provider.select(isAdultSelector.call),
          isAdultListener.call,
          fireImmediately: true,
        );

        verifyOnly(isAdultSelector, isAdultSelector(0));
        verifyOnly(isAdultListener, isAdultListener(null, false));

        controller.state += 10;

        verifyOnly(isAdultSelector, isAdultSelector(10));
        verifyNoMoreInteractions(isAdultListener);

        controller.state += 10;

        verifyOnly(isAdultSelector, isAdultSelector(20));
        verifyOnly(isAdultListener, isAdultListener(false, true));

        controller.state += 10;

        verifyOnly(isAdultSelector, isAdultSelector(30));
        verifyNoMoreInteractions(isAdultListener);
      });

      test('calls immediately the listener with the current value', () {
        final provider = Provider((ref) => 0);
        final listener = Listener<int>();

        final container = ProviderContainer.test();

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, 0));
      });

      test('call listener when provider rebuilds', () async {
        final controller = StreamController<int>();
        addTearDown(controller.close);
        final container = ProviderContainer.test();

        final count = settableProvider((ref) => 0);
        final provider = Provider((ref) => ref.watch(count));

        container.listen<int>(
          provider,
          (prev, value) => controller.add(value),
          fireImmediately: true,
        );

        container.read(count.notifier).state++;

        await expectLater(controller.stream, emitsInOrder(<dynamic>[0, 1]));
      });

      test('call listener when provider emits an update', () async {
        final container = ProviderContainer.test();

        final count = settableProvider((ref) => 0);
        final listener = Listener<int>();

        container.listen<int>(count, listener.call);

        container.read(count.notifier).state++;

        verifyOnly(listener, listener(0, 1));

        container.read(count.notifier).state++;

        verifyOnly(listener, listener(1, 2));
      });

      test('supports selectors', () {
        final container = ProviderContainer.test();

        final count = settableProvider((ref) => 0);
        final listener = Listener<bool>();

        container.listen<bool>(
          count.select((value) => value.isEven),
          listener.call,
          fireImmediately: true,
        );

        verifyOnly(listener, listener(null, true));

        container.read(count.notifier).state = 2;

        verifyNoMoreInteractions(listener);

        container.read(count.notifier).state = 3;

        verifyOnly(listener, listener(true, false));
      });

      test('can downcast the listener value', () {
        final container = ProviderContainer.test();
        final provider = settableProvider<int>((ref) => 0);
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
          final provider = settableProvider((ref) => 0);
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
          final provider = settableProvider((ref) => 0);
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

      group('didChange', () {
        test('is called synchronously on direct provider change', () {
          final container = ProviderContainer.test();
          final didChange = Listener<int>();
          final provider = NotifierProvider<Counter, int>(Counter.new);

          container.listen(provider, didChange.call);
          final counter = container.read(provider.notifier);

          verifyZeroInteractions(didChange);

          counter.increment();

          verifyOnly(didChange, didChange(0, 1));
        });

        test('is called at most once per read for computed providers', () {
          final container = ProviderContainer.test();
          final didChange = Listener<int>();
          final provider = NotifierProvider<Counter, int>(Counter.new);
          final computed = Provider((ref) => ref.watch(provider));

          container.listen(computed, didChange.call);
          final counter = container.read(provider.notifier);

          verifyZeroInteractions(didChange);

          counter.increment();
          counter.increment();
          counter.increment();

          container.read(computed);

          verifyOnly(didChange, didChange(0, 3));
        });

        test('are all executed after one read call', () {
          final container = ProviderContainer.test();
          final didChange = Listener<int>();
          final provider = NotifierProvider<Counter, int>(Counter.new);
          final didChange2 = Listener<int>();

          container.listen(provider, didChange.call);
          container.listen(provider, didChange2.call);
          final counter = container.read(provider.notifier);

          counter.increment();

          verifyOnly(didChange, didChange(0, 1));
          verifyOnly(didChange2, didChange2(0, 1));
        });

        test('is guarded', () {
          final didChange = Listener<int>();
          final errors = <Object>[];
          final container = runZonedGuarded(
            ProviderContainer.test,
            (err, stack) => errors.add(err),
          )!;
          final provider = NotifierProvider<Counter, int>(Counter.new);
          final didChange2 = Listener<int>();
          when(didChange(any, any)).thenThrow(42);
          when(didChange2(any, any)).thenThrow(21);

          container.listen(provider, didChange.call);
          container.listen(provider, didChange2.call);
          final counter = container.read(provider.notifier);

          counter.increment();

          expect(errors, unorderedEquals(<Object>[42, 21]));
          verifyOnly(didChange, didChange(0, 1));
          verifyOnly(didChange2, didChange2(0, 1));
        });
      });

      test('throws if specifying both weak and fireImmediately', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);

        expect(
          () => container.listen(
            provider,
            (previous, value) {},
            weak: true,
            fireImmediately: true,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('allProviders', () {
      test('.allOf returns active providers of a family', () async {
        final family = Provider.autoDispose.family<int, int>((ref, arg) => arg);
        final otherFamily = Provider.autoDispose.family<int, int>(
          (ref, arg) => arg,
        );
        final container = ProviderContainer.test();

        final sub0 = container.listen(family(0), (_, _) {});
        final sub1 = container.listen(family(1), (_, _) {});
        final otherSub = container.listen(otherFamily(2), (_, _) {});

        expect(
          container.allProviders(family: family),
          unorderedEquals([
            providerReferences(family(0), container),
            providerReferences(family(1), container),
          ]),
        );

        sub0.close();
        await container.pump();

        expect(
          container.allProviders(family: family),
          unorderedEquals([providerReferences(family(1), container)]),
        );

        sub1.close();
        otherSub.close();
        await container.pump();

        expect(container.allProviders(family: family), isEmpty);
      });

      test(
        '.allOf includes active providers from parent containers too',
        () async {
          final family = Provider.autoDispose.family<int, int>(
            (ref, arg) => arg,
            dependencies: [],
          );
          final unrelated = Provider((ref) => 0);
          final root = ProviderContainer.test();
          final container = ProviderContainer.test(
            parent: root,
            overrides: [unrelated, family(2).overrideWithValue(42)],
          );

          container.listen(family(1), (_, _) {});
          root.listen(family(0), (_, _) {});

          root.listen(family(2), (_, _) {});
          container.listen(family(2), (_, _) {});

          expect(
            container.allProviders(family: family),
            unorderedEquals([
              providerReferences(family(0), root),
              providerReferences(family(1), root),
              providerReferences(family(2), root),
              providerReferences(family(2), container),
            ]),
          );
        },
      );

      test('returns all active providers', () async {
        final provider = Provider.autoDispose((ref) => 0);
        final family = Provider.autoDispose.family<int, int>((ref, arg) => arg);
        final otherFamily = Provider.autoDispose.family<int, int>(
          (ref, arg) => arg,
        );
        final container = ProviderContainer.test();

        final providerSub = container.listen(provider, (_, _) {});
        final familySub0 = container.listen(family(0), (_, _) {});
        final familySub1 = container.listen(family(1), (_, _) {});
        final otherFamilySub = container.listen(otherFamily(2), (_, _) {});

        expect(
          container.allProviders(),
          unorderedEquals([
            providerReferences(provider, container),
            providerReferences(family(0), container),
            providerReferences(family(1), container),
            providerReferences(otherFamily(2), container),
          ]),
        );

        providerSub.close();
        familySub0.close();
        familySub1.close();
        otherFamilySub.close();
        await container.pump();

        expect(container.allProviders(), isEmpty);
      });

      test('throws if new providers are registered while iterating', () {
        final provider = Provider((ref) => 0);
        final newProvider = Provider((ref) => 1);
        final container = ProviderContainer.test();

        container.listen(provider, (_, _) {});

        expect(() {
          for (final _ in container.allProviders()) {
            container.listen(newProvider, (_, _) {});
          }
        }, throwsA(isA<ConcurrentModificationError>()));
      });

      test(
        'with family specified, only new providers from that family throw',
        () {
          final family = Provider.family<int, int>((ref, arg) => arg);
          final otherFamily = Provider.family<int, int>((ref, arg) => arg);
          final container = ProviderContainer.test();

          container.listen(family(0), (_, _) {});

          expect(() {
            for (final _ in container.allProviders(family: family)) {
              container.listen(otherFamily(0), (_, _) {});
            }
          }, returnsNormally);

          expect(() {
            for (final _ in container.allProviders(family: family)) {
              container.listen(family(1), (_, _) {});
            }
          }, throwsA(isA<ConcurrentModificationError>()));
        },
      );

      test('includes active providers from parent containers too', () {
        final provider = Provider((ref) => 0);
        final family = Provider.autoDispose.family<int, int>(
          (ref, arg) => arg,
          dependencies: [],
        );
        final unrelated = Provider((ref) => 42);
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [unrelated, family(2).overrideWithValue(42)],
        );

        root.listen(provider, (_, _) {});
        container.listen(family(1), (_, _) {});
        root.listen(family(2), (_, _) {});
        container.listen(family(2), (_, _) {});

        expect(
          container.allProviders(),
          unorderedEquals([
            providerReferences(provider, root),
            providerReferences(family(1), root),
            providerReferences(family(2), root),
            providerReferences(family(2), container),
          ]),
        );
      });
    });

    group('scoping', () {
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
        final container = ProviderContainer.test(
          parent: root,
          overrides: [a, b],
        );

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
          final child = ProviderContainer.test(
            parent: mid,
            overrides: [override2],
          );

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
          overrides: [
            b.overrideWith((ref, value) => ref.watch(another) + value),
          ],
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
          final provider = Provider.autoDispose(
            (ref) => 0,
            dependencies: const [],
          );

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
          final provider = Provider.autoDispose(
            (ref) => 0,
            dependencies: const [],
          );

          final root = ProviderContainer.test();
          final mid = ProviderContainer.test(
            parent: root,
            overrides: [provider],
          );
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
          final mid = ProviderContainer.test(
            parent: root,
            overrides: [provider],
          );
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

      group('non-family providers', () {
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
            final mid = ProviderContainer.test(
              parent: root,
              overrides: [provider],
            );
            final container = ProviderContainer.test(parent: mid);

            expect(mid.read(provider), 42);
            expect(callCount, 1);

            expect(container.read(provider), 42);
            expect(callCount, 1);

            expect(root.getAllProviderElements(), isEmpty);
          },
        );
      });

      group('families', () {
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

        test(
          'can override a family with a reference to the provider directly',
          () {
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
          },
        );

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

      group('auto-scoping via dependencies', () {
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
          final provider = Provider(name: 'provider', dependencies: [dep], (
            ref,
          ) {
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
            final dep = Provider(
              (ref) => 0,
              name: 'dep',
              dependencies: const [],
            );
            var buildCount = 0;
            final provider = Provider(dependencies: [dep], name: 'provider', (
              ref,
            ) {
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
          final provider = Provider(dependencies: [dep3], name: 'provider', (
            ref,
          ) {
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
            final dep = Provider(
              (ref) => 0,
              name: 'dep',
              dependencies: const [],
            );
            final dep2 = Provider(
              (ref) => 0,
              name: 'dep2',
              dependencies: const [],
            );
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
            final dep = Provider(
              (ref) => 0,
              name: 'dep',
              dependencies: const [],
            );
            final dep2 = Provider(
              (ref) => 0,
              name: 'dep2',
              dependencies: const [],
            );
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
            final provider = Provider(
              (ref) => ref.watch(dep),
              dependencies: [dep],
            );
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
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider,
              ),
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
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider,
              ),
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                family(21),
              ),
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
          final provider = Provider(
            (ref) => ref.watch(dep),
            dependencies: [dep],
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
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider,
              ),
              isA<ProviderElement>().having((e) => e.origin, 'origin', dep),
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                family(21),
              ),
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
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider,
              ),
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
    });

    group('getAllProviderElementsInOrder', () {
      //  A
      //  |
      //  B
      //  |
      //  C
      test('linear graph', () {
        final a = Provider<A>((ref) => A());

        final b = Provider<B>((ref) {
          ref.watch(a);
          return B();
        });
        final c = Provider<C>((ref) {
          ref.watch(b);
          return C();
        });

        final perm = Permutations(3, [a, b, c]);
        for (final permutation in perm()) {
          final container = ProviderContainer.test();
          permutation.forEach(container.read);
          expect(compute(container), [a, b, c]);
        }
      });

      //     A
      //   /   \
      //  B     C
      //    \  /
      //      D
      test('diamond graph', () {
        final a = Provider<A>((ref) => A());

        final b = Provider<B>((ref) {
          ref.watch(a);
          return B();
        });
        final c = Provider<C>((ref) {
          ref.watch(a);
          return C();
        });

        final d = Provider<D>((ref) {
          ref.watch(b);
          ref.watch(c);
          return D();
        });

        final perm = Permutations(4, [a, b, c, d]);
        for (final permutation in perm()) {
          final container = ProviderContainer.test();
          permutation.forEach(container.read);
          expect(
            compute(container),
            anyOf([
              [a, b, c, d],
              [a, c, b, d],
            ]),
          );
        }
      });

      //  A#1
      //  |
      //  B#2
      test('linear across two containers', () {
        final a = Provider<A>((ref) => A());

        final b = Provider<B>((ref) {
          ref.watch(a);
          return B();
        }, dependencies: const []);

        final parent = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: parent,
          overrides: [b],
        );
        container.read(b);

        expect(compute(container), [b]);
        expect(compute(parent), [a]);
      });

      //  A#1  B#2
      //    \  /
      //     C#2
      test('branching across two containers', () {
        final a = Provider<A>((ref) => A());

        final b = Provider<B>((ref) => B(), dependencies: const []);

        final c = Provider<C>((ref) {
          ref.watch(a);
          ref.watch(b);
          return C();
        }, dependencies: [b]);

        final parent = ProviderContainer.test();

        final perm = Permutations(2, [b, c]);
        for (final permutation in perm()) {
          final container = ProviderContainer.test(
            parent: parent,
            overrides: permutation,
          );
          permutation.forEach(container.read);

          expect(compute(container), [b, c]);
        }
      });

      //       A
      //     /   \
      //    B  <  C
      //   / \    / \
      //  D > E <F < G
      test('5', () {
        final a = Provider<A>((ref) => A());

        final b = Provider<B>((ref) {
          ref.watch(a);
          return B();
        });

        final e = Provider<E>((ref) {
          ref.watch(b);
          return E();
        });
        final d = Provider<D>((ref) {
          ref.watch(b);
          ref.watch(e);
          return D();
        });

        final c = Provider<C>((ref) {
          ref.watch(a);
          ref.watch(b);
          return C();
        });

        final f = Provider<F>((ref) {
          ref.watch(c);
          ref.watch(e);
          return F();
        });
        final g = Provider<G>((ref) {
          ref.watch(c);
          ref.watch(f);
          return G();
        });

        final perm = Permutations(7, [a, b, c, d, e, f, g]);
        for (final permutation in perm()) {
          final container = ProviderContainer.test();
          permutation.forEach(container.read);
          expect(
            compute(container),
            anyOf([
              [a, b, c, e, d, f, g],
              [a, b, c, e, f, g, d],
              [a, b, c, e, f, d, g],
              [a, b, e, c, d, f, g],
              [a, b, e, c, f, g, d],
              [a, b, e, c, f, d, g],
              [a, b, e, d, c, f, g],
            ]),
          );
        }
      });

      //     A
      //   /  |
      //  B   |
      //  | \ |
      //  |   C
      //   \ /
      //    D
      test('linked diamond graph', () {
        final a = Provider<A>((ref) => A());

        final b = Provider<B>((ref) {
          ref.watch(a);
          return B();
        });
        final c = Provider<C>((ref) {
          ref.watch(a);
          ref.watch(b);
          return C();
        });

        final d = Provider<D>((ref) {
          ref.watch(b);
          ref.watch(c);
          return D();
        });

        final perm = Permutations(4, [a, b, c, d]);
        for (final permutation in perm()) {
          final container = ProviderContainer.test();
          permutation.forEach(container.read);
          expect(compute(container), [a, b, c, d]);
        }
      });

      //  A
      //  |
      //  B
      //  | \
      //  |  C
      //  | /
      //   D
      test('graph4', () {
        final a = Provider<A>((ref) => A());

        final b = Provider<B>((ref) {
          ref.watch(a);
          return B();
        });
        final c = Provider<C>((ref) {
          ref.watch(b);
          return C();
        });

        final d = Provider<D>((ref) {
          ref.watch(b);
          ref.watch(c);
          return D();
        });

        final perm = Permutations(4, [a, b, c, d]);
        for (final permutation in perm()) {
          final container = ProviderContainer.test();
          permutation.forEach(container.read);
          expect(compute(container), [a, b, c, d]);
        }
      });

      //     A
      //   /   \
      //  B     C
      //  |     |
      //  D     |
      //   \   /
      //     E
      test('graph6', () {
        final a = Provider<A>((ref) => A());

        final b = Provider<B>((ref) {
          ref.watch(a);
          return B();
        });
        final c = Provider<C>((ref) {
          ref.watch(a);
          return C();
        });

        final d = Provider<D>((ref) {
          ref.watch(b);
          return D();
        });

        final e = Provider<E>((ref) {
          ref.watch(d);
          ref.watch(c);
          return E();
        });

        final perm = Permutations(5, [a, b, c, d, e]);
        for (final permutation in perm()) {
          final container = ProviderContainer.test();
          permutation.forEach(container.read);
          expect(
            compute(container),
            anyOf([
              [a, b, d, c, e],
              [a, b, c, d, e],
              [a, c, b, d, e],
            ]),
          );
        }
      });

      test('list scoped providers that depends on nothing', () {
        final scopedProvider = Provider<int>(
          (ref) => 0,
          dependencies: const [],
        );
        final parent = ProviderContainer.test();
        final child = ProviderContainer.test(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElementsInOrder().single,
          isA<$ProviderElement<Object?>>().having(
            (e) => e.origin,
            'origin',
            scopedProvider,
          ),
        );
      });

      test(
        'list scoped providers that depends on providers from another container',
        () {
          final dependency = Provider((ref) => 0);
          final scopedProvider = Provider<int>(
            (ref) => ref.watch(dependency),
            dependencies: const [],
          );
          final parent = ProviderContainer.test();
          final child = ProviderContainer.test(
            parent: parent,
            overrides: [scopedProvider],
          );

          child.read(scopedProvider);

          expect(
            child.getAllProviderElementsInOrder().single,
            isA<$ProviderElement<Object?>>().having(
              (e) => e.origin,
              'origin',
              scopedProvider,
            ),
          );
        },
      );
    });

    group('read', () {
      test(
        'does not re-initialize a family if read by a child container after the provider was initialized',
        () {
          final root = ProviderContainer.test();
          // the child must be created before the provider is initialized
          final child = ProviderContainer.test(parent: root);

          var buildCount = 0;
          final provider = Provider.family<int, int>((ref, param) {
            buildCount++;
            return 0;
          });

          expect(root.read(provider(0)), 0);

          expect(buildCount, 1);

          expect(child.read(provider(0)), 0);

          expect(buildCount, 1);
        },
      );

      test(
        'does not re-initialize a scoped family if read by a child container after the provider was initialized',
        () {
          var buildCount = 0;
          final provider = Provider.family<int, int>((ref, param) {
            buildCount++;
            return 42;
          }, dependencies: const []);

          final root = ProviderContainer.test();
          final scope = ProviderContainer.test(
            parent: root,
            overrides: [provider],
          );
          // the child must be created before the provider is initialized
          final child = ProviderContainer.test(parent: scope);

          expect(scope.read(provider(0)), 42);

          expect(root.getAllProviderElements(), isEmpty);
          expect(buildCount, 1);

          expect(child.read(provider(0)), 42);

          expect(root.getAllProviderElements(), isEmpty);
          expect(buildCount, 1);
        },
      );

      group('validate that properties respect `dependencies`', () {
        test(
          'on reading an element, asserts that dependencies are respected',
          () {
            final dep = Provider((ref) => 0, dependencies: const []);
            final provider = Provider((ref) => ref.watch(dep));

            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [dep.overrideWithValue(42)],
            );

            expect(
              () => container.read(provider),
              throwsProviderException(isStateError),
            );
          },
        );

        test(
          'on reading an element, asserts that transitive dependencies are also respected',
          () {
            final transitiveDep = Provider((ref) => 0, dependencies: const []);
            final dep = Provider((ref) => ref.watch(transitiveDep));
            final provider = Provider((ref) => ref.watch(dep));

            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [transitiveDep.overrideWithValue(42)],
            );

            expect(() => container.read(provider), throwsA(anything));
          },
        );
      });

      test(
        'does not re-initialize a provider if read by a child container after the provider was initialized',
        () {
          final root = ProviderContainer.test();
          // the child must be created before the provider is initialized
          final child = ProviderContainer.test(parent: root);

          var buildCount = 0;
          final provider = Provider((ref) {
            buildCount++;
            return 0;
          });

          expect(root.read(provider), 0);

          expect(buildCount, 1);

          expect(child.read(provider), 0);

          expect(buildCount, 1);
        },
      );

      test('builds providers at most once per container', () {
        var result = 42;
        final container = ProviderContainer.test();
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

        final container2 = ProviderContainer.test();

        result = 21;
        expect(container2.read(provider), 21);
        expect(callCount, 2);
        expect(container2.read(provider), 21);
        expect(callCount, 2);
        expect(container.read(provider), 42);
        expect(callCount, 2);
      });

      test(
        'ProviderContainer.read(MyProvider.autoDispose) disposes the provider if not listened to',
        () async {
          final container = ProviderContainer.test();
          var disposed = false;
          final provider = settableProvider((ref) {
            ref.onDispose(() => disposed = true);
            return 0;
          }, isAutoDispose: true);

          container.read(provider.notifier);

          expect(disposed, false);

          await container.pump();

          expect(disposed, true);
        },
      );

      test('Owner.read', () {
        final provider = Provider((ref) => 0);
        final provider2 = Provider((ref) => 1);
        final container = ProviderContainer.test();

        final value1 = container.read(provider);
        final value2 = container.read(provider);
        final value21 = container.read(provider2);
        final value22 = container.read(provider2);

        expect(value1, value2);
        expect(value1, 0);
        expect(value21, value22);
        expect(value21, isNot(value1));
        expect(value21, 1);
      });

      test('Read creates the value only once', () {
        final container = ProviderContainer.test();
        var callCount = 0;
        final provider = Provider((ref) {
          callCount++;
          return 42;
        });

        expect(callCount, 0);
        expect(container.read(provider), 42);
        expect(callCount, 1);

        expect(container.read(provider), 42);
        expect(callCount, 1);
      });
    });

    group('debugReassemble', () {
      test(
        'reload providers if the debugGetCreateSourceHash of a provider returns a different value',
        skip: 'Needs overloading the method',
        () {
          final noDebugGetCreateSourceHashBuild = OnBuildMock();
          final noDebugGetCreateSourceHash = Provider((ref) {
            noDebugGetCreateSourceHashBuild();
            return 0;
          });
          final constantHashBuild = OnBuildMock();
          final constantHash = Provider.internal(
            isAutoDispose: false,
            from: null,
            argument: null,
            name: null,
            dependencies: null,
            $allTransitiveDependencies: null,
            retry: null,
            (ref) {
              constantHashBuild();
              return 0;
            },
          );
          var hashResult = '42';
          final changingHashBuild = OnBuildMock();
          final changingHash = Provider.internal(
            isAutoDispose: false,
            from: null,
            argument: null,
            name: null,
            dependencies: null,
            retry: null,
            $allTransitiveDependencies: null,
            (ref) {
              changingHashBuild();
              return 0;
            },
          );
          final container = ProviderContainer.test();

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
        },
      );
    });

    group('getAllProviderElements', () {
      test('list scoped providers that depends on nothing', () {
        final scopedProvider = Provider<int>(
          (ref) => 0,
          dependencies: const [],
        );
        final parent = ProviderContainer.test();
        final child = ProviderContainer.test(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElements().single,
          isA<$ProviderElement<Object?>>().having(
            (e) => e.origin,
            'origin',
            scopedProvider,
          ),
        );
      });

      test(
        'list scoped providers that depends on providers from another container',
        () {
          final dependency = Provider((ref) => 0);
          final scopedProvider = Provider<int>(
            (ref) => ref.watch(dependency),
            dependencies: const [],
          );
          final parent = ProviderContainer.test();
          final child = ProviderContainer.test(
            parent: parent,
            overrides: [scopedProvider],
          );

          child.read(scopedProvider);

          expect(
            child.getAllProviderElements().single,
            isA<$ProviderElement<Object?>>().having(
              (e) => e.origin,
              'origin',
              scopedProvider,
            ),
          );
        },
      );

      test(
        'list only elements associated with the container (ignoring inherited and descendant elements)',
        () {
          final provider = Provider((ref) => 0);
          final provider2 = Provider((ref) => 0, dependencies: const []);
          final provider3 = Provider((ref) => 0, dependencies: const []);
          final root = ProviderContainer.test();
          final mid = ProviderContainer.test(
            parent: root,
            overrides: [provider2],
          );
          final leaf = ProviderContainer.test(
            parent: mid,
            overrides: [provider3],
          );

          leaf.read(provider);
          leaf.read(provider2);
          leaf.read(provider3);

          expect(
            root.getAllProviderElements().single,
            isA<$ProviderElement<Object?>>().having(
              (e) => e.provider,
              'provider',
              provider,
            ),
          );
          expect(
            mid.getAllProviderElements().single,
            isA<$ProviderElement<Object?>>().having(
              (e) => e.provider,
              'provider',
              provider2,
            ),
          );
          expect(
            leaf.getAllProviderElements().single,
            isA<$ProviderElement<Object?>>().having(
              (e) => e.provider,
              'provider',
              provider3,
            ),
          );
        },
      );

      test('list the currently mounted providers', () async {
        final container = ProviderContainer.test();
        final unrelated = Provider((_) => 42);
        final provider = Provider.autoDispose((ref) => 0);

        expect(container.read(unrelated), 42);
        var sub = container.listen(provider, (_, _) {});

        expect(
          container.getAllProviderElements().map((e) => e.origin),
          unorderedEquals([provider, unrelated]),
        );

        sub.close();
        await container.pump();

        expect(container.getAllProviderElements(), [isA<ProviderElement>()]);

        sub = container.listen(provider, (_, _) {});

        expect(
          container.getAllProviderElements().map((e) => e.origin),
          unorderedEquals([provider, unrelated]),
        );
      });
    });

    group('debugChildren', () {
      test('ProviderContainer.children', () {
        final root = ProviderContainer.test();

        expect(root.debugChildren, isEmpty);

        final mid = ProviderContainer.test(parent: root);

        expect(root.debugChildren, containsAll(<ProviderContainer>[mid]));
        expect(mid.debugChildren, isEmpty);

        final mid2 = ProviderContainer.test(parent: root);

        expect(root.debugChildren, containsAll(<ProviderContainer>[mid, mid2]));
        expect(mid.debugChildren, isEmpty);
        expect(mid2.debugChildren, isEmpty);

        final leaf = ProviderContainer.test(parent: mid);

        expect(root.debugChildren, containsAll(<ProviderContainer>[mid, mid2]));
        expect(mid.debugChildren, containsAll(<ProviderContainer>[leaf]));
        expect(mid2.debugChildren, isEmpty);
        expect(leaf.debugChildren, isEmpty);

        leaf.dispose();

        expect(root.debugChildren, containsAll(<ProviderContainer>[mid, mid2]));
        expect(mid.debugChildren, isEmpty);
        expect(mid2.debugChildren, isEmpty);

        mid.dispose();

        expect(root.debugChildren, containsAll(<ProviderContainer>[mid2]));
        expect(mid2.debugChildren, isEmpty);

        mid2.dispose();

        expect(root.debugChildren, isEmpty);

        root.dispose();
      });
    });

    group('refresh', () {
      test('still refresh providers on non-root containers', () {
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(parent: root);
        var callCount = 0;
        late Ref providerReference;
        var result = 0;
        final provider = Provider((ref) {
          callCount++;
          providerReference = ref;
          return result;
        });

        expect(root.read(provider), 0);
        expect(callCount, 1);
        expect(providerReference.container, root);

        result = 1;

        expect(container.refresh(provider), 1);
        expect(container.read(provider), 1);
        expect(callCount, 2);
        expect(providerReference.container, root);
      });

      test(
        'immediately creates a new value, even if no changes are pending',
        () async {
          var future = Future.value(42);
          var callCount = 0;
          final provider = FutureProvider((ref) {
            callCount++;
            return future;
          });
          final container = ProviderContainer.test();

          await expectLater(container.read(provider.future), completion(42));

          expect(callCount, 1);
          await expectLater(
            container.read(provider),
            const AsyncValue<int>.data(42),
          );

          future = Future.value(21);

          expect(
            container.refresh(provider),
            const AsyncLoading<int>().copyWithPrevious(
              const AsyncValue<int>.data(42),
            ),
          );
          expect(
            container.read(provider),
            const AsyncLoading<int>().copyWithPrevious(
              const AsyncValue<int>.data(42),
            ),
          );
          expect(callCount, 2);

          await expectLater(container.read(provider.future), completion(21));
          expect(callCount, 2);
        },
      );

      test('retrying an unmounted provider just mounts it', () async {
        var callCount = 0;
        final provider = FutureProvider((ref) {
          callCount++;
          return Future.value(42);
        });
        final container = ProviderContainer.test();

        expect(callCount, 0);
        expect(container.refresh(provider), const AsyncValue<int>.loading());
        expect(container.read(provider), const AsyncValue<int>.loading());
        expect(callCount, 1);
        await expectLater(container.read(provider.future), completion(42));
        expect(callCount, 1);
      });

      test(
        'refreshing a provider already marked as needing to update do not create the value twice',
        () async {
          var future = Future.value(42);
          var callCount = 0;
          final dep = settableProvider((_) => 0);
          final provider = FutureProvider((ref) {
            callCount++;
            ref.watch(dep);
            return future;
          });
          final container = ProviderContainer.test();

          container.refresh(provider);

          expect(callCount, 1);

          container.read(dep.notifier).state++;
          future = Future.value(21);

          expect(callCount, 1);
          container.refresh(provider);

          expect(callCount, 2);
          await expectLater(container.read(provider.future), completion(21));
          expect(callCount, 2);
        },
      );
    });
  });

  group('ProviderObserver', () {
    test('can have const constructors', () {
      final root = ProviderContainer.test(observers: [const ConstObserver()]);

      root.dispose();
    });

    group('didUpdateProvider', () {
      test(
        'after an error didUpdateProvider receives null as previous value ',
        () async {
          final observer = ObserverMock();
          final observer2 = ObserverMock();
          final container = ProviderContainer.test(
            observers: [observer, observer2],
          );
          final dep = settableProvider((ref) => 0);
          final provider = Provider((ref) {
            if (ref.watch(dep) == 0) {
              throw UnimplementedError();
            }
            return 0;
          });

          container.listen(provider, (_, _) {}, onError: (err, stack) {});

          clearInteractions(observer);
          clearInteractions(observer2);

          container.read(dep.notifier).state++;
          await container.pump();

          verifyInOrder([
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(
                  provider: provider,
                  container: container,
                ),
              ),
              null,
              0,
            ),
            observer2.didUpdateProvider(
              argThat(
                isProviderObserverContext(
                  provider: provider,
                  container: container,
                ),
              ),
              null,
              0,
            ),
          ]);
          verifyNever(observer.providerDidFail(any, any, any));
        },
      );

      test(
        'on scoped ProviderContainer, applies both child and ancestors observers',
        () {
          final provider = settableProvider((ref) => 0, dependencies: const []);
          final observer = ObserverMock('a');
          final observer2 = ObserverMock('b');
          final observer3 = ObserverMock('c');

          final root = ProviderContainer.test(observers: [observer]);
          final mid = ProviderContainer.test(
            parent: root,
            observers: [observer2],
          );
          final child = ProviderContainer.test(
            parent: mid,
            overrides: [
              provider.overrideWith(() => SettableNotifier((ref) => 42)),
            ],
            observers: [observer3],
          );

          expect(child.read(provider), 42);
          expect(mid.read(provider), 0);

          clearInteractions(observer3);
          clearInteractions(observer2);
          clearInteractions(observer);

          expect(child.read(provider.notifier).state++, 42);

          verify(
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
              43,
            ),
          ).called(1);
          verify(
            observer2.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
              43,
            ),
          ).called(1);
          verify(
            observer3.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
              43,
            ),
          ).called(1);

          mid.read(provider.notifier).state++;

          verify(
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: root),
              ),
              0,
              1,
            ),
          ).called(1);

          verifyNoMoreInteractions(observer3);
          verifyNoMoreInteractions(observer2);
          verifyNoMoreInteractions(observer);
        },
      );

      test('handles computed provider update', () async {
        final observer = ObserverMock();
        final container = ProviderContainer.test(observers: [observer]);
        final provider = NotifierProvider<Counter, int>(Counter.new);
        final computed = Provider((ref) => ref.watch(provider));

        container.listen(computed, (_, _) {});
        container.read(provider.notifier).increment();

        clearInteractions(observer);

        await container.pump();

        verify(
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: computed,
                container: container,
              ),
            ),
            0,
            1,
          ),
        ).called(1);
        verifyNever(observer.didUpdateProvider(any, any, any));
      });

      test('handles direct provider update', () {
        final observer = ObserverMock();
        final container = ProviderContainer.test(observers: [observer]);
        final provider = NotifierProvider<Counter, int>(Counter.new);

        final notifier = container.read(provider.notifier);
        clearInteractions(observer);

        notifier.increment();

        verifyOnly(
          observer,
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            1,
          ),
        ).called(1);
      });

      test('didUpdateProviders', () {
        final observer = ObserverMock('a');
        final observer2 = ObserverMock('b');
        final provider = NotifierProvider<Counter, int>(Counter.new);
        final container = ProviderContainer.test(
          overrides: [provider.overrideWith(Counter.new)],
          observers: [observer, observer2],
        );
        final listener = Listener<int>();

        container.listen(provider, listener.call, fireImmediately: true);
        final counter = container.read(provider.notifier);

        verify(listener(null, 0)).called(1);
        verifyNoMoreInteractions(listener);
        verifyInOrder([
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
          ),
          observer2.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
          ),
        ]);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);

        counter.increment();

        verifyInOrder([
          listener(0, 1),
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            1,
          ),
          observer2.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            1,
          ),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);
      });

      test('guards didUpdateProviders', () {
        final observer = ObserverMock();
        when(observer.didUpdateProvider(any, any, any)).thenThrow('error1');
        final observer2 = ObserverMock();
        when(observer2.didUpdateProvider(any, any, any)).thenThrow('error2');
        final observer3 = ObserverMock();
        final provider = NotifierProvider<Counter, int>(Counter.new);
        final errors = <Object>[];
        final container = runZonedGuarded(
          () => ProviderContainer.test(
            overrides: [provider.overrideWith(Counter.new)],
            observers: [observer, observer2, observer3],
          ),
          (err, stack) => errors.add(err),
        )!;

        final counter = container.read(provider.notifier);

        clearInteractions(observer);
        clearInteractions(observer2);
        clearInteractions(observer3);

        counter.increment();

        expect(errors, ['error1', 'error2']);
        verifyInOrder([
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            1,
          ),
          observer2.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            1,
          ),
          observer3.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            1,
          ),
        ]);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);
        verifyNoMoreInteractions(observer3);
      });

      test(
        "Computed don't call didUpdateProviders when value doesn't change",
        () async {
          final observer = ObserverMock();
          final provider = NotifierProvider<Counter, int>(Counter.new);
          final isNegative = Provider((ref) {
            return ref.watch(provider).isNegative;
          });
          final container = ProviderContainer.test(observers: [observer]);
          final isNegativeListener = Listener<bool>();

          container.listen(
            isNegative,
            isNegativeListener.call,
            fireImmediately: true,
          );

          final counter = container.read(provider.notifier);
          clearInteractions(observer);
          verifyOnly(isNegativeListener, isNegativeListener(null, false));

          counter.increment();
          await container.pump();

          verifyInOrder([
            observer.didDisposeProvider(
              argThat(
                isProviderObserverContext(
                  provider: isNegative,
                  container: container,
                ),
              ),
            ),
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(
                  provider: provider,
                  container: container,
                ),
              ),
              0,
              1,
            ),
          ]);
          verifyNever(observer.didUpdateProvider(any, any, any));

          counter.state = -10;
          await container.pump();

          verifyInOrder([
            observer.didDisposeProvider(
              argThat(
                isProviderObserverContext(
                  provider: isNegative,
                  container: container,
                ),
              ),
            ),
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(
                  provider: provider,
                  container: container,
                ),
              ),
              1,
              -10,
            ),
            isNegativeListener(false, true),
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(
                  provider: isNegative,
                  container: container,
                ),
              ),
              false,
              true,
            ),
          ]);
          verifyNever(observer.didUpdateProvider(any, any, any));
          verifyNoMoreInteractions(isNegativeListener);
        },
      );
    });

    group('providerDidFail', () {
      test(
        'on scoped ProviderContainer, applies both child and ancestors observers',
        () async {
          final dep = settableProvider((ref) => 0);
          final provider = settableProvider((ref) => 0, dependencies: const []);
          final observer = ObserverMock('a');
          final observer2 = ObserverMock('b');
          final observer3 = ObserverMock('c');

          final root = ProviderContainer.test(observers: [observer]);
          final mid = ProviderContainer.test(
            parent: root,
            observers: [observer2],
          );
          final child = ProviderContainer.test(
            parent: mid,
            overrides: [
              provider.overrideWith(
                () => SettableNotifier((ref) {
                  if (ref.watch(dep) != 0) {
                    Error.throwWithStackTrace('error', StackTrace.empty);
                  }
                  return 42;
                }),
              ),
            ],
            observers: [observer3],
          );

          child.listen(provider, (_, _) {}, onError: (_, _) {});

          expect(child.read(provider), 42);
          expect(mid.read(provider), 0);

          clearInteractions(observer3);
          clearInteractions(observer2);
          clearInteractions(observer);

          child.read(dep.notifier).state++;
          await child.pump();

          verifyInOrder([
            observer.didDisposeProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
            ),
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: dep, container: root),
              ),
              0,
              1,
            ),
            observer.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
              null,
            ),
            observer.providerDidFail(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              'error',
              StackTrace.empty,
            ),
          ]);
          verifyInOrder([
            observer2.didDisposeProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
            ),
            observer2.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
              null,
            ),
            observer2.providerDidFail(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              'error',
              StackTrace.empty,
            ),
          ]);
          verifyInOrder([
            observer3.didDisposeProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
            ),
            observer3.didUpdateProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
              null,
            ),
            observer3.providerDidFail(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              'error',
              StackTrace.empty,
            ),
          ]);
          verifyNever(observer3.didUpdateProvider(any, any, any));
          verifyNever(observer2.didUpdateProvider(any, any, any));
          verifyNever(observer.didUpdateProvider(any, any, any));
        },
      );

      test('is called when FutureProvider emits an error', () async {
        final observer = ObserverMock();
        final container = ProviderContainer.test(
          observers: [observer],
          retry: (_, _) => null,
        );
        final provider = FutureProvider(
          (ref) => Future<void>.error('error', StackTrace.empty),
        );

        container.listen(provider, (_, _) {});
        await container.read(provider.future).catchError((_) {});

        verifyInOrder([
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            const AsyncLoading<void>(),
          ),
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            const AsyncLoading<void>(),
            const AsyncError<void>('error', StackTrace.empty),
          ),
          observer.providerDidFail(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            'error',
            StackTrace.empty,
          ),
        ]);
      });

      test('is called when StreamProvider emits an error', () async {
        final observer = ObserverMock();
        final container = ProviderContainer.test(
          observers: [observer],
          retry: (_, _) => null,
        );
        final provider = StreamProvider(
          (ref) => Stream<void>.error('error', StackTrace.empty),
        );

        container.listen(provider, (_, _) {});
        await container.read(provider.future).catchError((_) {});

        verifyInOrder([
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            const AsyncLoading<void>(),
          ),
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            const AsyncLoading<void>(),
            const AsyncError<void>('error', StackTrace.empty),
          ),
          observer.providerDidFail(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            'error',
            StackTrace.empty,
          ),
        ]);
      });

      test('is called on uncaught error during first initialization', () {
        final observer = ObserverMock();
        final observer2 = ObserverMock();
        final container = ProviderContainer.test(
          observers: [observer, observer2],
        );
        final provider = Provider((ref) => throw UnimplementedError());

        expect(() => container.read(provider), throwsA(anything));

        verifyInOrder([
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            null,
          ),
          observer2.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            null,
          ),
          observer.providerDidFail(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            argThat(isUnimplementedError),
            argThat(isNotNull),
          ),
          observer2.providerDidFail(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            argThat(isUnimplementedError),
            argThat(isNotNull),
          ),
        ]);
        verifyNoMoreInteractions(observer);
      });

      test('is called on uncaught error after update ', () async {
        final observer = ObserverMock();
        final observer2 = ObserverMock();
        final container = ProviderContainer.test(
          observers: [observer, observer2],
        );
        final dep = settableProvider((ref) => 0);
        final provider = Provider((ref) {
          if (ref.watch(dep) != 0) {
            throw UnimplementedError();
          }
          return 0;
        });

        container.listen(provider, (_, _) {}, onError: (err, stack) {});

        clearInteractions(observer);
        clearInteractions(observer2);

        container.read(dep.notifier).state++;
        await container.pump();

        verifyInOrder([
          observer.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            null,
          ),
          observer2.didUpdateProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            0,
            null,
          ),
          observer.providerDidFail(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            argThat(isUnimplementedError),
            argThat(isNotNull),
          ),
          observer2.providerDidFail(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            argThat(isUnimplementedError),
            argThat(isNotNull),
          ),
        ]);
      });
    });

    group('didAddProvider', () {
      test('when throwing during creation, receives `null` as value', () {
        final observer = ObserverMock();
        final container = ProviderContainer.test(observers: [observer]);
        final provider = Provider((ref) => throw UnimplementedError());

        expect(() => container.read(provider), throwsA(anything));

        verify(
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            null,
          ),
        );
      });

      test(
        'on scoped ProviderContainer, applies both child and ancestors observers',
        () {
          final provider = Provider((ref) => 0, dependencies: const []);
          final observer = ObserverMock();
          final observer2 = ObserverMock();
          final observer3 = ObserverMock();
          final root = ProviderContainer.test(observers: [observer]);
          final mid = ProviderContainer.test(
            parent: root,
            observers: [observer2],
          );
          final child = ProviderContainer.test(
            parent: mid,
            overrides: [provider.overrideWithValue(42)],
            observers: [observer3],
          );

          expect(child.read(provider), 42);

          verifyInOrder([
            observer3.didAddProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
            ),
            observer2.didAddProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
            ),
            observer.didAddProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: child),
              ),
              42,
            ),
          ]);

          expect(mid.read(provider), 0);

          verify(
            observer.didAddProvider(
              argThat(
                isProviderObserverContext(provider: provider, container: root),
              ),
              0,
            ),
          ).called(1);

          verifyNoMoreInteractions(observer3);
          verifyNoMoreInteractions(observer2);
          verifyNoMoreInteractions(observer);
        },
      );

      test('works', () {
        final observer = ObserverMock();
        final observer2 = ObserverMock();
        final provider = Provider((_) => 42);
        final container = ProviderContainer.test(
          observers: [observer, observer2],
        );

        expect(container.read(provider), 42);
        verifyInOrder([
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            42,
          ),
          observer2.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            42,
          ),
        ]);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);
      });

      test('guards against exceptions', () {
        final observer = ObserverMock();
        when(observer.didAddProvider(any, any)).thenThrow('error1');
        final observer2 = ObserverMock();
        when(observer2.didAddProvider(any, any)).thenThrow('error2');
        final observer3 = ObserverMock();
        final provider = Provider((_) => 42);
        final errors = <Object>[];
        final container = runZonedGuarded(
          () => ProviderContainer.test(
            observers: [observer, observer2, observer3],
          ),
          (err, stack) => errors.add(err),
        )!;

        final result = container.read(provider);

        expect(result, 42);
        expect(errors, ['error1', 'error2']);
        verifyInOrder([
          observer.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            42,
          ),
          observer2.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            42,
          ),
          observer3.didAddProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
            42,
          ),
        ]);
        verifyNoMoreInteractions(observer);
      });
    });

    group('didDisposeProvider', () {
      test('supports invalidate', () {
        final observer = ObserverMock();
        final container = ProviderContainer.test(observers: [observer]);
        final provider = Provider<int>((ref) => 0);

        container.read(provider);
        clearInteractions(observer);

        container.invalidate(provider);
        verifyOnly(
          observer,
          observer.didDisposeProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
          ),
        );

        container.invalidate(provider);
        verifyNoMoreInteractions(observer);
      });

      test('supports container dispose', () {
        final observer = ObserverMock();
        final container = ProviderContainer.test(observers: [observer]);
        final provider = NotifierProvider<Counter, int>(Counter.new);

        container.read(provider);

        clearInteractions(observer);

        container.dispose();

        verifyInOrder([
          observer.didDisposeProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
          ),
        ]);
        verifyNoMoreInteractions(observer);
      });

      test('supports auto-dispose', () async {
        final observer = ObserverMock();
        final container = ProviderContainer.test(observers: [observer]);
        final provider = NotifierProvider.autoDispose<Counter, int>(
          Counter.new,
        );

        final sub = container.listen(provider, (_, _) {});

        clearInteractions(observer);

        sub.close();
        await container.pump();

        verifyInOrder([
          observer.didDisposeProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
          ),
        ]);
        verifyNoMoreInteractions(observer);
      });

      test('is guarded', () {
        final observer = ObserverMock();
        when(observer.didDisposeProvider(any)).thenThrow('error1');
        final observer2 = ObserverMock();
        when(observer2.didDisposeProvider(any)).thenThrow('error2');
        final observer3 = ObserverMock();
        final onDispose = OnDisposeMock();
        final provider = Provider((ref) {
          ref.onDispose(onDispose.call);
          return 0;
        });
        final provider2 = Provider((ref) => ref.watch(provider));
        final errors = <Object>[];
        final container = runZonedGuarded(
          () => ProviderContainer.test(
            observers: [observer, observer2, observer3],
          ),
          (err, stack) => errors.add(err),
        )!;

        expect(container.read(provider), 0);
        expect(container.read(provider2), 0);
        clearInteractions(observer);
        clearInteractions(observer2);
        clearInteractions(observer3);
        verifyNoMoreInteractions(onDispose);

        container.dispose();

        expect(errors, ['error1', 'error2', 'error1', 'error2']);
        verifyInOrder([
          observer.didDisposeProvider(
            argThat(
              isProviderObserverContext(
                provider: provider2,
                container: container,
              ),
            ),
          ),
          observer2.didDisposeProvider(
            argThat(
              isProviderObserverContext(
                provider: provider2,
                container: container,
              ),
            ),
          ),
          observer3.didDisposeProvider(
            argThat(
              isProviderObserverContext(
                provider: provider2,
                container: container,
              ),
            ),
          ),
          onDispose(),
          observer.didDisposeProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
          ),
          observer2.didDisposeProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
          ),
          observer3.didDisposeProvider(
            argThat(
              isProviderObserverContext(
                provider: provider,
                container: container,
              ),
            ),
          ),
        ]);
        verifyNoMoreInteractions(onDispose);
        verifyNoMoreInteractions(observer);
        verifyNoMoreInteractions(observer2);
        verifyNoMoreInteractions(observer3);
      });
    });
  });
}

final class _EmptyObserver extends ProviderObserver {}

TypeMatcher<ProviderReference> providerReferences(
  ProviderBase<Object?> provider,
  ProviderContainer container,
) {
  return isA<ProviderReference>()
      .having((reference) => reference.provider, 'provider', provider)
      .having((reference) => reference.container, 'container', container);
}

List<ProviderBase<Object?>> compute(ProviderContainer container) {
  return container
      .getAllProviderElementsInOrder()
      .map((e) => e.provider)
      .toList();
}

class A {}

class B {}

class C {}

class D {}

class E {}

class F {}

class G {}

final class ConstObserver extends ProviderObserver {
  const ConstObserver();
}
