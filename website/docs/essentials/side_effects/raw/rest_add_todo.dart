// ignore_for_file: avoid_print, prefer_final_locals, omit_local_variable_types

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'todo_list_notifier.dart';

final todoListProvider =
    AsyncNotifierProvider.autoDispose<TodoList, List<Todo>>(
  TodoList.new,
);

class TodoList extends AutoDisposeAsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async => [/* ... */];

  /* SNIPPET START */
  Future<void> addTodo(Todo todo) async {
    // The POST request will return a List<Todo> matching the new application state
    final response = await http.post(
      Uri.https('your_api.com', '/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    // We decode the API response and convert it to a List<Todo>
    List<Todo> newTodos = (jsonDecode(response.body) as List)
        .cast<Map<String, Object?>>()
        .map(Todo.fromJson)
        .toList();

    // We update the local cache to match the new state.
    // This will notify all listeners.
    state = AsyncData(newTodos);
  }
/* SNIPPET END */
}
