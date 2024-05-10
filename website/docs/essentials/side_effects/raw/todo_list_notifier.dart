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
// {@template note}
// We now use AsyncNotifierProvider instead of FutureProvider
// {@endtemplate}
final todoListProvider =
    AsyncNotifierProvider.autoDispose<TodoList, List<Todo>>(
  TodoList.new,
);

// {@template autoDispose}
// We use an AsyncNotifier because our logic is asynchronous.
// More specifically, we'll need AutoDisposeAsyncNotifier because
// of the "autoDispose" modifier.
// {@endtemplate}
class TodoList extends AutoDisposeAsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // {@template build_method}
    // The logic we previously had in our FutureProvider is now in the build method.
    // {@endtemplate}
    return [
      Todo(description: 'Learn Flutter', completed: true),
      Todo(description: 'Learn Riverpod'),
    ];
  }
}
