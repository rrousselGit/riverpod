import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state++;
}

final counterNotifierProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

/* SNIPPET START */
class SomeConsumer extends ConsumerWidget {
  const SomeConsumer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterNotifierProvider); // !
    return Column(
      children: [
        Text("You've counted up until $counter, good job!"),
        TextButton(
          onPressed: ref.read(counterNotifierProvider.notifier).increment, // !
          child: const Text('Count even more!'),
        )
      ],
    );
  }
}
