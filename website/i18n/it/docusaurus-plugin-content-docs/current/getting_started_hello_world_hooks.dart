// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Creiamo un "provider", il quale immagazzinerà un valore (qui "Hello world").
// Usare un provider ci permetterà di simulare/sovrascrivere il valore esposto.
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    // Per fare in modo che i widget leggano i provider, dobbiamo incapsulare
    // l'intera applicazione in un widget "ProviderScope"
    // Qui è dove lo stato dei nostri provider sarà salvato.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Nota: MyApp è un HookConsumerWidget, da hooks_riverpod.
class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Text(value),
        ),
      ),
    );
  }
}
