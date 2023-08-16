import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('StateNotifier.family', () {
    test('specifies `from` & `argument` for related providers', () {
      final provider =
          StateNotifierProvider.autoDispose.family<Counter, int, int>(
        (ref, _) => Counter(),
      );

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0);
      final provider = StateNotifierProvider.autoDispose
          .family<StateController<int>, int, int>(
        (ref, i) => StateController(ref.watch(dep) + i),
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

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final controller = StateController(0);
        final provider = StateNotifierProvider.autoDispose
            .family<StateController<int>, int, int>(
          (ref, _) => controller,
        );
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider(0).notifier), controller);
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
        final controller = StateController(0);
        final provider = StateNotifierProvider.autoDispose
            .family<StateController<int>, int, int>((ref, _) => controller);
        final root = createContainer();
        final controllerOverride = StateController(42);
        final container = createContainer(
          parent: root,
          overrides: [
            provider.overrideWithProvider(
              (value) => StateNotifierProvider.autoDispose(
                (ref) => controllerOverride,
              ),
            ),
          ],
        );

        expect(container.read(provider(0).notifier), controllerOverride);
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

    test('properly overrides ==', () {
      final family = StateNotifierProvider.autoDispose
          .family<Counter, int, int>((ref, _) => Counter());

      expect(family(0), family(0));
      expect(family(1), isNot(family(0)));
      expect(family(1), family(1));
    });
  });
}
