import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/riverpod.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(1);

  static final counterStaticProvider =
      StateNotifierProvider<Counter>((ref) => Counter());
  static final familyStaticProvider =
      StateNotifierProvider.family<Counter, String>((ref, _) => Counter());

  void increment() => state++;
  void decrement() => state--;
}

class CounterNullable extends StateNotifier<int?> {
  CounterNullable(int? init) : super(init);

  void increment() => state = state! + 1;
  void decrement() => state = state! - 1;
}

final counterProvider = StateNotifierProvider((ref) => Counter());
final counterProvider2 = StateNotifierProvider<Counter>((ref) => Counter());
final counterNullableProvider =
    StateNotifierProvider<CounterNullable>((ref) => CounterNullable(null));
final counterNullableProviderFamily =
    StateNotifierProvider.family<CounterNullable, int?>(
        (ref, init) => CounterNullable(init));

final counterFamilyProvider =
    StateNotifierProvider.family<Counter, String>((ref, _) => Counter());

final counterDisposeProvider =
    StateNotifierProvider.autoDispose((ref) => Counter());
final counterDisposeProvider2 =
    StateNotifierProvider.autoDispose<Counter>((ref) => Counter());

final otherProvider = Provider<int>((ref) {
  ref.read(counterProvider);
  ref.read(counterProvider.state);
  ref.watch(counterProvider);
  return ref.watch(counterProvider.state);
});

class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // ignore: unused_local_variable
    final countNotifier = watch(counterProvider);
    final count = watch(counterProvider.state);
    return Center(
      child: Text('$count'),
    );
  }
}

class HooksWatch extends HookWidget {
  const HooksWatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final countNotifier = useProvider(counterProvider);
    // ignore: unused_local_variable
    final count = useProvider(counterProvider.state);
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.read(counterProvider);
          context.read(counterProvider.state);
          context.read(Counter.counterStaticProvider.state);
          context.read(Counter.counterStaticProvider);
          context.read(Counter.familyStaticProvider('').state);
          context.read(Counter.familyStaticProvider(''));
        },
        child: const Text('Press Me'),
      ),
    );
  }
}
