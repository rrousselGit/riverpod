import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('supports .name', () {
    expect(
      StateProvider.autoDispose.family<int, int>((ref, id) => 0)(0).name,
      null,
    );
    expect(
      StateProvider.autoDispose
          .family<int, int>((ref, id) => 0, name: 'foo')(0)
          .name,
      'foo',
    );
  });

  group('StateProvider.autoDispose.family.autoDispose', () {
    test('specifies `from` and `argument` for related providers', () {
      final provider = StateProvider.autoDispose.family<AsyncValue<int>, int>(
        (ref, _) => const AsyncValue.data(42),
      );

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final provider =
            StateProvider.autoDispose.family<int, int>((ref, _) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider(0).notifier).state, 0);
        expect(container.read(provider(0)), 0);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase<Object?>>()
                .having((e) => e.origin, 'origin', provider(0)),
          ]),
        );
        expect(root.getAllProviderElementsInOrder(), isEmpty);
      });

      test('when using provider.overrideWithProvider', () async {
        final provider =
            StateProvider.autoDispose.family<int, int>((ref, _) => 0);
        final root = createContainer();
        final container = createContainer(
          parent: root,
          overrides: [
            provider.overrideWithProvider(
              (value) => StateProvider.autoDispose((ref) => 42),
            ),
          ],
        );

        expect(container.read(provider(0).notifier).state, 42);
        expect(container.read(provider(0)), 42);
        expect(root.getAllProviderElementsInOrder(), isEmpty);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase<Object?>>()
                .having((e) => e.origin, 'origin', provider(0)),
          ]),
        );
      });
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0);
      final provider = StateProvider.autoDispose.family<int, int>(
        (ref, i) => ref.watch(dep) + i,
        dependencies: [dep],
      );
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10)), 52);
      expect(container.read(provider(10).notifier).state, 52);

      expect(root.getAllProviderElements(), isEmpty);
    });
  });
}
