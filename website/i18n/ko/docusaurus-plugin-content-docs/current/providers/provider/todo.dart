// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

class Todo {
  Todo(this.description, this.isCompleted);
  final bool isCompleted;
  final String description;
}

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  void addTodo(Todo todo) {
    state = [...state, todo];
  }
  // TODO "removeTodo"와 같은 다른 메소드들을 추가하기
}

final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
