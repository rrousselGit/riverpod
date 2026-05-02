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
        // Reads inside the callback keep providers alive
        // for the duration of the mutation.
        addTodo.run(ref, (tsx) async {
          final todoNotifier = tsx.get(todoNotifierProvider.notifier);

          // We perform a request using a Notifier.
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
