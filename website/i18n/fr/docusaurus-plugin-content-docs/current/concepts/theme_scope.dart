// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.blue),
        home: const Home(),
      ),
    ),
  );
}

// Avoir un compteur qui est incrémenté
final counterProvider = StateProvider(
  (ref) => 0,
);

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Column(
      children: [
        // Ce compteur aura une couleur primaire verte
        Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.green),
          child: const CounterDisplay(),
        ),
        // Ce compteur aura une couleur primaire bleu
        const CounterDisplay(),
        ElevatedButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state++;
          },
          child: const Text('Incrémenter le compteur'),
        ),
      ],
    ));
  }
}

class CounterDisplay extends ConsumerWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: theme.textTheme.displayMedium
              ?.copyWith(color: theme.primaryColor),
        ),
      ],
    );
  }
}
