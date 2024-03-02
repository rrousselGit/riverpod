// ignore_for_file: avoid_print, avoid_unused_constructor_parameters

import 'package:riverpod_annotation/riverpod_annotation.dart';

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
class MyNotifier extends AutoDisposeAsyncNotifier<List<Todo>> {
  @override
  FutureOr<List<Todo>> build() async {
    final json = await http.get('api/todos');

    return [...json.map(Todo.fromJson)];
  }

  Future<void> addTodo(Todo todo) async {
    // optional: state = const AsyncLoading();
    final json = await http.post('api/todos');
    final newTodos = [...json.map(Todo.fromJson)];
    state = AsyncData(newTodos);
  }
}

final myNotifierProvider = AsyncNotifierProvider.autoDispose<MyNotifier, int>(MyNotifier.new);
