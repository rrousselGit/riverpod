import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../todo/todo.dart';

part 'completed_todos.g.dart';

/* SNIPPET START */

@riverpod
List<Todo> completedTodos(CompletedTodosRef ref) {
  final todos = ref.watch(todosProvider);

  // 我们只返回完成的待办事项
  return todos.where((todo) => todo.isCompleted).toList();
}
