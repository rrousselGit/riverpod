import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Http {
  Future<String> get(String str) async => str;
  Future<String> delete(String str) async => str;
  Future<String> post(String str, Map<String, dynamic> body) async => str;
  Future<String> patch(String str, Map<String, dynamic> body) async => str;
}

final http = Http();

/* SNIPPET START */

// 最好使用不可变状态。
// 我们还可以使用像 freezed 这样的package来帮助实现不可变。
@immutable
class Todo {
  const Todo({
    required this.id,
    required this.description,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      description: map['description'] as String,
      completed: map['completed'] as bool,
    );
  }

  // 在我们的类中所有的属性都应该是 `final` 的。
  final String id;
  final String description;
  final bool completed;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'description': description,
        'completed': completed,
      };
}

// Notifier类将会被传递给我们的NotifierProvider。
// 这个类不应该在其“state”属性之外暴露状态，也就是说没有公共的获取属性的方法！
// 这个类上的公共方法将允许UI修改它的状态。
class AsyncTodosNotifier extends AsyncNotifier<List<Todo>> {
  Future<List<Todo>> _fetchTodo() async {
    final json = await http.get('api/todos');
    final todos = jsonDecode(json) as List<Map<String, dynamic>>;
    return todos.map((todo) => Todo.fromJson(todo)).toList();
  }

  @override
  Future<List<Todo>> build() async {
    // 从远程仓库获取初始的待办清单
    return _fetchTodo();
  }

  Future<void> addTodo(Todo todo) async {
    // 将当前状态设置为加载中
    state = const AsyncValue.loading();
    // 将新的待办清单添加到远程仓库
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

// 最后，我们使用NotifierProvider来允许UI与我们的TodosNotifier类交互。
final asyncTodosProvider =
    AsyncNotifierProvider<AsyncTodosNotifier, List<Todo>>(() {
  return AsyncTodosNotifier();
});
