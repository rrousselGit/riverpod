import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  group('ChangeNotifierProvider.family', () {
    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final provider = ChangeNotifierProvider.family<ValueNotifier<int>, int>(
            (ref, _) => ValueNotifier(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider(0).notifier).value, 0);
        expect(container.read(provider(0)).value, 0);
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
        final provider = ChangeNotifierProvider.family<ValueNotifier<int>, int>(
            (ref, _) => ValueNotifier(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider(
            (value) => ChangeNotifierProvider((ref) => ValueNotifier(42)),
          ),
        ]);

        expect(container.read(provider(0).notifier).value, 42);
        expect(container.read(provider(0)).value, 42);
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
  });
}
