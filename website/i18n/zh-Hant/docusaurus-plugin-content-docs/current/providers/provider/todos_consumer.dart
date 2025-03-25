// ignore_for_file: unused_local_variable

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'completed_todos/completed_todos.dart';

Widget build() {
  return
/* SNIPPET START */
Consumer(builder: (context, ref, child) {
  final completedTodos = ref.watch(completedTodosProvider);
  // TODO show the todos using a ListView/GridView/.../* SKIP */
  return Container();
  /* SKIP END */
});
/* SNIPPET END */
}
