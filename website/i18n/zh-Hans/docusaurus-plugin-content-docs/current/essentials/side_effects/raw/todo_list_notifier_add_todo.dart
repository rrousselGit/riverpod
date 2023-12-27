// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'todo_list_notifier.dart';

final todoListProvider =
    AsyncNotifierProvider.autoDispose<TodoList, List<Todo>>(
  TodoList.new,
);

/* SNIPPET START */
class TodoList extends AutoDisposeAsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async => [/* ... */];

  Future<void> addTodo(Todo todo) async {
    await http.post(
      Uri.https('your_api.com', '/todos'),
      // 我们序列化 Todo 对象并将其 POST 到服务器。
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );
  }
}
