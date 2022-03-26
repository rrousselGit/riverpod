import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// A Counter example implemented with riverpod

void main() {
  runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    RootRestorationScope(
      restorationId: 'root',
      child: ProviderScope(
        restorationId: 'root_scope',
        restorables: [
          counterProvider.withRestorationId('counterProvider'),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      home: Home(),
    );
  }
}

/// Providers are declared globally and specify how to create a state
final counterProvider = RestorableProvider((ref) => RestorableInt(0));

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter example')),
      body: Center(
        // Consumer is a widget that allows you reading providers.
        child: Consumer(builder: (context, ref, _) {
          final count = ref.watch(counterProvider).value;
          return Text('$count');
        }),
      ),
      floatingActionButton: FloatingActionButton(
        // The read method is a utility to read a provider without listening to it
        onPressed: () => ref.read(counterProvider).value++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
