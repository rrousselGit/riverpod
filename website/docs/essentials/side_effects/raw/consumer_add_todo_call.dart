import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../raw/todo_list_notifier.dart' show Todo;
import '../raw/todo_list_notifier_add_todo.dart';

/* SNIPPET START */
class Example extends ConsumerWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // Using "ref.read" combined with "myProvider.notifier", we can
        // obtain the class instance of our notifier. This enables us
        // to call the "addTodo" method.
        ref
            .read(todoListProvider.notifier)
            .addTodo(Todo(description: 'This is a new todo'));
      },
      child: const Text('Add todo'),
    );
  }
}
