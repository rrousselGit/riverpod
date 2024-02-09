import 'package:test/test.dart';

import 'integration/scopes.dart';
import 'utils.dart';

void main() {
  test('throws UnsupportedError if accessed without an override', () {
    final container = createContainer();

    expect(
      () => container.read(scopedProvider),
      throwsUnsupportedError,
    );
  });

  test('Can be accessed without problem if the provider is overridden', () {
    final container = createContainer(
      overrides: [
        scopedProvider.overrideWith((ref) => 42),
      ],
    );

    expect(container.read(scopedProvider), 42);
  });
}
