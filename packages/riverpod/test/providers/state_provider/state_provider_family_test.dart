import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('StateProvider.family', () {
    test('specifies `from` and `argument` for related providers', () {
      final provider = StateProvider.family<AsyncValue<int>, int>(
        (ref, _) => const AsyncValue.data(42),
      );

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);

      expect(provider(0).state.from, provider);
      expect(provider(0).state.argument, 0);

      expect(provider(0).notifier.from, provider);
      expect(provider(0).notifier.argument, 0);

      expect(provider(0).future.from, provider);
      expect(provider(0).future.argument, 0);

      expect(provider(0).stream.from, provider);
      expect(provider(0).stream.argument, 0);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final provider = StateProvider.family<int, int>((ref, _) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider(0).notifier).state, 0);
        expect(container.read(provider(0).state).state, 0);
        expect(container.read(provider(0)), 0);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0)),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0).state),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0).notifier),
          ]),
        );
        expect(root.getAllProviderElementsInOrder(), isEmpty);
      });

      test('when using provider.overrideWithProvider', () async {
        final provider = StateProvider.family<int, int>((ref, _) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider(
            (value) => StateProvider((ref) => 42),
          ),
        ]);

        expect(container.read(provider(0).notifier).state, 42);
        expect(container.read(provider(0).state).state, 42);
        expect(container.read(provider(0)), 42);
        expect(root.getAllProviderElementsInOrder(), isEmpty);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0)),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0).state),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0).notifier),
          ]),
        );
      });
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0);
      final provider = StateProvider.family<int, int>(
        (ref, i) => ref.watch(dep) + i,
        dependencies: [dep],
      );
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10).state).state, 52);
      expect(container.read(provider(10).notifier).state, 52);

      expect(root.getAllProviderElements(), isEmpty);
    });

    test('StateProviderFamily', () async {
      final provider = StateProvider.family<String, int>((ref, a) {
        return '$a';
      });
      final container = createContainer();

      expect(container.read(provider(0)), '0');
      expect(container.read(provider(1)), '1');
    });

    test('StateProviderFamily override', () async {
      final provider = StateProvider.family<String, int>((ref, a) {
        return '$a';
      });
      final container = createContainer(overrides: [
        provider.overrideWithProvider((a) {
          return StateProvider((ref) => 'override $a');
        }),
      ]);

      expect(container.read(provider(0)), 'override 0');
      expect(container.read(provider(1)), 'override 1');
    });
  });
}
