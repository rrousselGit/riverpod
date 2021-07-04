import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider = StateProvider.autoDispose<int>((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider]);

      expect(container.read(provider.notifier).state, 0);
      expect(container.read(provider).state, 0);
      expect(root.getAllProviderElements(), isEmpty);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.notifier),
        ]),
      );
    });

    test('when using provider.overrideWithValue', () async {
      final provider = StateProvider.autoDispose<int>((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithValue(StateController(42)),
      ]);

      expect(container.read(provider.notifier).state, 42);
      expect(container.read(provider).state, 42);
      expect(root.getAllProviderElements(), isEmpty);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.notifier),
        ]),
      );
    });

    test('when using provider.overrideWithProvider', () async {
      final provider = StateProvider.autoDispose<int>((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithProvider(
          StateProvider.autoDispose((ref) => 42),
        ),
      ]);

      expect(container.read(provider.notifier).state, 42);
      expect(container.read(provider).state, 42);
      expect(root.getAllProviderElements(), isEmpty);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.notifier),
        ]),
      );
    });
  });

  group('overrideWithProvider', () {
    test('listens to state changes', () {
      final override = StateController(42);
      final provider = StateProvider.autoDispose((ref) => 0);
      final container = createContainer(overrides: [
        provider.overrideWithValue(override),
      ]);
      addTearDown(container.dispose);
      final container2 = ProviderContainer(overrides: [
        provider.overrideWithProvider(
          StateProvider.autoDispose((ref) => 42),
        ),
      ]);
      addTearDown(container.dispose);

      expect(container.read(provider), override);
      expect(container2.read(provider).state, 42);
    });

    test(
      'properly disposes of the StateController when the provider is disposed',
      () {},
      skip: true,
    );
  });
}
