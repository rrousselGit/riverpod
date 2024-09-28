import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/scopes.dart';

void main() {
  test('throws UnsupportedError if accessed without an override', () {
    final container = ProviderContainer.test();

    expect(
      () => container.read(scopedClassProvider),
      throwsA(
        isA<MissingScopeException>().having(
          (e) => e.toString(),
          'toString',
          startsWith(
            'MissingScopeException: The provider scopedClassProvider is scoped, ',
          ),
        ),
      ),
    );
  });

  test('Can be accessed without problem if the provider is overridden', () {
    final container = ProviderContainer.test();

    expect(
      () => container.read(scopedClassFamilyProvider(42)),
      throwsA(
        isA<MissingScopeException>().having(
          (e) => e.toString(),
          'toString',
          startsWith(
            'MissingScopeException: The provider scopedClassFamilyProvider(42) is scoped, ',
          ),
        ),
      ),
    );
  });

  test('Marks the provider as scoped', () {
    expect(
      scopedClassFamilyProvider.allTransitiveDependencies,
      same(const <ProviderOrFamily>[]),
    );
    expect(
      scopedClassProvider.allTransitiveDependencies,
      same(const <ProviderOrFamily>[]),
    );
  });
}
