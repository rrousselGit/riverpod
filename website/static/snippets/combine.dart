import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Todo {
  bool get completed;
}

enum Filter {
  all,
  completed,
  uncompleted,
}

/* SNIPPET START */

final todosProvider = StateProvider<List<Todo>>((ref) => []);
final filterProvider = StateProvider<Filter>((ref) => Filter.all);

final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todosProvider);
  switch (ref.watch(filterProvider)) {
    case Filter.all:
      return todos;
    case Filter.completed:
      return todos.where((todo) => todo.completed).toList();
    case Filter.uncompleted:
      return todos.where((todo) => !todo.completed).toList();
  }
});
