// ignore_for_file: avoid_print, avoid_unused_constructor_parameters

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'from_change_notifier.g.dart';

class Todo {
  const Todo(this.id);
  Todo.fromJson(Object obj) : id = 0;

  final int id;
}

class Http {
  Future<List<Object>> get(String str) async => [str];
  Future<List<Object>> post(String str) async => [str];
}

final http = Http();

/* SNIPPET START */
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  FutureOr<List<Todo>> build() async {
    final json = await http.get('api/todos');

    return [...json.map(Todo.fromJson)];
  }

  Future<void> addTodo(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final json = await http.post('api/todos');

      return [...json.map(Todo.fromJson)];
    });
  }
}
