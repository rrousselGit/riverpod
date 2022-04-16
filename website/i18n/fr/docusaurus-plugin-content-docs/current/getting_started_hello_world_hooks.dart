// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

// Note : MyApp est un HookConsumerWidget, de flutter_hooks.
class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pour lire notre provider, on peut utiliser le hook "ref.watch", 
    // ce qui n'est possible que parce que MyApp est un HookConsumerWidget.
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
