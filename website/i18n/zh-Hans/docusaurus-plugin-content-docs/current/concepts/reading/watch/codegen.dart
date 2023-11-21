// ignore_for_file: omit_local_variable_types, avoid_types_on_closure_parameters, avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

enum FilterType {
  none,
  completed,
}

abstract class Todo {
  bool get isCompleted;
}

/* SNIPPET START */

@riverpod
FilterType filterType(FilterTypeRef ref) {
  return FilterType.none;
}

@riverpod
class Todos extends _$Todos {
  @override
  List<Todo> build() {
    return [];
  }
}

@riverpod
List<Todo> filteredTodoList(FilteredTodoListRef ref) {
  // obtains both the filter and the list of todos
  final FilterType filter = ref.watch(filterTypeProvider);
  final List<Todo> todos = ref.watch(todosProvider);

  switch (filter) {
    case FilterType.completed:
      // return the completed list of todos
      return todos.where((todo) => todo.isCompleted).toList();
    case FilterType.none:
      // returns the unfiltered list of todos
      return todos;
  }
}
