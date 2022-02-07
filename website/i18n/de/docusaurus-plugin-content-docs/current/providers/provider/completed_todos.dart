import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo.dart';

/* SNIPPET START */

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // Wir erhalten die Liste aller Todos vom todosProvider
  final todos = ref.watch(todosProvider);

  // wir geben nur die erledigten ToDos zurück
  return todos.where((todo) => todo.isCompleted).toList();
});
