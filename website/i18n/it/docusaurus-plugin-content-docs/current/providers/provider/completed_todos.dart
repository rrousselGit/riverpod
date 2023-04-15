import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo.dart';

/* SNIPPET START */

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // Otteniamo la lista di tutti i todo da todosProvider
  final todos = ref.watch(todosProvider);

  // restituiamo solo i todo completati
  return todos.where((todo) => todo.isCompleted).toList();
});
