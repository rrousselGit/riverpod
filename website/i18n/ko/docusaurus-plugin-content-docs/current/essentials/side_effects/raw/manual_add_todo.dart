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

  /* SNIPPET START */
  Future<void> addTodo(Todo todo) async {
    // API 응답은 신경 쓰지 않습니다.
    await http.post(
      Uri.https('your_api.com', '/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    // 그런 다음 로컬 캐시를 수동으로 업데이트할 수 있습니다. 이를 위해서는 이전 상태를 가져와야 합니다.
    // 주의: 이전 상태가 여전히 로딩 중이거나 오류 상태일 수 있습니다.
    // 이 문제를 우아하게 처리하는 방법은 `this.state` 대신 `this.future`를 읽어서 로딩 상태를 기다리게 하고
    // 상태가 오류 상태인 경우 오류를 발생시키는 것입니다.
    final previousState = await future;

    // 그런 다음 새 상태 객체를 생성하여 상태를 업데이트할 수 있습니다.
    // 그러면 모든 리스너에게 알림이 전송됩니다.
    state = AsyncData([...previousState, todo]);
  }
/* SNIPPET END */
}
