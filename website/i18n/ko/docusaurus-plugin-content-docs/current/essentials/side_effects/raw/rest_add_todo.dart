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
    // POST 요청은 새 애플리케이션 상태와 일치하는 List<Todo>를 반환합니다.
    final response = await http.post(
      Uri.https('your_api.com', '/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    // API 응답을 디코딩하여 List<Todo>로 변환합니다.
    List<Todo> newTodos = (jsonDecode(response.body) as List)
        .cast<Map<String, Object?>>()
        .map(Todo.fromJson)
        .toList();

    // 로컬 캐시를 새 상태와 일치하도록 업데이트합니다.
    // 그러면 모든 리스너에게 알림이 전송됩니다.
    state = AsyncData(newTodos);
  }
/* SNIPPET END */
}
