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
        // "ref.read"를 "myProvider.notifier"와 사용하면 
        // notifier의 클래스 인스턴스를 얻을 수 있습니다. 
        // 이를 통해 "addTodo" 메서드를 호출할 수 있습니다.
        ref
            .read(todoListProvider.notifier)
            .addTodo(Todo(description: 'This is a new todo'));
      },
      child: const Text('Add todo'),
    );
  }
}
