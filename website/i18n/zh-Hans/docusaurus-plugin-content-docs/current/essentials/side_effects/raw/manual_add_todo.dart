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

    // 然后我们可以手动更新本地缓存。为此，我们需要获取之前的状态。
    // 注意：之前的状态可能仍在加载或处于错误状态。
    // 处理此问题的一种优雅方法是读取“this.future”而不是“this.state”，
    // 这将允许等待加载状态，并在状态处于错误状态时抛出错误。
    final previousState = await future;

    // 然后我们可以通过创建一个新的状态对象来更新状态。
    // 这将通知所有监听者。
    state = AsyncData([...previousState, todo]);
  }
/* SNIPPET END */
}
