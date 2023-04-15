import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo.dart';

/* SNIPPET START */

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // Obtenemos la lista de tareas (todos) del `todosProvider`
  final todos = ref.watch(todosProvider);

  // Devolvemos solo los `todos` completados
  return todos.where((todo) => todo.isCompleted).toList();
});
