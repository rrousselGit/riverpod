// ignore_for_file: avoid_print, avoid_unused_constructor_parameters

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_notifier.g.dart';

class Todo {
  Todo.fromJson(Object obj);
}

class Http {
  Future<List<Object>> get(String str) async => [str];
}

final http = Http();

/* SNIPPET START */
@riverpod
class AsyncTodosNotifier extends _$AsyncTodosNotifier {
  @override
  FutureOr<List<Todo>> build() async {
    final json = await http.get('api/todos');

    return [...json.map(Todo.fromJson)];
  }

  // ...
}
