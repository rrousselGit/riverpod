import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

// A Counter example implemented with riverpod

void main() {
  runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

/// Providers are declared globally and specifies how to create a state
final counterProvider = StateNotifierProvider((_) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

class Home extends HookWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// We read the provider previously declared.
    /// The widget will rebuild automatically when the value updates.
    final count = useProvider(counterProvider.state);

    return Scaffold(
      appBar: AppBar(title: const Text('Counter example')),
      body: Center(child: Text('$count')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counterProvider.read(context).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
