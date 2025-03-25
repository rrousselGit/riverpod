import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  Todo({
    required this.description,
    this.completed = false,
  });

  factory Todo.fromJson(Map<String, Object?> json) {
    return Todo(
      description: json['description']! as String,
      completed: json['completed']! as bool,
    );
  }

  final String description;
  final bool completed;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
        'completed': completed,
      };
}

/* SNIPPET START */
// 我們現在使用 AsyncNotifierProvider 替代 FutureProvider
final todoListProvider =
    AsyncNotifierProvider.autoDispose<TodoList, List<Todo>>(
  TodoList.new,
);

// 因為我們的邏輯是非同步的，所以我們需要使用 AsyncNotifier。
// 特別的，由於使用“autoDispose”修飾符，
// 我們需要 AutoDisposeAsyncNotifier。
class TodoList extends AutoDisposeAsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // 我們之前在 FutureProvider 中的業務邏輯現在位於 build 方法中。
    return [
      Todo(description: 'Learn Flutter', completed: true),
      Todo(description: 'Learn Riverpod'),
    ];
  }
}
