// ignore_for_file: unused_local_variable

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'completed_todos.dart';

Widget build() {
return
/* SNIPPET START */
Consumer(builder: (context, ref, child) {
  final completedTodos = ref.watch(completedTodosProvider);
  // TODO ListView/GridView/... を使って Todo リストを表示する /* SKIP */
  return Container();
  /* SKIP END */
});
/* SNIPPET END */
}
