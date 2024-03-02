// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import 'create_container.dart';

final provider = FutureProvider((_) async => 42);

void main() {
  test('Some description', () async {
    // 为该测试创建一个 ProviderContainer。
    // 切勿！在测试之间共享 ProviderContainer。
    final container = createContainer();

    /* SNIPPET START */
    // TODO: 使用容器来测试您的应用程序。
    // 我们的期望是异步的，所以应该使用 "expectLater"（期望稍后）。
    await expectLater(
      // 我们读取的是 "provider.future"，而不是 "provider"。
      // 这在异步提供者程序上是可能发生的，
      // 并返回一个携带了提供者程序的值的 Future。
      container.read(provider.future),
      // We can verify that the future resolves with the expected value.
      // Alternatively we can use "throwsA" for errors.
      // 我们可以验证 Future 是否按预期值解析。
      // 或者，我们可以使用 "throwsA" 来处理错误。
      completion('some value'),
    );
    /* SNIPPET END */
  });
}
