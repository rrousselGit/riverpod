// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

late WidgetRef ref;

/* SNIPPET START */
@riverpod
String label(LabelRef ref, String userName) {
  return 'Hello $userName';
}

// ...

void onTap() {
  // 이 provider의 가능한 모든 매개변수 조합을 무효화합니다.
  ref.invalidate(labelProvider);
  // 특정 조합만 무효화
  ref.invalidate(labelProvider('John'));
}
/* SNIPPET END */
