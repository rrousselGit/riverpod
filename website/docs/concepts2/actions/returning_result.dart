import 'package:flutter_riverpod/experimental/action.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  Todo(this.title);

  final String title;
}

final todoListProvider = NotifierProvider<TodoListNotifier, List<Todo>>(
  TodoListNotifier.new,
);

class TodoListNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => const [];

  Future<Todo> addTodo(String title) async {
    final todo = Todo(title);
    state = [...state, todo];
    return todo;
  }
}

/* SNIPPET START */
Future<Todo> createTodo(WidgetRef ref, String title) {
  return action(() {
    return ref.read(todoListProvider.notifier).addTodo(title);
  });
}
/* SNIPPET END */
