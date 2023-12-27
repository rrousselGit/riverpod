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
    // POST 请求将返回与新应用程序状态匹配的 List<Todo>
    final response = await http.post(
      Uri.https('your_api.com', '/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    // 我们解码 API 响应并将其转换为 List<Todo>
    List<Todo> newTodos = (jsonDecode(response.body) as List)
        .cast<Map<String, Object?>>()
        .map(Todo.fromJson)
        .toList();

    // 我们更新本地缓存以匹配新状态。
    // 这将通知所有的监听程序。
    state = AsyncData(newTodos);
  }
/* SNIPPET END */
}
