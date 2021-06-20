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

final counterProvider = StateNotifierProvider<Counter, int>((ref) => Counter());
final counterProvider2 =
    StateNotifierProvider<Counter, int>((ref) => Counter());

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
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final countNotifier = ref.watch(counterProvider.notifier);
    final count = ref.watch(counterProvider);
    return Center(
      child: Text('$count'),
    );
  }
}

class HooksWatch extends HookConsumerWidget {
  const HooksWatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final countNotifier = ref.watch(counterProvider.notifier);
    // ignore: unused_local_variable
    final count = ref.watch(counterProvider);
    return Center(
      child: ElevatedButton(
        onPressed: () {
          ref.read(counterProvider.notifier);
          ref.read(counterProvider);
          ref.read(Counter.counterStaticProvider);
          ref.read(Counter.counterStaticProvider.notifier);
          ref.read(Counter.familyStaticProvider(''));
          ref.read(Counter.familyStaticProvider('').notifier);
        },
        child: const Text('Press Me'),
      ),
    );
  }
}
