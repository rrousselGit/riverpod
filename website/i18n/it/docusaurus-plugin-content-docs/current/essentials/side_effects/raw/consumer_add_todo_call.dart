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
        // Usando "ref.read" combinato con "myProvider.notifier" possiamo
        // ottenere l'istanza della classe del nostro notifier. Ciò ci permette di
        // chiamare il metodo "addTodo".
        ref.read(todoListProvider.notifier).addTodo(Todo(description: 'Questo è un nuovo todo'));
      },
      child: const Text('Aggiungi todo'),
    );
  }
}
