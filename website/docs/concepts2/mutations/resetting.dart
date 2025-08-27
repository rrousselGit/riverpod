import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/experimental/mutation.dart';

final addTodo = Mutation<Todo>();

class Todo {}

class ResetAddTodoButton extends ConsumerWidget {
  const ResetAddTodoButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /* SNIPPET START */
    return ElevatedButton(
      onPressed: () {
        // Reset the mutation to its idle state.
        addTodo.reset(ref);
      },
      child: const Text('Reset mutation'),
    );
    /* SNIPPET END */
  }
}
