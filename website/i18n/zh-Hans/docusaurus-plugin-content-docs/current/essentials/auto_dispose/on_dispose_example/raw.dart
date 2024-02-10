// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
final provider = StreamProvider<int>((ref) {
  final controller = StreamController<int>();

  // 当状态被处置时，我们关闭 StreamController。
  ref.onDispose(controller.close);

  // TO-DO: 在 StreamController 中推送一些值
  return controller.stream;
});
/* SNIPPET END */
