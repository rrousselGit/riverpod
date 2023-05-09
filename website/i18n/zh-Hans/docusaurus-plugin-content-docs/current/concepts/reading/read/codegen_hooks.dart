// ignore_for_file: omit_local_variable_types, avoid_types_on_closure_parameters, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen_hooks.g.dart';

/* SNIPPET START */

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state = state + 1;
}

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
