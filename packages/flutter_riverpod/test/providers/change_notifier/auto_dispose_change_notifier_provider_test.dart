import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  group('ChangeNotifierProvider.autoDispose', () {
    test('can be refreshed', () async {
      var result = ValueNotifier(0);
      final container = createContainer();
      final provider = ChangeNotifierProvider.autoDispose((ref) => result);

      expect(container.read(provider), result);
      expect(container.read(provider.notifier), result);

      result = ValueNotifier(42);
      expect(container.refresh(provider), result);

      expect(container.read(provider), result);
      expect(container.read(provider.notifier), result);
    });

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
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0);
      final provider = ChangeNotifierProvider.autoDispose(
        (ref) => ValueNotifier(ref.watch(dep)),
        dependencies: [dep],
      );
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider).value, 42);
      expect(container.read(provider.notifier).value, 42);

      expect(root.getAllProviderElements(), isEmpty);
    });
  });
}
