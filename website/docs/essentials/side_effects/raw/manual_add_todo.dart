// ignore_for_file: avoid_print, prefer_final_locals, omit_local_variable_types

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'todo_list_notifier.dart';

final todoListProvider =
    AsyncNotifierProvider.autoDispose<TodoList, List<Todo>>(
  TodoList.new,
);

class TodoList extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async => [/* ... */];

  /* SNIPPET START */
  Future<void> addTodo(Todo todo) async {
    // We don't care about the API response
    await http.post(
      Uri.https('your_api.com', '/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    // We can then manually update the local cache. For this, we'll need to
    // obtain the previous state.
    // Caution: The previous state may still be loading or in error state.
    // A graceful way of handling this would be to read `this.future` instead
    // of `this.state`, which would enable awaiting the loading state, and
    // throw an error if the state is in error state.
    final previousState = await future;

    // We can then update the state, by creating a new state object.
    // This will notify all listeners.
    state = AsyncData([...previousState, todo]);
  }
/* SNIPPET END */
}
