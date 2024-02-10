// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';

late WidgetRef ref;

/* SNIPPET START */
final provider = Provider.autoDispose.family<String, String>((ref, name) {
  return 'Hello $name';
});

// ...

void onTap() {
  // 使该提供者程序所有可能的参数组合无效。
  ref.invalidate(provider);
  // 仅使特定组合无效
  ref.invalidate(provider('John'));
}
/* SNIPPET END */
