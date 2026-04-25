import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

TypeMatcher<ProviderReference> providerReferences(
  ProviderBase<Object?> provider,
  ProviderContainer container,
) {
  return isA<ProviderReference>()
      .having((reference) => reference.provider, 'provider', provider)
      .having((reference) => reference.container, 'container', container);
}

void main() {
  group('.allProviders', () {
    test('.allOf returns active providers of a family', () async {
      final family = Provider.autoDispose.family<int, int>((ref, arg) => arg);
      final otherFamily = Provider.autoDispose.family<int, int>(
        (ref, arg) => arg,
      );
      final container = ProviderContainer.test();

      final sub0 = container.listen(family(0), (_, _) {});
      final sub1 = container.listen(family(1), (_, _) {});
      final otherSub = container.listen(otherFamily(2), (_, _) {});

      expect(
        container.allProviders(family: family),
        unorderedEquals([
          providerReferences(family(0), container),
          providerReferences(family(1), container),
        ]),
      );

      sub0.close();
      await container.pump();

      expect(
        container.allProviders(family: family),
        unorderedEquals([providerReferences(family(1), container)]),
      );

      sub1.close();
      otherSub.close();
      await container.pump();

      expect(container.allProviders(family: family), isEmpty);
    });

    test(
      '.allOf includes active providers from parent containers too',
      () async {
        final family = Provider.autoDispose.family<int, int>(
          (ref, arg) => arg,
          dependencies: [],
        );
        final unrelated = Provider((ref) => 0);
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [unrelated, family(2).overrideWithValue(42)],
        );

        container.listen(family(1), (_, _) {});
        root.listen(family(0), (_, _) {});

        root.listen(family(2), (_, _) {});
        container.listen(family(2), (_, _) {});

        expect(
          container.allProviders(family: family),
          unorderedEquals([
            providerReferences(family(0), root),
            providerReferences(family(1), root),
            providerReferences(family(2), root),
            providerReferences(family(2), container),
          ]),
        );
      },
    );

    test('returns all active providers', () async {
      final provider = Provider.autoDispose((ref) => 0);
      final family = Provider.autoDispose.family<int, int>((ref, arg) => arg);
      final otherFamily = Provider.autoDispose.family<int, int>(
        (ref, arg) => arg,
      );
      final container = ProviderContainer.test();

      final providerSub = container.listen(provider, (_, _) {});
      final familySub0 = container.listen(family(0), (_, _) {});
      final familySub1 = container.listen(family(1), (_, _) {});
      final otherFamilySub = container.listen(otherFamily(2), (_, _) {});

      expect(
        container.allProviders(),
        unorderedEquals([
          providerReferences(provider, container),
          providerReferences(family(0), container),
          providerReferences(family(1), container),
          providerReferences(otherFamily(2), container),
        ]),
      );

      providerSub.close();
      familySub0.close();
      familySub1.close();
      otherFamilySub.close();
      await container.pump();

      expect(container.allProviders(), isEmpty);
    });

    test('throws if new providers are registered while iterating', () {
      final provider = Provider((ref) => 0);
      final newProvider = Provider((ref) => 1);
      final container = ProviderContainer.test();

      container.listen(provider, (_, _) {});

      expect(() {
        for (final _ in container.allProviders()) {
          container.listen(newProvider, (_, _) {});
        }
      }, throwsA(isA<ConcurrentModificationError>()));
    });

    test(
      'with family specified, only new providers from that family throw',
      () {
        final family = Provider.family<int, int>((ref, arg) => arg);
        final otherFamily = Provider.family<int, int>((ref, arg) => arg);
        final container = ProviderContainer.test();

        container.listen(family(0), (_, _) {});

        expect(() {
          for (final _ in container.allProviders(family: family)) {
            container.listen(otherFamily(0), (_, _) {});
          }
        }, returnsNormally);

        expect(() {
          for (final _ in container.allProviders(family: family)) {
            container.listen(family(1), (_, _) {});
          }
        }, throwsA(isA<ConcurrentModificationError>()));
      },
    );

    test('includes active providers from parent containers too', () {
      final provider = Provider((ref) => 0);
      final family = Provider.autoDispose.family<int, int>(
        (ref, arg) => arg,
        dependencies: [],
      );
      final unrelated = Provider((ref) => 42);
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [unrelated, family(2).overrideWithValue(42)],
      );

      root.listen(provider, (_, _) {});
      container.listen(family(1), (_, _) {});
      root.listen(family(2), (_, _) {});
      container.listen(family(2), (_, _) {});

      expect(
        container.allProviders(),
        unorderedEquals([
          providerReferences(provider, root),
          providerReferences(family(1), root),
          providerReferences(family(2), root),
          providerReferences(family(2), container),
        ]),
      );
    });
  });
}
