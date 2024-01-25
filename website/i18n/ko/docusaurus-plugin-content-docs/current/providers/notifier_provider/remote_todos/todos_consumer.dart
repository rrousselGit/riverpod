// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'codegen.dart';

/* SNIPPET START */

class TodoListView extends ConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // rebuild the widget when the todo list changes
    final asyncTodos = ref.watch(asyncTodosProvider);

    // Let's render the todos in a scrollable list view
    return switch (asyncTodos) {
      AsyncData(:final value) => ListView(
          children: [
            for (final todo in value)
              CheckboxListTile(
                value: todo.completed,
                // When tapping on the todo, change its completed status
                onChanged: (value) {
                  ref.read(asyncTodosProvider.notifier).toggle(todo.id);
                },
                title: Text(todo.description),
              ),
          ],
        ),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
