import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_list_provider.freezed.dart';
part 'todo_list_provider.g.dart';

@freezed
class Todo with _$Todo {
  factory Todo({
    required String description,
    @Default(false) bool completed,
  }) = _Todo;
}

/* SNIPPET START */
@riverpod
Future<List<Todo>> todoList(TodoListRef ref) async {
  // {@template note}
  // Simulate a network request. This would normally come from a real API
  // {@endtemplate}
  return [
    Todo(description: 'Learn Flutter', completed: true),
    Todo(description: 'Learn Riverpod'),
  ];
}
