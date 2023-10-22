import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.freezed.dart';
part 'codegen.g.dart';

class Http {
  Future<String> get(String str) async => str;
  Future<String> delete(String str) async => str;
  Future<String> post(String str, Map<String, dynamic> body) async => str;
  Future<String> patch(String str, Map<String, dynamic> body) async => str;
}

final http = Http();

/* SNIPPET START */

@freezed
class Todo with _$Todo {
  factory Todo({
    required String id,
    required String description,
    required bool completed,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

// 这会生成一个 AsyncNotifier 和 AsyncNotifierProvider。
// Notifier类将会被传递给我们的 AsyncNotifierProvider。
// 这个类不应该在其“state”属性之外暴露状态，也就是说没有公共的获取属性的方法！
// 这个类上的公共方法将允许UI修改它的状态。
// 最后我们使用asyncTodosProvider(AsyncNotifierProvider)来允许UI与我们的Todos类进行交互。
@riverpod
class AsyncTodos extends _$AsyncTodos {
  Future<List<Todo>> _fetchTodo() async {
    final json = await http.get('api/todos');
    final todos = jsonDecode(json) as List<Map<String, dynamic>>;
    return todos.map(Todo.fromJson).toList();
  }

  @override
  FutureOr<List<Todo>> build() async {
    // 从远程仓库获取初始的待办清单
    return _fetchTodo();
  }

  Future<void> addTodo(Todo todo) async {
    // 将当前状态设置为加载中
    state = const AsyncValue.loading();
    //  将新的待办清单添加到远程仓库
    state = await AsyncValue.guard(() async {
      await http.post('api/todos', todo.toJson());
      return _fetchTodo();
    });
  }

  // 让我们允许删除待办清单
  Future<void> removeTodo(String todoId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await http.delete('api/todos/$todoId');
      return _fetchTodo();
    });
  }

  // 让我们把待办清单标记为已完成
  Future<void> toggle(String todoId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await http.patch(
        'api/todos/$todoId',
        <String, dynamic>{'completed': true},
      );
      return _fetchTodo();
    });
  }
}
