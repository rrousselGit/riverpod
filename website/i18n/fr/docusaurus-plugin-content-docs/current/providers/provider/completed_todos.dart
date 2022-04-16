import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo.dart';

/* SNIPPET START */

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // On obtient la liste de tous les todos à partir du todosProvider.
  final todos = ref.watch(todosProvider);

  // on retourne seulement les todos complétés
  return todos.where((todo) => todo.isCompleted).toList();
});
