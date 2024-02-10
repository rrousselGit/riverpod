import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../todo_list_provider/raw.dart';

part 'codegen.g.dart';

enum Filter {
  none,
  completed,
  uncompleted,
}

final filterProvider = StateProvider((ref) => Filter.none);

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
