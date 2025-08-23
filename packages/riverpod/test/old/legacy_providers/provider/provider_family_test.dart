import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ProviderElement;
import 'package:riverpod/src/internals.dart' show InternalProviderContainer;
import 'package:test/test.dart';

void main() {
  group('Provider.family', () {
    test('specifies `from` & `argument` for related providers', () {
      final provider = Provider.family<int, int>((ref, _) => 0);

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () {
        final provider = Provider.family<int, int>(
          (ref, _) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        expect(container.read(provider(0)), 0);
        expect(container.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider(0)),
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWith', () {
        final provider = Provider.family<int, int>(
          (ref, _) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWith((ref, value) => 42)],
        );

        expect(root.getAllProviderElements(), isEmpty);
        expect(container.read(provider(0)), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider(0)),
        ]);
      });
    });

    test('can be auto-scoped', () async {
      final dep = Provider(
        (ref) => 0,
        dependencies: const [],
      );
      final provider = Provider.family<int, int>(
        (ref, i) => ref.watch(dep) + i,
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10)), 52);

      expect(root.getAllProviderElements(), isEmpty);
    });
  });
}
