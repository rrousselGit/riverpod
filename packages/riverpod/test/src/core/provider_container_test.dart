import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart' show ProviderContainerTest;
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

      test('Passes parameters', () {
        final provider = Provider(
          (ref) => 0,
          dependencies: const [],
        );
        final observer = _EmptyObserver();

        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          observers: [observer],
          overrides: [
            provider.overrideWithValue(1),
          ],
        );

        expect(container.root, root);
        expect(container.observers, [observer]);
        expect(container.read(provider), 1);
      });
    });
  });
}

class _EmptyObserver extends ProviderObserver {}
