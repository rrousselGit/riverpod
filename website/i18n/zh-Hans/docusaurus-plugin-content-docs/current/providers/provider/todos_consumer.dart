// ignore_for_file: unused_local_variable

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'completed_todos/completed_todos.dart';

Widget build() {
  return
/* SNIPPET START */
Consumer(builder: (context, ref, child) {
  final completedTodos = ref.watch(completedTodosProvider);
  // TODO 使用ListView/GridView/……展示待办清单列表 /* SKIP */
  return Container();
  /* SKIP END */
},);
/* SNIPPET END */
}
