import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/experimental/mutation.dart';

final addTodo = Mutation<Todo>();

class Todo {
  Todo({required this.id, required this.title});
  final String id;
  final String title;
}

final todoNotifierProvider = NotifierProvider<TodoNotifier, Todo>(
  TodoNotifier.new,
);

class TodoNotifier extends Notifier<Todo> {
  @override
  Todo build() {
    return Todo(id: '', title: '');
  }

  Future<Todo> addTodo(String title) async {
    final todo = Todo(id: UniqueKey().toString(), title: title);
    state = todo;
    return todo;
  }
}

class AddTodoButton extends ConsumerWidget {
  const AddTodoButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /* SNIPPET START */
    return ElevatedButton(
      onPressed: () {
        // Trigger the mutation, and run the callback.
        // During the callback, we obtain a MutationTransaction (tsx) object
        // which we can use to access providers and perform operations.
        addTodo.run(ref, (tsx) async {
          // We use tsx.get to access providers within mutations.
          // This will keep the provider alive for the duration of the operation.
          final todoNotifier = tsx.get(todoNotifierProvider.notifier);

          // We perform a perform request using a Notifier.
          final createdTodo = await todoNotifier.addTodo('Eat a cookie');

          // We return the created todo. This enables our UI to show information
          // about the created todo, such as its ID/creation date/etc.
          return createdTodo;
        });
      },
      child: const Text('Add todo'),
    );
    /* SNIPPET END */
  }
}
