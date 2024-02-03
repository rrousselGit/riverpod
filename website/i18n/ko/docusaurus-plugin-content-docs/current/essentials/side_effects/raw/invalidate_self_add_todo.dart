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
    // API 응답은 신경 쓰지 않습니다.
    await http.post(
      Uri.https('your_api.com', '/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    // 포스트 요청이 완료되면 로컬 캐시를 더티(dirty)로 표시할 수 있습니다.
    // 이렇게 하면 notifier의 "build"가 비동기적으로 다시 호출되고, 이 때 리스너(listener)에게 알림이 전송됩니다.

    ref.invalidateSelf();

    // (선택 사항) 그런 다음 새 상태가 계산될 때까지 기다릴 수 있습니다.
    // 이렇게 하면 새 상태를 사용할 수 있을 때까지 "addTodo"가 완료되지 않습니다.
    await future;
  }
/* SNIPPET END */
}
