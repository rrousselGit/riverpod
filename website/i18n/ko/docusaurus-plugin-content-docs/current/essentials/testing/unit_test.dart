// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import 'create_container.dart';

final provider = Provider((_) => 42);

/* SNIPPET START */
void main() {
  test('Some description', () {
    // 이 테스트에 대한 ProviderContainer를 생성합니다.
    // DO NOT 테스트 간에 ProviderContainer를 공유하지 마세요.
    final container = createContainer();

    // TODO: use the container to test your application.
    expect(
      container.read(provider),
      equals('some value'),
    );
  });
}
