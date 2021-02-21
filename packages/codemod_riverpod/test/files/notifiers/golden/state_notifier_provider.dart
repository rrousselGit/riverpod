import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(1);
  void increment() => state++;
  void decrement() => state--;
}

final counterProvider = StateNotifierProvider((ref) => Counter());

class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final count = watch(counterProvider);
    return Center(
      child: Text('$count'),
    );
  }
}
