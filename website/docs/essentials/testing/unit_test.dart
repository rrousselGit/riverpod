// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

final provider = Provider((_) => 42);

/* SNIPPET START */
void main() {
  test('Some description', () {
    // Create a ProviderContainer for this test.
    // DO NOT share ProviderContainers between tests.
    final container = ProviderContainer.test();

    // TODO: use the container to test your application.
    expect(
      container.read(provider),
      equals('some value'),
    );
  });
}
