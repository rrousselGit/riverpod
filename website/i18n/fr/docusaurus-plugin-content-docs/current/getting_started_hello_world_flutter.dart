// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Nous créons un "provider", qui va stocker une valeur (ici "Hello world").
// En utilisant un provider, cela nous permet de simuler/supprimer la valeur exposée.
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    // Pour que les widgets puissent lire les providers, nous devons 
    // envelopper l'application entière dans un widget "ProviderScope".
    // C'est là où l'état de nos providers sera stocké.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Extend ConsumerWidget au lieu du StatelessWidget, qui est exposé par Riverpod.
class MyApp extends ConsumerWidget {
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
