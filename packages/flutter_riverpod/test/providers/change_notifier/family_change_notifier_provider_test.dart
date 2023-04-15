// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/src/internals.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  group('ChangeNotifierProvider.family', () {
    test('specifies `from` and `argument` for related providers', () {
      final provider = ChangeNotifierProvider.family<ValueNotifier<int>, int>(
        (ref, _) => ValueNotifier(42),
      );

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);
    });

    test('support null ChangeNotifier', () {
      final container = createContainer();
      final provider = ChangeNotifierProvider.family<ValueNotifier<int>?, int>(
        (ref, _) => null,
      );

      expect(container.read(provider(0)), null);
      expect(container.read(provider(0).notifier), null);

      container.dispose();
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final provider = ChangeNotifierProvider.family<ValueNotifier<int>, int>(
          (ref, _) => ValueNotifier(0),
        );
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider(0).notifier).value, 0);
        expect(container.read(provider(0)).value, 0);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase<Object?>>()
                .having((e) => e.origin, 'origin', provider(0)),
          ]),
        );
        expect(root.getAllProviderElementsInOrder(), isEmpty);
      });
    });

    test('ChangeNotifier can be auto-scoped', () async {
      final dep = Provider((ref) => 0);
      final provider = ChangeNotifierProvider.family<ValueNotifier<int>, int>(
        (ref, i) => ValueNotifier(ref.watch(dep) + i),
        dependencies: [dep],
      );
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10)).value, 52);
      expect(container.read(provider(10).notifier).value, 52);

      expect(root.getAllProviderElements(), isEmpty);
    });

    test('when using provider.overrideWithProvider', () async {
      final provider = ChangeNotifierProvider.family<ValueNotifier<int>, int>(
        (ref, _) => ValueNotifier(0),
      );
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [
          provider.overrideWithProvider(
            (value) => ChangeNotifierProvider((ref) => ValueNotifier(42)),
          ),
        ],
      );

      expect(container.read(provider(0).notifier).value, 42);
      expect(container.read(provider(0)).value, 42);
      expect(root.getAllProviderElementsInOrder(), isEmpty);
      expect(
        container.getAllProviderElementsInOrder(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase<Object?>>()
              .having((e) => e.origin, 'origin', provider(0)),
        ]),
      );
    });

    test('family override', () {
      final provider =
          ChangeNotifierProvider.family<ValueNotifier<int>, int>((ref, value) {
        return ValueNotifier(value);
      });
      final container = createContainer(
        overrides: [
          provider.overrideWithProvider(
            (value) =>
                ChangeNotifierProvider((ref) => ValueNotifier(value * 2)),
          ),
        ],
      );

      expect(
        container.read(provider(0)),
        isA<ValueNotifier<int>>().having((source) => source.value, 'value', 0),
      );
      expect(
        container.read(provider(42)),
        isA<ValueNotifier<int>>().having((source) => source.value, 'value', 84),
      );
    });
  });
}
