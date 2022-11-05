// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Мы создаем "provider", который будет хранить значение (т.е. "Hello world").
// Использование provider позволяет нам имитировать/переопределять хранимое значение.
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    // Нам необходимо обернуть все приложение в "ProviderScope", чтобы иметь
    // возможность читать провайдеры.
    // Здесь будут хранится состояния наших провайдеров.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Наследуйтесь от ConsumerWidget из Riverpod вместо StatelessWidget.
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
