// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

// Have a counter that is being incremented by the FloatingActionButton
final counterProvider = StateProvider((ref) => 0);

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We want to show a dialog with the count on a button press
    return Scaffold(
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (c) {
                    // We wrap the dialog with a ProviderScope widget, providing the
                    // parent container to ensure the dialog can access the same providers
                    // that are accessible by the Home widget.
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
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}
