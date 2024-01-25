// ignore_for_file: avoid_print, avoid_unused_constructor_parameters

import 'package:hooks_riverpod/hooks_riverpod.dart';

class Todo {
  Todo.fromJson(Object obj);
}

class Http {
  Future<List<Object>> get(String str) async => [str];
}

final http = Http();

/* SNIPPET START */
class AsyncTodosNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  AsyncTodosNotifier() : super(const AsyncLoading()) {
    _postInit();
  }

  Future<void> _postInit() async {
    state = await AsyncValue.guard(() async {
      final json = await http.get('api/todos');

      return [...json.map(Todo.fromJson)];
    });
  }

  // ...
}
