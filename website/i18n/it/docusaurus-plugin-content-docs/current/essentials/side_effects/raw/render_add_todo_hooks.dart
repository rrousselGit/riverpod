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
    // L'operazione addTodo in sospeso. O null se nessuna è in attesa.
    final pendingAddTodo = useState<Future<void>?>(null);

    // Ascoltiamo l'operazione in sospeso per aggiornare l'interfaccia utente di conseguenza.
    final snapshot = useFuture(pendingAddTodo.value);

    // Calcoliamo se c'è uno stato di errore o meno.
    // Controlliamo qui lo stato di ConnectionState per gestire quando l'operazione viene ripetuta.
    final isErrored = snapshot.hasError && snapshot.connectionState != ConnectionState.waiting;

    return Row(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            // Se c'è stato un errore mostriamo il bottone in rosso
            backgroundColor: WidgetStatePropertyAll(
              isErrored ? Colors.red : null,
            ),
          ),
          onPressed: () async {
            // Assegniamo il future ritornato da 'addTodo' in una variabile
            final future = ref
                .read(todoListProvider.notifier)
                .addTodo(Todo(description: 'This is a new todo'));

            // Immagazziniamo il future nello stato locale
            pendingAddTodo.value = future;
          },
          child: const Text('Add todo'),
        ),
        // L'operazione è in sospeso, mostriamo un indicatore di progresso
        if (snapshot.connectionState == ConnectionState.waiting) ...[
          const SizedBox(width: 8),
          const CircularProgressIndicator(),
        ]
      ],
    );
  }
}
/* SNIPPET END */