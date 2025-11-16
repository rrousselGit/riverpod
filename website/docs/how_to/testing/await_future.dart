
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

final provider = FutureProvider((_) async => 42);

void main() {
  test('Some description', () async {
    // Create a ProviderContainer for this test.
    // DO NOT share ProviderContainers between tests.
    final container = ProviderContainer.test();

    /* SNIPPET START */
    // {@template note}
    // TODO: use the container to test your application.
    // Our expectation is asynchronous, so we should use "expectLater"
    // {@endtemplate}
    await expectLater(
      // {@template read}
      // We read "provider.future" instead of "provider".
      // This is possible on asynchronous providers, and returns a future
      // which will resolve with the value of the provider.
      // {@endtemplate}
      container.read(provider.future),
      // {@template completion}
      // We can verify that the future resolves with the expected value.
      // Alternatively we can use "throwsA" for errors.
      // {@endtemplate}
      completion('some value'),
    );
    /* SNIPPET END */
  });
}
