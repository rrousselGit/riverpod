// ignore_for_file: unused_local_variable, avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import 'create_container.dart';

final provider = Provider((_) => 'Hello world');

void main() {
  test('Some description', () {
    final container = createContainer();
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
