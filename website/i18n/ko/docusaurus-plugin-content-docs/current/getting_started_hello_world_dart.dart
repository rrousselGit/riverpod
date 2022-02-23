// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';

// 우리는 값을 저장할 "provider"를 만들겁니다(여기서 값은 "Hello world"를 의미합니다).
// 프로바이더를 사용하는 것으로 값의 mock/override가 가능하게 됩니다.
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  // 이 객체는 프로바이더 상태를 저장하게 됩니다.
  final container = ProviderContainer();

  // "container" 덕분에, 여기서 우리의 프로바이더 값을 읽을 수 있습니다.
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
