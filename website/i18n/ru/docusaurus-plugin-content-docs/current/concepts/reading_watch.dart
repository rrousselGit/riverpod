// ignore_for_file: omit_local_variable_types

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FilterType {
  none,
  completed,
}

abstract class Todo {
  bool get isCompleted;
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList(): super([]);
}

/* SNIPPET START */

final filterTypeProvider = StateProvider<FilterType>((ref) => FilterType.none);
final todosProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) => TodoList());

final filteredTodoListProvider = Provider((ref) {
  // получение фильтра и полного списка задач
  final FilterType filter = ref.watch(filterTypeProvider);
  final List<Todo> todos = ref.watch(todosProvider);

  switch (filter) {
    case FilterType.completed:
      // возвращает список выполненных задач
      return todos.where((todo) => todo.isCompleted).toList();
    case FilterType.none:
      // возвращает полный список всех задач
      return todos;
  }
});