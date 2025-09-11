import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/experimental/mutation.dart';

final addTodo = Mutation<void>();

/* SNIPPET START */
class Example extends ConsumerWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We listen to the current state of the "addTodo" mutation.
    // Listening to this will not perform any side effects by itself.
    /* highlight-next-line */
    final addTodoState = ref.watch(addTodo);

    return Row(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            // If there is an error, we show the button in red
            /* highlight-next-line */
            backgroundColor: switch (addTodoState) {
              MutationError() => const WidgetStatePropertyAll(Colors.red),
              _ => null,
            },
          ),
          onPressed: () {
            addTodo.run(ref, (tsx) async {
              // todo
            });
          },
          child: const Text('Add todo'),
        ),

        // The operation is pending, let's show a progress indicator
        /* highlight-next-line */
        if (addTodoState is MutationPending) ...[
          const SizedBox(width: 8),
          const CircularProgressIndicator(),
        ],
      ],
    );
  }
}
