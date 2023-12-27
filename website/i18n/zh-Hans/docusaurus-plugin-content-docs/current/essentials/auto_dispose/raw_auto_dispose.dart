import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
// 我们可以指定 autoDispose 来启用状态自动处置功能。
final provider = Provider.autoDispose<int>((ref) {
  return 0;
});
