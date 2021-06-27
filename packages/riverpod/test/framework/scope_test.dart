// Tests related to scoping providers

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('Scoping non-family providers', () {
    test('can override a provider with a reference to the provider directly',
        () {
      final provider = Provider((ref) => 0);
      final container = createContainer();
      final child = createContainer(overrides: [provider]);

      expect(child.read(provider), 0);

      expect(child.getAllProviderElements(), [
        isA<ProviderElement>().having((e) => e.provider, 'provider', provider)
      ]);
      expect(container.getAllProviderElements(), isEmpty);
    });

    // TODO use latest override on mount
  });

  group('Scoping family', () {
    // TODO use latest override on mount
    test('can override a family with a reference to the provider directly', () {
      final provider = Provider.family<int, int>((ref, param) => 0);
      final container = createContainer();
      final child = createContainer(overrides: [provider]);

      expect(child.read(provider(0)), 0);

      expect(child.getAllProviderElements(), [
        isA<ProviderElement>()
            .having((e) => e.provider, 'provider', provider(0))
      ]);
      expect(container.getAllProviderElements(), isEmpty);
    });

    test(
        'does not re-initialize a provider if read by an intermediary container',
        () {});
  });
}
