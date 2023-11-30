// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'todo_list_notifier.dart';

part 'todo_list_notifier_add_todo.g.dart';

/* SNIPPET START */
@riverpod
class TodoList extends _$TodoList {
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
