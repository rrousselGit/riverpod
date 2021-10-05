import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('StateNotifier.family', () {
    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final controller = StateController(0);
        final provider =
            StateNotifierProvider.family<StateController<int>, int, int>(
          (ref, _) => controller,
        );
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider(0).notifier), controller);
        expect(container.read(provider(0)), 0);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0)),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0).notifier),
          ]),
        );
        expect(root.getAllProviderElementsInOrder(), isEmpty);
      });

      test('when using provider.overrideWithProvider', () async {
        final controller = StateController(0);
        final provider =
            StateNotifierProvider.family<StateController<int>, int, int>(
                (ref, _) => controller);
        final root = createContainer();
        final controllerOverride = StateController(42);
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider(
            (value) => StateNotifierProvider((ref) => controllerOverride),
          ),
        ]);

        expect(container.read(provider(0).notifier), controllerOverride);
        expect(container.read(provider(0)), 42);
        expect(root.getAllProviderElementsInOrder(), isEmpty);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0)),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0).notifier),
          ]),
        );
      });
    });

    test(
      'StateNotifierProviderFamily.toString includes argument & name',
      () {
        final family = StateNotifierProvider.family<Counter, int, String>(
          (ref, id) => Counter(),
          name: 'Example',
        );

        expect(
          family('foo').toString(),
          equalsIgnoringHashCodes(
            'Example:StateNotifierProvider<Counter, int>#05480(foo)',
          ),
        );
      },
    );

    test('properly overrides ==', () {
      final family = StateNotifierProvider.family<Counter, int, int>(
          (ref, _) => Counter());

      expect(family(0), family(0));
      expect(family(1), isNot(family(0)));
      expect(family(1), family(1));
    });

    test(
      'scoping a provider overrides all the associated subproviders',
      () {
        final family = StateNotifierProvider.family<Counter, int, String>(
          (ref, id) => Counter(),
        );
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [family]);

        expect(container.read(family('0')), 0);
        expect(container.read(family('0').notifier), isA<Counter>());

        expect(
          container.getAllProviderElementsInOrder(),
          [
            isA<ProviderElementBase>()
                .having((e) => e.provider, 'provider', family('0').notifier),
            isA<ProviderElementBase>()
                .having((e) => e.provider, 'provider', family('0')),
          ],
        );
      },
    );
  });
}
