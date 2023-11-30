import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_list_provider.freezed.dart';
part 'todo_list_provider.g.dart';

/* SNIPPET START */
@freezed
class Todo with _$Todo {
  factory Todo({
    required String description,
    @Default(false) bool completed,
  }) = _Todo;
}

@riverpod
Future<List<Todo>> todoList(TodoListRef ref) async {
  // 模拟一个网络请求。这通常来自真实的 API
  return [
    Todo(description: 'Learn Flutter', completed: true),
    Todo(description: 'Learn Riverpod'),
  ];
}
