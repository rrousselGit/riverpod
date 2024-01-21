// ignore_for_file: omit_local_variable_types

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'combine.g.dart';

abstract class Todo {
  bool get completed;
}

enum Filter {
  all,
  completed,
  uncompleted,
}

final todosProvider = StateProvider<List<Todo>>((ref) => []);
final filterProvider = StateProvider<Filter>((ref) => Filter.all);

/* SNIPPET START */

@riverpod
List<Todo> filteredTodos(FilteredTodosRef ref) {
  // Providers can consume other providers using the "ref" object.
  // With ref.watch, providers will automatically update if the watched values changes.
  final List<Todo> todos = ref.watch(todosProvider);
  final Filter filter = ref.watch(filterProvider);

  switch (filter) {
    case Filter.all:
      return todos;
    case Filter.completed:
      return todos.where((todo) => todo.completed).toList();
    case Filter.uncompleted:
      return todos.where((todo) => !todo.completed).toList();
  }
}
