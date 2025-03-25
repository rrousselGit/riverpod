import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // Let's allow the UI to add todos.
  void addTodo(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  // Let's allow removing todos
  void removeTodo(String todoId) {
    todos.remove(todos.firstWhere((element) => element.id == todoId));
    notifyListeners();
  }

  // Let's mark a todo as completed
  void toggle(String todoId) {
    final todo = todos.firstWhere((todo) => todo.id == todoId);
    todo.completed = !todo.completed;
    notifyListeners();
  }
}

// Finally, we are using ChangeNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final todosProvider = ChangeNotifierProvider<TodosNotifier>((ref) {
  return TodosNotifier();
});
