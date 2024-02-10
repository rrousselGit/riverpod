import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../todo_list_provider/codegen.dart';

part 'codegen.g.dart';

enum Filter {
  none,
  completed,
  uncompleted,
}

@riverpod
Filter filter(FilterRef ref) {
  return Filter.none;
}

/* SNIPPET START */

@riverpod
List<Todo> filteredTodoList(FilteredTodoListRef ref) {
  final filter = ref.watch(filterProvider);
  final todos = ref.watch(todoListProvider);

  switch (filter) {
    case Filter.none:
      return todos;
    case Filter.completed:
      return todos.where((todo) => todo.completed).toList();
    case Filter.uncompleted:
      return todos.where((todo) => !todo.completed).toList();
  }
}
