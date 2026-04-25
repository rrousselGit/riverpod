import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/action.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoListProvider = NotifierProvider<TodoListNotifier, List<String>>(
  TodoListNotifier.new,
);

class TodoListNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => const [];

  Future<void> addTodo(String title) async {
    state = [...state, title];
  }
}

/* SNIPPET START */
class AddTodoButton extends ConsumerWidget {
  const AddTodoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: voidAction(() async {
        await ref.read(todoListProvider.notifier).addTodo('Eat a cookie');
      }),
      child: const Text('Add todo'),
    );
  }
}

/* SNIPPET END */
