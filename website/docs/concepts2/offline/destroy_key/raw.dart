// ignore_for_file: unnecessary_async, avoid_dynamic_calls

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/codegen.dart';

Future<List<Todo>> fetchTodosFromServer() async => [];

class Todo {
  Todo({required this.task});
  final String task;
}

final todoListProvider = AsyncNotifierProvider<TodoList, List<Todo>>(
  TodoList.new,
);

/* SNIPPET START */
class TodoList extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    persist(
      ref.watch(storageProvider.future),
      // We can optionally pass a "destroyKey". When a new version of the application
      // is release with a different destroyKey, the old persisted state will be
      // deleted, and a brand new state will be created.
      // highlight-next-line
      options: const StorageOptions(destroyKey: '1.0'),
      // Persist as usual
      key: 'todo_list',
      encode: (todos) => todos.map((todo) => {'task': todo.task}).toList(),
      decode:
          (json) =>
              (json as List)
                  .map((todo) => Todo(task: todo['task'] as String))
                  .toList(),
    );

    return fetchTodosFromServer();
  }
}
