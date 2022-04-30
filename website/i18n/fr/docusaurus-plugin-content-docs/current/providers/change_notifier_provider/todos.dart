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

  // Permettons à l'interface utilisateur d'ajouter des todos.
  void addTodo(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  // Permettons la suppression des todos
  void removeTodo(String todoId) {
    todos.remove(todos.firstWhere((element) => element.id == todoId));
    notifyListeners();
  }

  // Marquons une tâche comme étant terminée
  void toggle(String todoId) {
    for (final todo in todos) {
      if (todo.id == todoId) {
        todo.completed = !todo.completed;
        notifyListeners();
      }
    }
  }
}

// Enfin, nous utilisons StateNotifierProvider pour permettre à l'IU d'interagir
// avec notre TodosNotifier class.
final todosProvider = ChangeNotifierProvider<TodosNotifier>((ref) {
  return TodosNotifier();
});
