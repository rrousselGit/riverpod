import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'rest_add_todo.dart';
import 'todo_list_notifier.dart' show Todo;

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Example());
  }
}

/* SNIPPET START */
class Example extends HookConsumerWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The pending addTodo operation. Or null if none is pending.
    final pendingAddTodo = useState<Future<void>?>(null);
    // We listen to the pending operation, to update the UI accordingly.
    final snapshot = useFuture(pendingAddTodo.value);

    // Compute whether there is an error state or not.
    // The connectionState check is here to handle when the operation is retried.
    final isErrored = snapshot.hasError &&
        snapshot.connectionState != ConnectionState.waiting;

    return Row(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            // If there is an error, we show the button in red
            backgroundColor: WidgetStateProperty.all(
              isErrored ? Colors.red : null,
            ),
          ),
          onPressed: () async {
            // We keep the future returned by addTodo in a variable
            final future = ref
                .read(todoListProvider.notifier)
                .addTodo(Todo(description: 'This is a new todo'));

            // We store that future in the local state
            pendingAddTodo.value = future;
          },
          child: const Text('Add todo'),
        ),
        // The operation is pending, let's show a progress indicator
        if (snapshot.connectionState == ConnectionState.waiting) ...[
          const SizedBox(width: 8),
          const CircularProgressIndicator(),
        ]
      ],
    );
  }
}
/* SNIPPET END */