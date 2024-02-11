import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

/* SNIPPET START */

class Todo {
  Todo({
    required this.id,
    required this.description,
    required this.completed,
  });

  String id;
  String description;
  bool completed;
}

class TodosNotifier extends ChangeNotifier {
  final todos = <Todo>[];

  // Добавление задач
  void addTodo(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  // Удаление задач
  void removeTodo(String todoId) {
    todos.remove(todos.firstWhere((element) => element.id == todoId));
    notifyListeners();
  }

  // Задача выполнена/не выполнена
  void toggle(String todoId) {
    for (final todo in todos) {
      if (todo.id == todoId) {
        todo.completed = !todo.completed;
        notifyListeners();
      }
    }
  }
}

// Используем ChangeNotifierProvider для взаимодействия с TodosNotifier
final todosProvider = ChangeNotifierProvider<TodosNotifier>((ref) {
  return TodosNotifier();
});
