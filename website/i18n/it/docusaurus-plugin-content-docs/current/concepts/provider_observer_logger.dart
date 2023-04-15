// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

// Un esempio di contatore implementato con Riverpod con Logger

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}

void main() {
  runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    // Aggiungere ProviderScope abilita Riverpod per l'intero progetto
    // Aggiungiamo il nostro Logger alla lista degli osservabili (observers)
    ProviderScope(observers: [Logger()], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

final counterProvider = StateProvider((ref) => 0, name: 'counter');

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Counter example')),
      body: Center(
        child: Text('$count'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
