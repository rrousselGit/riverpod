// ignore_for_file: avoid_print, unreachable_from_main

/* SNIPPET START */

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// 我们创建了一个 "provider"，它可以存储一个值（这里是 "Hello world"）。
// 通过使用提供者程序，这可以允许我们模拟或者覆盖一个暴露的值。
@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

void main() {
  // 这个对象是我们的提供者程序的状态将被存储的地方。
  final container = ProviderContainer();

  // 多亏有了 "container"，我们可以读取我们的提供者程序。
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
