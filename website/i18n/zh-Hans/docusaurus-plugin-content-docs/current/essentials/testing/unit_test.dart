// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import 'create_container.dart';

final provider = Provider((_) => 42);

/* SNIPPET START */
void main() {
  test('Some description', () {
    // 为该测试创建一个 ProviderContainer。
    // 切勿！在测试之间共享 ProviderContainer。
    final container = createContainer();

    // TODO: 使用容器测试你的应用程序。
    expect(
      container.read(provider),
      equals('some value'),
    );
  });
}
