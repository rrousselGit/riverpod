import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(1);
  void increment() => state++;
  void decrement() => state--;
}

final counterProvider = StateNotifierProvider((ref) => Counter());

final otherProvider = Provider((ref) {
  ref.read(counterProvider);
  ref.read(counterProvider.state);
  ref.watch(counterProvider);
  return ref.watch(counterProvider.state);
});

class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final countNotifier = watch(counterProvider);
    final count = watch(counterProvider.state);
    return Center(
      child: Text('$count'),
    );
  }
}
