import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/hash/retry.dart';

void main() {
  test('Passes retry', () {
    expect(aProvider.retry, myRetry);

    expect(bProvider.retry, myRetry2);
    expect(bProvider(42).retry, myRetry2);

    expect(cProvider.retry, ProviderContainer.defaultRetry);
  });
}
