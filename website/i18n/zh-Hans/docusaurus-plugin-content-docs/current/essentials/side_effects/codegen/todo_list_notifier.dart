import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_list_notifier.freezed.dart';
part 'todo_list_notifier.g.dart';

@freezed
class Todo with _$Todo {
  factory Todo({
    required String description,
    @Default(false) bool completed,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

/* SNIPPET START */
@riverpod
class TodoList extends _$TodoList {
  @override
  Future<List<Todo>> build() async {
    // 我们之前在 FutureProvider 中的业务逻辑现在位于 build 方法中。
    return [
      Todo(description: 'Learn Flutter', completed: true),
      Todo(description: 'Learn Riverpod'),
    ];
  }
}
