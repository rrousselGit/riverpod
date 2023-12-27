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
        // 使用“ref.read”与“myProvider.notifier”结合，
        // 我们可以获得通知者程序的类实例。
        // 这使我们能够调用“addTodo”方法。
        ref
            .read(todoListProvider.notifier)
            .addTodo(Todo(description: 'This is a new todo'));
      },
      child: const Text('Add todo'),
    );
  }
}
