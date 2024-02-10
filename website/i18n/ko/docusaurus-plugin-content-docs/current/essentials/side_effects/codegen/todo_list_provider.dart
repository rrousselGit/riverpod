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
  // 네트워크 요청을 시뮬레이션합니다. 이는 일반적으로 실제 API로부터 수신됩니다.
  return [
    Todo(description: 'Learn Flutter', completed: true),
    Todo(description: 'Learn Riverpod'),
  ];
}
