import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('Provider.family', () {
    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () {
        final provider = Provider.family<int, int>((ref, _) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider(0)), 0);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider(0))
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWithProvider', () {
        final provider = Provider.family<int, int>((ref, _) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider((value) => Provider((ref) => 42)),
        ]);

        expect(root.getAllProviderElements(), isEmpty);
        expect(container.read(provider(0)), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider(0))
        ]);
      });
    });
  });
}
