// ignore_for_file: invalid_use_of_internal_member, deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart' hide Listener;
import 'package:flutter_riverpod/src/internals.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../utils.dart';

void main() {
  group('ChangeNotifierProvider.autoDispose', () {
    test('support null ChangeNotifier', () {
      final container = createContainer();
      final provider = ChangeNotifierProvider.autoDispose<ValueNotifier<int>?>(
        (ref) => null,
      );

      expect(container.read(provider), null);
      expect(container.read(provider.notifier), null);

      container.dispose();
    });

    test('can read and set current ChangeNotifier', () async {
      final container = createContainer();
      final listener = Listener<ValueNotifier<int>>();
      late AutoDisposeChangeNotifierProviderRef<ValueNotifier<int>> ref;
      final provider =
          ChangeNotifierProvider.autoDispose<ValueNotifier<int>>((r) {
        ref = r;
        return ValueNotifier(0);
      });

      container.listen(provider, listener.call);

      verifyZeroInteractions(listener);
      expect(ref.notifier.value, 0);
    });

    test('can refresh .notifier', () async {
      var initialValue = 1;
      final provider = ChangeNotifierProvider.autoDispose<ValueNotifier<int>>(
        (ref) => ValueNotifier<int>(initialValue),
      );
      final container = createContainer();

      container.listen(provider.notifier, (prev, value) {});

      expect(container.read(provider).value, 1);
      expect(container.read(provider.notifier).value, 1);

      initialValue = 42;

      expect(container.refresh(provider.notifier).value, 42);
      expect(container.read(provider).value, 42);
    });

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
            isA<ProviderElementBase<Object?>>()
                .having((e) => e.origin, 'origin', provider),
          ]),
        );
        expect(root.getAllProviderElements(), isEmpty);
      });

      // test('when using provider.overrideWithValue', () {
      //   final provider =
      //       ChangeNotifierProvider.autoDispose((ref) => ValueNotifier(0));
      //   final root = createContainer();
      //   final container = createContainer(parent: root, overrides: [
      //     provider.overrideWithValue(ValueNotifier(42)),
      //   ]);

      //   expect(container.read(provider.notifier).value, 42);
      //   expect(container.read(provider).value, 42);
      //   expect(
      //     container.getAllProviderElements(),
      //     unorderedEquals(<Object>[
      //       isA<ProviderElementBase<Object?>>()
      //           .having((e) => e.origin, 'origin', provider),
      //       isA<ProviderElementBase<Object?>>()
      //           .having((e) => e.origin, 'origin', provider.notifier)
      //     ]),
      //   );
      //   expect(root.getAllProviderElements(), isEmpty);
      // });

      test('when using provider.overrideWithProvider', () {
        final provider =
            ChangeNotifierProvider.autoDispose((ref) => ValueNotifier(0));
        final root = createContainer();
        final container = createContainer(
          parent: root,
          overrides: [
            // ignore: deprecated_member_use
            provider.overrideWithProvider(
              ChangeNotifierProvider.autoDispose((ref) => ValueNotifier(42)),
            ),
          ],
        );

        expect(container.read(provider.notifier).value, 42);
        expect(container.read(provider).value, 42);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object>[
            isA<ProviderElementBase<Object?>>()
                .having((e) => e.origin, 'origin', provider),
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
