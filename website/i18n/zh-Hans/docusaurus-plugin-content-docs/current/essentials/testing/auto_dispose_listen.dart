// ignore_for_file: unused_local_variable, avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import 'create_container.dart';

final provider = Provider((_) => 'Hello world');

void main() {
  test('Some description', () {
    final container = createContainer();
    /* SNIPPET START */
    final subscription = container.listen<String>(provider, (_, __) {});

    expect(
      // 等同于 `container.read(provider)`
      // 但除非处置了 "subscription"，否则不会处置提供者程序。
      subscription.read(),
      'Some value',
    );
    /* SNIPPET END */
  });
}
