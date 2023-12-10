import 'package:riverpod/src/framework2/framework.dart';
import 'package:test/test.dart';

void main() {
  group('ProviderContainer', () {
    group('.test', () {
      test('Auto-disposes the provider when the test ends', () {
        late ProviderContainer container;

        addTearDown(() => expect(container.disposed, true));

        container = ProviderContainer.test();

        addTearDown(() => expect(container.disposed, false));
      });

      group('exists', () {
        test('simple use-case', () {
          final container = ProviderContainer.test();
          final provider = Provider((ref) => 0);

          expect(container.exists(provider), false);
          expect(container.getAllProviderElements(), isEmpty);

          container.read(provider);

          expect(container.exists(provider), true);
        });

        test('handles autoDispose', () async {
          final provider = Provider.autoDispose((ref) => 0);
          final container = ProviderContainer.test(
            overrides: [
              provider.overrideWith((ref) => 42),
            ],
          );

          expect(container.exists(provider), false);
          expect(container.getAllProviderElements(), isEmpty);

          container.read(provider);

          expect(container.exists(provider), true);

          await container.pump();

          expect(container.getAllProviderElements(), isEmpty);
          expect(container.exists(provider), false);
          expect(container.getAllProviderElements(), isEmpty);
        });

        test('Handles uninitialized overrideWith', () {
          final provider = Provider((ref) => 0);
          final container = ProviderContainer.test(
            overrides: [
              provider.overrideWith((ref) => 42),
            ],
          );

          expect(container.exists(provider), false);
          expect(container.getAllProviderElements(), isEmpty);

          container.read(provider);

          expect(container.exists(provider), true);
        });

        test('handles nested providers', () {
          final provider = Provider((ref) => 0);
          final provider2 = Provider((ref) => 0);
          final root = ProviderContainer.test();
          final container =
              ProviderContainer.test(parent: root, overrides: [provider2]);

          expect(container.exists(provider), false);
          expect(container.exists(provider2), false);
          expect(container.getAllProviderElements(), isEmpty);
          expect(root.getAllProviderElements(), isEmpty);

          container.read(provider);

          expect(container.exists(provider), true);
          expect(container.exists(provider2), false);
          expect(container.getAllProviderElements(), isEmpty);
          expect(
              root.getAllProviderElements().map((e) => e.origin), [provider]);

          container.read(provider2);

          expect(container.exists(provider2), true);
          expect(
            container.getAllProviderElements().map((e) => e.origin),
            [provider2],
          );
          expect(
              root.getAllProviderElements().map((e) => e.origin), [provider]);
        });
      });
    });
  });
}
