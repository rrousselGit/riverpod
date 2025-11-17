// ignore_for_file: unnecessary_async, avoid_dynamic_calls

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/codegen.dart';

Future<List<Todo>> fetchTodosFromServer() async => [];

/* SNIPPET START */
class Todo {
  Todo({required this.task});
  final String task;
}

final todoListProvider = AsyncNotifierProvider<TodoList, List<Todo>>(
  TodoList.new,
);

class TodoList extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    persist(
      // We pass in the previously created Storage.
      // Do not "await" this. Riverpod will handle it for you.
      ref.watch(storageProvider.future),
      // A unique identifier for this state.
      // If your provider receives parameters, make sure to encode those
      // in the key as well.
      key: 'todo_list',
      // Encode/decode the state. Here, we're using a basic JSON encoding.
      // You can use any encoding you want, as long as your Storage supports it.
      encode: (todos) => todos.map((todo) => {'task': todo.task}).toList(),
      decode:
          (json) =>
              (json as List)
                  .map((todo) => Todo(task: todo['task'] as String))
                  .toList(),
    );

    // Regardless of whether some state was restored or not, we fetch the list of
    // todos from the server.
    return fetchTodosFromServer();
  }
}
