import 'package:riverpod_annotation/experimental/scope.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/scopes.dart';
import 'mock.dart';

@Dependencies([ScopedClass, ScopedClassFamily])
void main() {
  test('throws UnsupportedError if accessed without an override', () {
    final container = ProviderContainer.test();

    expect(
      () => container.read(scopedClassProvider),
      throwsProviderException(
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
      throwsProviderException(
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
      scopedClassFamilyProvider.$allTransitiveDependencies,
      const <ProviderOrFamily>[],
    );
    expect(
      scopedClassProvider.$allTransitiveDependencies,
      const <ProviderOrFamily>[],
    );
  });
}
