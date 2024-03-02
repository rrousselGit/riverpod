// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */ import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// Creiamo un "provider", che conterrà un valore (qui "Hello, world").
// Utilizzando un provider, ciò ci consente di simulare/sostituire il valore esposto.
@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

void main() {
  runApp(
    // Per consentire ai widget di leggere i provider, è necessario incapsulare l'intera
    // applicazione in un widget "ProviderScope".
    // Questo è il luogo in cui verrà memorizzato lo stato dei nostri provider.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Estendiamo ConsumerWidget invece di StatelessWidget, il quale è esposto da Riverpod
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
