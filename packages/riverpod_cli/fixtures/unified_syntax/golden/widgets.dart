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

final counterProvider = StateNotifierProvider<Counter, int>((ref) => Counter());

class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetReference ref) {
    // ignore: unused_local_variable
    final countNotifier = ref.watch(counterProvider.notifier);
    final count = ref.watch(counterProvider);
    return Center(
      child: Text('$count'),
    );
  }
}

class StatelessRead extends ConsumerWidget {
  const StatelessRead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetReference ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          ref.read(counterProvider);
          ref.refresh(counterProvider);
        },
        child: const Text('Counter'),
      ),
    );
  }
}

class StatelessListen extends ConsumerWidget {
  const StatelessListen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetReference ref) {
    ref.listen(counterProvider, (context, i) {
      // ignore: avoid_print
      print(i);
    });
    return const Text('Counter');
  }
}

class StatelessExpressionListen extends ConsumerWidget {
  const StatelessExpressionListen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetReference ref) {
    ref.listen(counterProvider, (context, i) {
      // ignore: avoid_print
      print(i);
    });
    return const Text('Counter');
  }
}

class StatefulConsumer extends ConsumerStatefulWidget {
  const StatefulConsumer({Key? key}) : super(key: key);

  @override
  _StatefulConsumerState createState() => _StatefulConsumerState();
}

class _StatefulConsumerState extends State<StatefulConsumer>
    with ConsumerStateMixin {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          ref.refresh(counterProvider);
        },
        child: Consumer(
          builder: (context, ref, child) {
            return Text('${ref.watch(counterProvider)}');
          },
        ),
      ),
    );
  }
}

class _StatefulConsumerState2 extends State<StatefulConsumer2>
    with ConsumerStateMixin {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          ref.refresh(counterProvider);
        },
        child: const Text('Hi'),
      ),
    );
  }
}

class StatefulConsumer2 extends ConsumerStatefulWidget {
  const StatefulConsumer2({Key? key}) : super(key: key);

  @override
  _StatefulConsumerState2 createState() => _StatefulConsumerState2();
}

class HooksWatch extends HookConsumerWidget {
  const HooksWatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetReference ref) {
    // ignore: unused_local_variable
    final countNotifier = ref.watch(counterProvider.notifier);
    // ignore: unused_local_variable
    final count = ref.watch(counterProvider);
    return Center(
      child: ElevatedButton(
        onPressed: () {
          ref.read(counterProvider.notifier);
          ref.read(counterProvider);
        },
        child: const Text('Press Me'),
      ),
    );
  }
}

class HooksConsumerWatch extends StatelessWidget {
  const HooksConsumerWatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: HookConsumer(
        builder: (context, ref, child) {
          ref.watch(counterProvider);
          return ElevatedButton(
            onPressed: () {
              ref.read(counterProvider.notifier);
              ref.read(counterProvider);
            },
            child: const Text('Press Me'),
          );
        },
      ),
    );
  }
}

class BasicUseOfCustomHook extends HookConsumerWidget {
  const BasicUseOfCustomHook({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetReference ref) {
    useAnotherHook(ref);
    return Container();
  }
}

Object useMyHook(WidgetReference ref) {
  return ref.watch(counterProvider);
}

void useAnotherHook(WidgetReference ref) {
  useMyHook(ref);
}
