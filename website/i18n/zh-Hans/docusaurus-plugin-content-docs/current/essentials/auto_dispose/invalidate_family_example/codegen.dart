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
  // 使该提供者程序所有可能的参数组合无效。
  ref.invalidate(labelProvider);
  // 仅使特定组合无效
  ref.invalidate(labelProvider('John'));
}
/* SNIPPET END */
