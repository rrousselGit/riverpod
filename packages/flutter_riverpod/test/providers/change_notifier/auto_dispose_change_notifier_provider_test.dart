// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter/widgets.dart' hide Listener;
import 'package:flutter_riverpod/src/internals.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChangeNotifierProvider.autoDispose', () {
    test('support null ChangeNotifier', () {
      final container = ProviderContainer.test();
      final provider = ChangeNotifierProvider.autoDispose<ValueNotifier<int>?>(
        (ref) => null,
      );

      expect(container.read(provider), null);
      expect(container.read(provider.notifier), null);

      container.dispose();
    });

    test('can refresh .notifier', () async {
      var initialValue = 1;
      final provider = ChangeNotifierProvider.autoDispose<ValueNotifier<int>>(
        (ref) => ValueNotifier<int>(initialValue),
      );
      final container = ProviderContainer.test();

      container.listen(provider.notifier, (prev, value) {});

      expect(container.read(provider).value, 1);
      expect(container.read(provider.notifier).value, 1);

      initialValue = 42;

      expect(container.refresh(provider.notifier).value, 42);
      expect(container.read(provider).value, 42);
    });

    test('can be refreshed', () async {
      var result = ValueNotifier(0);
      final container = ProviderContainer.test();
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
        final provider = ChangeNotifierProvider.autoDispose(
          (ref) => ValueNotifier(0),
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        expect(container.read(provider.notifier).value, 0);
        expect(container.read(provider).value, 0);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object>[
            isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          ]),
        );
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWith', () {
        final provider = ChangeNotifierProvider.autoDispose(
          (ref) => ValueNotifier(0),
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWith((ref) => ValueNotifier(42))],
        );

        expect(container.read(provider.notifier).value, 42);
        expect(container.read(provider).value, 42);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object>[
            isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          ]),
        );
        expect(root.getAllProviderElements(), isEmpty);
      });
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider = ChangeNotifierProvider.autoDispose(
        (ref) => ValueNotifier(ref.watch(dep)),
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider).value, 42);
      expect(container.read(provider.notifier).value, 42);

      expect(root.getAllProviderElements(), isEmpty);
    });
  });
}
