import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo.dart';

/* SNIPPET START */

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // todosProvider から Todo リストの内容をすべて取得
  final todos = ref.watch(todosProvider);

  // 完了タスクのみをリストにして値として返す
  return todos.where((todo) => todo.isCompleted).toList();
});
