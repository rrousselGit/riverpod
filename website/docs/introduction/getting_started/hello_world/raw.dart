// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// {@template helloWorld}
// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.
// {@endtemplate}
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    // {@template ProviderScope}
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    // {@endtemplate}
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// {@template ConsumerWidget}
// Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
// {@endtemplate}
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
