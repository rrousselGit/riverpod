import 'package:flutter/material.dart';
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
class Example extends ConsumerStatefulWidget {
  const Example({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExampleState();
}

class _ExampleState extends ConsumerState<Example> {
  // {@template raw_pendingAddTodo}
  // The pending addTodo operation. Or null if none is pending.
  // {@endtemplate}
  Future<void>? _pendingAddTodo;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // {@template raw_listen}
      // We listen to the pending operation, to update the UI accordingly.
      // {@endtemplate}
      future: _pendingAddTodo,
      builder: (context, snapshot) {
        // {@template raw_compute}
        // Compute whether there is an error state or not.
        // The connectionState check is here to handle when the operation is retried.
        // {@endtemplate}
        final isErrored = snapshot.hasError && snapshot.connectionState != ConnectionState.waiting;

        return Row(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                // {@template raw_isError}
                // If there is an error, we show the button in red
                // {@endtemplate}
                backgroundColor: WidgetStatePropertyAll(
                  isErrored ? Colors.red : null,
                ),
              ),
              onPressed: () {
                // {@template raw_future}
                // We keep the future returned by addTodo in a variable
                // {@endtemplate}
                final future = ref
                    .read(todoListProvider.notifier)
                    .addTodo(Todo(description: 'This is a new todo'));

                // {@template raw_state}
                // We store that future in the local state
                // {@endtemplate}
                setState(() {
                  _pendingAddTodo = future;
                });
              },
              child: const Text('Add todo'),
            ),
            // {@template raw_progress}
            // The operation is pending, let's show a progress indicator
            // {@endtemplate}
            if (snapshot.connectionState == ConnectionState.waiting) ...[
              const SizedBox(width: 8),
              const CircularProgressIndicator(),
            ]
          ],
        );
      },
    );
  }
}
/* SNIPPET END */