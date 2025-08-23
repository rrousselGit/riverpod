import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ProviderElement;
import 'package:riverpod/src/internals.dart' show InternalProviderContainer;
import 'package:test/test.dart';

void main() {
  group('StreamProvider.family', () {
    test('specifies `from` & `argument` for related providers', () {
      final provider = StreamProvider.family<int, int>(
        (ref, _) => Stream.value(0),
      );

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final provider = StreamProvider.family<int, int>(
          (ref, _) => Stream.value(0),
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        container.listen(provider(0), (p, n) {});

        expect(await container.read(provider(0).future), 0);
        expect(container.read(provider(0)), const AsyncData(0));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having(
              (e) => e.origin,
              'origin',
              provider(0),
            ),
          ]),
        );
      });

      test('when using provider.overrideWith', () async {
        final provider = StreamProvider.family<int, int>(
          (ref, _) => Stream.value(0),
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWith((ref, value) => Stream.value(42))],
        );

        container.listen(provider(0), (p, n) {});

        expect(await container.read(provider(0).future), 42);
        expect(container.read(provider(0)), const AsyncData(42));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having(
              (e) => e.origin,
              'origin',
              provider(0),
            ),
          ]),
        );
      });
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider = StreamProvider.family<int, int>(
        (ref, i) => Stream.value(ref.watch(dep) + i),
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      container.listen(provider(10), (p, n) {});

      await expectLater(container.read(provider(10).future), completion(52));
      expect(container.read(provider(10)), const AsyncData(52));

      expect(root.getAllProviderElements(), isEmpty);
    });

    test('StreamProvider.family override', () async {
      final provider = StreamProvider.family<String, int>((ref, a) {
        return Stream.value('$a');
      });
      final container = ProviderContainer(
        overrides: [
          provider.overrideWith((ref, a) => Stream.value('override $a')),
        ],
      );

      container.listen(provider(0), (p, n) {});

      expect(container.read(provider(0)), const AsyncValue<String>.loading());

      await container.pump();

      expect(
        container.read(provider(0)),
        const AsyncValue<String>.data('override 0'),
      );
    });
  });
}
