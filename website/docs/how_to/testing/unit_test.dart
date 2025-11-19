
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

final provider = Provider((_) => 42);

/* SNIPPET START */
void main() {
  test('Some description', () {
    // {@template container}
    // Create a ProviderContainer for this test.
    // DO NOT share ProviderContainers between tests.
    // {@endtemplate}
    final container = ProviderContainer.test();

    // {@template useProvider}
    // TODO: use the container to test your application.
    // {@endtemplate}
    expect(
      container.read(provider),
      equals('some value'),
    );
  });
}
