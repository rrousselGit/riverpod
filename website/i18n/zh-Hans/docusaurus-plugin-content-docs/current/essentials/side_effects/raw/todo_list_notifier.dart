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
// 我们现在使用 AsyncNotifierProvider 替代 FutureProvider
final todoListProvider =
    AsyncNotifierProvider.autoDispose<TodoList, List<Todo>>(
  TodoList.new,
);

// 因为我们的逻辑是异步的，所以我们需要使用 AsyncNotifier。
// 特别的，由于使用“autoDispose”修饰符，
// 我们需要 AutoDisposeAsyncNotifier。
class TodoList extends AutoDisposeAsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // 我们之前在 FutureProvider 中的业务逻辑现在位于 build 方法中。
    return [
      Todo(description: 'Learn Flutter', completed: true),
      Todo(description: 'Learn Riverpod'),
    ];
  }
}
