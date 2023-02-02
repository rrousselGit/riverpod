// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';

// 创建一个存储值（此值为 “Hello world”）的 provider。
// 通过使用 provider 可对值进行模拟或覆盖。
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  // ProviderContainer 是个存储 providers 状态的地方。
  final container = ProviderContainer();

  // 从 container 读取 helloWorldProvider 的值。
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
