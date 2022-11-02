import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../todo/raw.dart';

/* SNIPPET START */

@riverpod
List<Todo> completedTodos(CompletedTodosRef ref) {
  final todos = ref.watch(todosProvider);

  // we return only the completed todos
  return todos.where((todo) => todo.isCompleted).toList();
}
