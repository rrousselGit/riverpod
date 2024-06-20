// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todos.dart';

/* SNIPPET START */

class TodoListView extends ConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // `todos` listesi değiştiğinde widget'ı yeniden oluştur
    List<Todo> todos = ref.watch(todosProvider);

    // `todos` öğelerini bir ListView içinde göstereceğiz
    return ListView(
      children: [
        for (final todo in todos)
          CheckboxListTile(
            value: todo.completed,
            // Bir `todo`ya dokunduğunuzda, durumunu tamamlanmış olarak değiştirin
            onChanged: (value) =>
                ref.read(todosProvider.notifier).toggle(todo.id),
            title: Text(todo.description),
          ),
      ],
    );
  }
}
