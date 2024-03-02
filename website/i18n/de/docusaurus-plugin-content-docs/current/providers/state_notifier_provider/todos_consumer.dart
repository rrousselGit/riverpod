// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todos.dart';

/* SNIPPET START */

class TodoListView extends ConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Widget neu aufbauen, wenn sich die ToDo-Liste ändert
    List<Todo> todos = ref.watch(todosProvider);

    // Lassen Sie uns die ToDos in einer scrollbaren Listenansicht darstellen
    return ListView(
      children: [
        for (final todo in todos)
          CheckboxListTile(
            value: todo.completed,
            // Wenn Sie auf das ToDo tippen, änder es seinen Erledigungsstatus
            onChanged: (value) =>
                ref.read(todosProvider.notifier).toggle(todo.id),
            title: Text(todo.description),
          ),
      ],
    );
  }
}
