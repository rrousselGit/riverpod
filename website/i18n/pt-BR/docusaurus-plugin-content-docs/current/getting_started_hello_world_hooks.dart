// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Criamos um "provider", que armazenará um valor (aqui "Olá, mundo").
// Ao usar um provider, isso nos permite simular/substituir o valor exposto.
final helloWorldProvider = Provider((_) => 'Hello world');

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

// Nota: MyApp é um HookConsumerWidget, pacote `hooks_riverpod`.
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
