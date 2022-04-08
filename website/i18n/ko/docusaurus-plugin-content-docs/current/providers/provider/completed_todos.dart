import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo.dart';

/* SNIPPET START */

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // todosProvider로부터 모든 할일(todos)목록을 가져옵니다.
  final todos = ref.watch(todosProvider);

  // 완료된(completed) 할일(todos)들만 반환합니다.
  return todos.where((todo) => todo.isCompleted).toList();
});
