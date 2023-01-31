// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// 我们创建了一个 "provider", 这里它存储了一个值 (这里是 "Hello world")。
// 通过使用provider，我们能够重写或模拟这个暴露的值
@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

void main() {
  // 我们的provider将会在这个对象中保存。
  final container = ProviderContainer();

  // 多亏了"container", 我们可以在任意的地方读取各种provider。
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
