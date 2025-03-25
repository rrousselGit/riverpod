import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
class Todo {
  Todo({
    required this.description,
    this.completed = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      description: json['description'] as String,
      completed: json['completed'] as bool,
    );
  }

  final String description;
  final bool completed;
}

final todoListProvider = FutureProvider.autoDispose<List<Todo>>((ref) async {
  // 模擬一個網路請求。這通常來自真實的 API
  return [
    Todo(description: 'Learn Flutter', completed: true),
    Todo(description: 'Learn Riverpod'),
  ];
});
