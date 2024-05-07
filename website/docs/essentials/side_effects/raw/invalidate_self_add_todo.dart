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

  /* SNIPPET START */
  Future<void> addTodo(Todo todo) async {
    // {@template post}
    // We don't care about the API response
    // {@endtemplate}
    await http.post(
      Uri.https('your_api.com', '/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    // {@template invalidateSelf}
    // Once the post request is done, we can mark the local cache as dirty.
    // This will cause "build" on our notifier to asynchronously be called again,
    // and will notify listeners when doing so.
    // {@endtemplate}
    ref.invalidateSelf();

    // {@template future}
    // (Optional) We can then wait for the new state to be computed.
    // This ensures "addTodo" does not complete until the new state is available.
    // {@endtemplate}
    await future;
  }
/* SNIPPET END */
}
