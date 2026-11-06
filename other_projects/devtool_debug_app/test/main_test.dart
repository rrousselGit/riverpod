import 'package:devtool_debug_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  test('exposes providers in data, error and loading states', () {
    final container = ProviderContainer.test();

    expect(container.read(dataProvider), const AsyncData(42));
    // Errors are retried, so the provider stays loading with the error.
    expect(container.read(errorProvider).hasError, isTrue);
    expect(container.read(loadingProvider), isA<AsyncLoading<int>>());
  });
}
