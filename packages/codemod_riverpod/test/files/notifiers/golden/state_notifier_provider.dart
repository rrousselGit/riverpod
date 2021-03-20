import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(1);
  void increment() => state++;
  void decrement() => state--;
}

final counterProvider = StateNotifierProvider((ref) => Counter());

final otherProvider = Provider((ref) {
  ref.read(counterProvider.notifier);
  ref.read(counterProvider);
  ref.watch(counterProvider.notifier);
  return ref.watch(counterProvider);
});

class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final countNotifier = watch(counterProvider.notifier);
    final count = watch(counterProvider);
    return Center(
      child: Text('$count'),
    );
  }
}

class HooksWatch extends HookWidget {
  const HooksWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countNotifier = useProvider(counterProvider.notifier);
    final count = useProvider(counterProvider);
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.read(counterProvider.notifier);
          context.read(counterProvider);
        },
        child: const Text('Press Me'),
      ),
    );
  }
}
