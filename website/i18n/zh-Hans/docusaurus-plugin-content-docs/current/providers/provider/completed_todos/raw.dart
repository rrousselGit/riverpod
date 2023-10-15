import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../todo/raw.dart';

/* SNIPPET START */

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // 我们从todosProvider获取所有待办清单
  final todos = ref.watch(todosProvider);

  // // 我们只返回完成的待办事项
  return todos.where((todo) => todo.isCompleted).toList();
});
