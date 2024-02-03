// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// 값(여기서는 "Hello world")을 저장할 "provider"를 생성합니다.
// provider를 이용하면, 노출된 값을 모의(Mock)하거나 오버라이드(override)할 수 있습니다.
@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

void main() {
  // 이 객체는 providers의 상태가 저장되는 곳입니다.
  final container = ProviderContainer();

  // "container" 덕분에 provider를 읽을 수 있습니다.
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
