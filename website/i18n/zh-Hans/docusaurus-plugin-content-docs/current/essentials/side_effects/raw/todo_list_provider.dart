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
  // 模拟一个网络请求。这通常来自真实的 API
  return [
    Todo(description: 'Learn Flutter', completed: true),
    Todo(description: 'Learn Riverpod'),
  ];
});
