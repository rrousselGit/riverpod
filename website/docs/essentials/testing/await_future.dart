// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import 'create_container.dart';

final provider = FutureProvider((_) async => 42);

void main() {
  test('Some description', () async {
    // Create a ProviderContainer for this test.
    // DO NOT share ProviderContainers between tests.
    final container = createContainer();

    /* SNIPPET START */
    // TODO: use the container to test your application.
    // Our expectation is asynchronous, so we should use "expectLater"
    await expectLater(
      // We read "provider.future" instead of "provider".
      // This is possible on asynchronous providers, and returns a future
      // which will resolve with the value of the provider.
      container.read(provider.future),
      // We can verify that the future resolves with the expected value.
      // Alternatively we can use "throwsA" for errors.
      completion('some value'),
    );
    /* SNIPPET END */
  });
}
