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
  TodoList() : super([]);
}

/* SNIPPET START */

final filterTypeProvider = StateProvider<FilterType>((ref) => FilterType.none);
final todosProvider =
    StateNotifierProvider<TodoList, List<Todo>>((ref) => TodoList());

final filteredTodoListProvider = Provider((ref) {
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
});
