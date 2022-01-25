// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Wir erstellen einen "Provider", der einen Wert speichern wird (hier "Hello world").
// Durch die Nutzung eines Provider, ist es uns erlaubt den gelieferten Wert
// zu mocken oder zu überschreiben
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    // Damit Widgets providers lesen können, müssen wir die komplette App in einen
    // "ProviderScope" Widget einpacken.
    // Hier wird der Zustand unserer Provider gespeichert.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Erweitern Sie ConsumerWidget anstelle von StatelessWidget, das von Riverpod bereitgestellt wird.
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
