// ignore_for_file: avoid_print, prefer_final_locals, omit_local_variable_types

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'todo_list_notifier.dart';

final todoListProvider = AsyncNotifierProvider.autoDispose<TodoList, List<Todo>>(
  TodoList.new,
);

class TodoList extends AutoDisposeAsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async => [/* ... */];

  Future<void> addTodo(Todo todo) async {
    // We don't care about the API response
    await http.post(
      Uri.https('your_api.com', '/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

/* SNIPPET START */
    final previousState = await future;
    // {@template mutable}
    // Mutable the previous list of todos.
    // {@endtemplate}
    previousState.add(todo);
    // {@template notify}
    // Manually notify listeners.
    // {@endtemplate}
    ref.notifyListeners();
/* SNIPPET END */
  }
}
