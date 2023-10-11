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
  // 获取筛选器和待办清单列表
  final FilterType filter = ref.watch(filterTypeProvider);
  final List<Todo> todos = ref.watch(todosProvider);

  switch (filter) {
    case FilterType.completed:
      // 返回完成的待办清单
      return todos.where((todo) => todo.isCompleted).toList();
    case FilterType.none:
      // 返回所有的待办清单
      return todos;
  }
}
