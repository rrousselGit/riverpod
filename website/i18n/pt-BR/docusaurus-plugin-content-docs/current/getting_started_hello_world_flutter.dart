// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Criamos um "provider", que armazenará um valor (aqui "Olá, mundo").
// Ao usar um provider, isso nos permite simular/substituir o valor exposto.
final olaMundoProvider = Provider((_) => 'Olá mundo');

void main() {
  runApp(
    // Para que os widgets possam ler os provides, precisamos envolver o
    // aplicativo inteiro em um widget "ProviderScope".
    // É aqui que o estado dos nossos providers será armazenado.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Estenda com ConsumerWidget em vez de StatelessWidget,
// que é fornecido pelo Riverpod
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(olaMundoProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Riverpod BR')),
        body: Center(
          child: Text(value),
        ),
      ),
    );
  }
}
