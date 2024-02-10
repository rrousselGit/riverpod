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
      // `container.read(provider)`와 동일합니다.
      // 그러나 "subscription"이 disposed되지 않는 한 provider는 disposed되지 않습니다.
      subscription.read(),
      'Some value',
    );
    /* SNIPPET END */
  });
}
