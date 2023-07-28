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

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

@riverpod
Future<List<Todo>> todoList(TodoListRef ref) async {
  // Simulate a network request. This would normally come from a real API
  return [
    Todo(description: 'Learn Flutter', completed: true),
    Todo(description: 'Learn Riverpod'),
  ];
}
