import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/riverpod.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(1);

  static final counterStaticProvider =
      StateNotifierProvider<Counter, int>((ref) => Counter());
  static final familyStaticProvider =
      StateNotifierProvider.family<Counter, int, String>((ref, _) => Counter());

  void increment() => state++;
  void decrement() => state--;
}

class CounterNullable extends StateNotifier<int?> {
  CounterNullable(int? init) : super(init);

  void increment() => state = state! + 1;
  void decrement() => state = state! - 1;
}

final counterProvider = StateNotifierProvider<Counter, int>((ref) => Counter());
final counterProvider2 =
    StateNotifierProvider<Counter, int>((ref) => Counter());
final counterNullableProvider = StateNotifierProvider<CounterNullable, int?>(
    (ref) => CounterNullable(null));
final counterNullableProviderFamily =
    StateNotifierProvider.family<CounterNullable, int?, int?>(
        (ref, init) => CounterNullable(init));

final counterFamilyProvider =
    StateNotifierProvider.family<Counter, int, String>((ref, _) => Counter());

final counterDisposeProvider =
    StateNotifierProvider.autoDispose<Counter, int>((ref) => Counter());
final counterDisposeProvider2 =
    StateNotifierProvider.autoDispose<Counter, int>((ref) => Counter());

final otherProvider = Provider<int>((ref) {
  ref.read(counterProvider.notifier);
  ref.read(counterProvider);
  ref.watch(counterProvider.notifier);
  return ref.watch(counterProvider);
});

class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // ignore: unused_local_variable
    final countNotifier = watch(counterProvider.notifier);
    final count = watch(counterProvider);
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
    final countNotifier = useProvider(counterProvider.notifier);
    // ignore: unused_local_variable
    final count = useProvider(counterProvider);
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.read(counterProvider.notifier);
          context.read(counterProvider);
          context.read(Counter.counterStaticProvider);
          context.read(Counter.counterStaticProvider.notifier);
          context.read(Counter.familyStaticProvider(''));
          context.read(Counter.familyStaticProvider('').notifier);
        },
        child: const Text('Press Me'),
      ),
    );
  }
}
