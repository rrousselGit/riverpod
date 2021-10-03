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

    test('use latest override on mount', () {
      final provider = Provider((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithValue(42),
      ]);

      container.updateOverrides([
        provider.overrideWithValue(21),
      ]);

      expect(container.read(provider), 21);
    });

    test('updating scoped override does not mount the provider', () {
      final provider = Provider((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithValue(42),
      ]);

      container.updateOverrides([
        provider.overrideWithValue(21),
      ]);

      expect(container.getAllProviderElements(), isEmpty);
      expect(root.getAllProviderElements(), isEmpty);
    });

    test(
        'does not re-initialize a provider if read by an intermediary container',
        () {
      var callCount = 0;
      final provider = Provider((ref) => 0);
      final root = createContainer();
      final mid = createContainer(parent: root, overrides: [
        provider.overrideWithProvider(
          Provider((ref) {
            callCount++;
            return 42;
          }),
        ),
      ]);
      final container = createContainer(parent: mid);

      expect(mid.read(provider), 42);
      expect(callCount, 1);

      expect(container.read(provider), 42);
      expect(callCount, 1);
    });
  });

  group('Scoping family', () {
    test('use latest override on mount', () {
      final provider = Provider.family<String, int>((ref, value) => '$value 0');
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithProvider((value) {
          return Provider((ref) => '$value 1');
        }),
      ]);

      container.updateOverrides([
        provider.overrideWithProvider((value) {
          return Provider((ref) => '$value 2');
        }),
      ]);

      expect(container.read(provider(0)), '0 2');
    });

    test('updating scoped override does not mount the provider', () {
      final provider = Provider.family<String, int>((ref, value) => '$value 0');
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithProvider((value) {
          return Provider((ref) => '$value 1');
        }),
      ]);

      container.updateOverrides([
        provider.overrideWithProvider((value) {
          return Provider((ref) => '$value 2');
        }),
      ]);

      expect(container.getAllProviderElements(), isEmpty);
      expect(root.getAllProviderElements(), isEmpty);
    });

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
        () {
      var callCount = 0;
      final provider = Provider.family<String, int>((ref, value) => '$value 0');
      final root = createContainer();
      final mid = createContainer(parent: root, overrides: [
        provider.overrideWithProvider(
          (value) => Provider((ref) {
            callCount++;
            return '$value 1';
          }),
        ),
      ]);
      final container = createContainer(parent: mid);

      expect(mid.read(provider(0)), '0 1');
      expect(callCount, 1);

      expect(container.read(provider(0)), '0 1');
      expect(callCount, 1);
    });
  });
}
