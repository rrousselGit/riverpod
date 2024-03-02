// ignore_for_file: omit_local_variable_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reading_counter.dart';

/* SNIPPET START */

final counterProvider =
    StateNotifierProvider<Counter, int>(Counter.new);

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aufruf von `increment()` der `Counter` Klasse
          ref.read(counterProvider.notifier).increment();
        },
      ),
    );
  }
}
