import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../todo/raw.dart';

/* SNIPPET START */

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // We obtain the list of all todos from the todosProvider
  final todos = ref.watch(todosProvider);

  // we return only the completed todos
  return todos.where((todo) => todo.isCompleted).toList();
});
