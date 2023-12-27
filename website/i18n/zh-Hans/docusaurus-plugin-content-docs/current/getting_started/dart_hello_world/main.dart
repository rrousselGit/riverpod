// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// 我们创建一个 “provider”，它将用于保存一个值（这里是 “Hello world”）。
// 通过使用一个 provider，我们能够模拟或覆盖被暴露的值。
@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

void main() {
  // 我们的 provider 将借这个对象存储状态。
  final container = ProviderContainer();

  // 我们可以借助这个 “container” 对象读取 provider。
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
