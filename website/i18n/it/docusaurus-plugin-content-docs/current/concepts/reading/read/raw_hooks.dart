// ignore_for_file: omit_local_variable_types

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../counter/raw.dart';

/* SNIPPET START */

final counterProvider =
    StateNotifierProvider<Counter, int>(Counter.new);

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = useState('Hello');
    
    return Scaffold(
      body: Center(child: Text(greeting.value)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call `increment()` on the `Counter` class
          ref.read(counterProvider.notifier).increment();
        },
      ),
    );
  }
}
