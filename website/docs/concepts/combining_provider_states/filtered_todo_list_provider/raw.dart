import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../todo_list_provider/raw.dart';

enum Filter {
  none,
  completed,
  uncompleted,
}

final filterProvider = StateProvider((ref) => Filter.none);

/* SNIPPET START */

final filteredTodoListProvider = Provider<List<Todo>>((ref) {
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
});