// GENERATED from packages/riverpod/lib/src/core/mutations.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;
import 'package:material_ui/material_ui.dart';
import 'package:riverpod/experimental/mutation.dart';

class Todo {
  Todo({required this.title});
  final String title;
  String get id => title;
}

class User {
  String get id => '';
}

class TodoList extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => [];
  Future<void> addTodo(Todo todo) async {}
}

final todoListProvider = NotifierProvider<TodoList, List<Todo>>(TodoList.new);
final mutation = Mutation<void>();
late WidgetRef ref;
late Todo todo;
late User user;

dynamic snippet() async {
  final deleteTodoMutation = Mutation<void>();
  // ...

  // You can pass a unique object to the mutation upon watching it.
  final deleteTodo = ref.watch(deleteTodoMutation(todo.id));
  // ...

  ElevatedButton(
    onPressed: () {
      // Upon calling `run`, you will have to pass the same key as when
      // watching the mutation.
      deleteTodoMutation(todo.id).run(ref, (tsx) async {
        /* ... */
      });
    },
    child: const Text('Delete Todo'),
  );
}
