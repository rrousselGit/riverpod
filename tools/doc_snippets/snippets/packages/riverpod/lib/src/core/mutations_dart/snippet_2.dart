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

final addTodoMutation = Mutation<void>();

Widget build(BuildContext context, WidgetRef ref) {
  final addTodo = ref.watch(addTodoMutation);

  switch (addTodo) {
    case MutationIdle():
      return ElevatedButton(
        onPressed: () {
          /* Add a todo. See further down */
        },
        child: const Text('Add Todo'),
      );
    case MutationPending():
      return const CircularProgressIndicator();
    case MutationError():
      return Text('An error occurred: ${addTodo.error}');
    case MutationSuccess():
      return const Text('Todo added successfully!');
  }
}
