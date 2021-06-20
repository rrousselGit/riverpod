import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final counterProvider = StateProvider((ref) => 1);
final counterFamilyProvider = StateProvider.family<int, String>((ref, _) => 1);

final otherProvider = Provider<int>((ref) {
  ref.read(counterProvider);
  ref.read(counterProvider).state;
  return ref.watch(counterProvider).state;
});

class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final countNotifier = ref.watch(counterProvider);
    final count = ref.watch(counterProvider).state;
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
    final countNotifier = ref.watch(counterProvider);
    // ignore: unused_local_variable
    final count = ref.watch(counterProvider).state;
    return Center(
      child: ElevatedButton(
        onPressed: () {
          ref.read(counterProvider);
          ref.read(counterProvider).state;
        },
        child: const Text('Press Me'),
      ),
    );
  }
}
