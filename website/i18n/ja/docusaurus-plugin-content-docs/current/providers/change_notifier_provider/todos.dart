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

  // UI 側から Todo アイテムを追加できるようにする
  void addTodo(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  // Todo アイテムの削除
  void removeTodo(String todoId) {
    todos.remove(todos.firstWhere((element) => element.id == todoId));
    notifyListeners();
  }

  // Todo の完了ステータスの変更
  void toggle(String todoId) {
    for (final todo in todos) {
      if (todo.id == todoId) {
        todo.completed = !todo.completed;
        notifyListeners();
      }
    }
  }
}

// 最後に ChangeNotifierProvider を通じて UI 側から
// TodosNotifier を監視・操作できるようにする
final todosProvider = ChangeNotifierProvider<TodosNotifier>((ref) {
  return TodosNotifier();
});
