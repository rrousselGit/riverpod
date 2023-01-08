// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

// Avoir un compteur qui est incrémenté par le FloatingActionButton.
final counterProvider = StateProvider((ref) => 0);

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Nous voulons montrer un dialogue avec le compte sur un appui de bouton
    return Scaffold(
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (c) {
                    // Nous enveloppons la boîte de dialogue avec un widget ProviderScope, 
                    // fournissant le conteneur parent pour garantir que la boîte de dialogue 
                    // peut accéder aux mêmes providers qui sont accessibles par le widget Home.
                    return ProviderScope(
                      parent: ProviderScope.containerOf(context),
                      child: const AlertDialog(
                        content: CounterDisplay(),
                      ),
                    );
                  },
                );
              },
              child: const Text('Show Dialog'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            ref.read(counterProvider.notifier).state++;
          },
        ));
  }
}

class CounterDisplay extends ConsumerWidget {
  const CounterDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}
