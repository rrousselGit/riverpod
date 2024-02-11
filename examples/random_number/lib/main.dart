import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: RandomNumberApp()));
}

// State notifier for generating a random number exposed by a state notifier
// provider
class RandomNumberGenerator extends StateNotifier<int> {
  RandomNumberGenerator() : super(Random().nextInt(9999));

  void generate() {
    state = Random().nextInt(9999);
  }
}

// State notifier provider holding the state
final randomNumberProvider = StateNotifierProvider(
  (ref) => RandomNumberGenerator(),
);

class RandomNumberApp extends StatelessWidget {
  const RandomNumberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Random number'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const RandomConsumer(),
              // Consumer to call a method inside StateNotifier just to change
              // the state
              Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    child: const Text('Generate'),
                    onPressed: () =>
                        ref.read(randomNumberProvider.notifier).generate(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom consumer using the provider
class RandomConsumer extends ConsumerWidget {
  const RandomConsumer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(ref.watch(randomNumberProvider).toString());
  }
}
