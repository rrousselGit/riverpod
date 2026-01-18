// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

final provider = Provider((_) => 'Hello world');

void main() {
  test('Some description', () {
    final container = ProviderContainer.test();
    /* SNIPPET START */
    container.listen<String>(
      provider,
      (previous, next) {
        print('The provider changed from $previous to $next');
      },
    );
    /* SNIPPET END */
  });
}
