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
    // La logica che precedentemente avevamo nel nostro FutureProvider è ora nel metodo 'build'.
    return [
      Todo(description: 'Learn Flutter', completed: true),
      Todo(description: 'Learn Riverpod'),
    ];
  }
}
