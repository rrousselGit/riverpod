import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  group('ChangeNotifierProvider.autoDispose', () {
    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () {
        final provider =
            ChangeNotifierProvider.autoDispose((ref) => ValueNotifier(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider.notifier).value, 0);
        expect(container.read(provider).value, 0);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.notifier)
          ]),
        );
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWithValue', () {
        final provider =
            ChangeNotifierProvider.autoDispose((ref) => ValueNotifier(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithValue(ValueNotifier(42)),
        ]);

        expect(container.read(provider.notifier).value, 42);
        expect(container.read(provider).value, 42);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.notifier)
          ]),
        );
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWithProvider', () {
        final provider =
            ChangeNotifierProvider.autoDispose((ref) => ValueNotifier(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider(
            ChangeNotifierProvider.autoDispose((ref) => ValueNotifier(42)),
          ),
        ]);

        expect(container.read(provider.notifier).value, 42);
        expect(container.read(provider).value, 42);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.notifier)
          ]),
        );
        expect(root.getAllProviderElements(), isEmpty);
      });
    });
  });
}
