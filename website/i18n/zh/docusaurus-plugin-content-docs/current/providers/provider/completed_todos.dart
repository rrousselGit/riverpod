import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo.dart';

/* SNIPPET START */

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // 我们先从 todosProvider 中获取所有任务列表（todoList）
  final todos = ref.watch(todosProvider);

  // 然后，我们只返回已完成的任务
  return todos.where((todo) => todo.isCompleted).toList();
});
