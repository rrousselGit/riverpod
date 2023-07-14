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
  // récupère à la fois le filtre et la liste des todos
  final FilterType filter = ref.watch(filterTypeProvider);
  final List<Todo> todos = ref.watch(todosProvider);

  switch (filter) {
    case FilterType.completed:
      // renvoie la liste complétée des todos
      return todos.where((todo) => todo.isCompleted).toList();
    case FilterType.none:
      // renvoie la liste non filtrée des todos
      return todos;
  }
});