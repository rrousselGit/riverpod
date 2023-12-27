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
    // 我们不关心 API 响应
    await http.post(
      Uri.https('your_api.com', '/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    // 一旦post请求完成，我们就可以将本地缓存标记为脏。
    // 这将导致我们的通知者程序上的“build”再次异步调用，
    // 并在执行此操作时通知监听者。
    ref.invalidateSelf();

    // （可选）然后我们可以等待新状态的计算。
    // 这确保了“addTodo”在新状态可用之前不会完成。
    await future;
  }
/* SNIPPET END */
}
