import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../todo/todo.dart';

part 'completed_todos.g.dart';

/* SNIPPET START */

@riverpod
List<Todo> completedTodos(CompletedTodosRef ref) {
  final todos = ref.watch(todosProvider);

  // we return only the completed todos
  return todos.where((todo) => todo.isCompleted).toList();
}
