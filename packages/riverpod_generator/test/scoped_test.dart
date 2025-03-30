import 'package:riverpod/riverpod.dart' show ProviderContainer;
import 'package:test/test.dart';

import 'integration/scopes.dart';

void main() {
  test('throws UnsupportedError if accessed without an override', () {
    final container = ProviderContainer.test();

    expect(
      () => container.read(scopedProvider),
      throwsUnsupportedError,
    );
  });

  test('Can be accessed without problem if the provider is overridden', () {
    final container = ProviderContainer.test(
      overrides: [
        scopedProvider.overrideWith((ref) => 42),
      ],
    );

    expect(container.read(scopedProvider), 42);
  });
}
