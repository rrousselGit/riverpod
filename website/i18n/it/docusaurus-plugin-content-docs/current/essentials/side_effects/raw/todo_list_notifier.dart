import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  Todo({
    required this.description,
    this.completed = false,
  });

  factory Todo.fromJson(Map<String, Object?> json) {
    return Todo(
      description: json['description']! as String,
      completed: json['completed']! as bool,
    );
  }

  final String description;
  final bool completed;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
        'completed': completed,
      };
}

/* SNIPPET START */
// Ora usiamo AsyncNotifierProvider invece di FutureProvider
final todoListProvider = AsyncNotifierProvider.autoDispose<TodoList, List<Todo>>(
  TodoList.new,
);

// Usiamo un AsyncNotifier perché la nostra logica è asincrona.
// Più nello specifico, avremo di AutoDisposeAsyncNotifier
// per fruire del modificatore "autoDispose".
class TodoList extends AutoDisposeAsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // La logica che in precedenza avevamo nel nostro FutureProvider ora è nel metodo di build.
    return [
      Todo(description: 'Learn Flutter', completed: true),
      Todo(description: 'Learn Riverpod'),
    ];
  }
}
