import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
// 자동 상태 소멸을 활성화하려면 autoDispose를 지정할 수 있습니다.
final provider = Provider.autoDispose<int>((ref) {
  return 0;
});
