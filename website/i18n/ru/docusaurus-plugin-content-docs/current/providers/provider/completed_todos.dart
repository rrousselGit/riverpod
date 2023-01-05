import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo.dart';

/* SNIPPET START */

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // Получаем список всех задач из todosProvider
  final todos = ref.watch(todosProvider);

  // Возвращаем только выполненные задачи
  return todos.where((todo) => todo.isCompleted).toList();
});
