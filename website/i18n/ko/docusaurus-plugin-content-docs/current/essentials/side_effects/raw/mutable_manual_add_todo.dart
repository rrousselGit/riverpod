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

  Future<void> addTodo(Todo todo) async {
    // API 응답은 신경 쓰지 않습니다.
    await http.post(
      Uri.https('your_api.com', '/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    /* SNIPPET START */
    final previousState = await future;
    // 이전 할 일 목록을 변경합니다. (Mutable)
    previousState.add(todo);
    // 리스너에게 수동으로 알림을 전송합니다.
    ref.notifyListeners();
/* SNIPPET END */
  }
}
