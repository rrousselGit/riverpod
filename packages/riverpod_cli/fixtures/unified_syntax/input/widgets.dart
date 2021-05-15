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
  Widget build(BuildContext context, ScopedReader watch) {
    // ignore: unused_local_variable
    final countNotifier = watch(counterProvider.notifier);
    final count = watch(counterProvider);
    return Center(
      child: Text('$count'),
    );
  }
}

class StatelessRead extends StatelessWidget {
  const StatelessRead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.read(counterProvider);
          context.refresh(counterProvider);
        },
        child: const Text('Counter'),
      ),
    );
  }
}

class StatelessListen extends StatelessWidget {
  const StatelessListen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: counterProvider,
      onChange: (context, i) {
        // ignore: avoid_print
        print(i);
      },
      child: const Text('Counter'),
    );
  }
}

class StatelessExpressionListen extends StatelessWidget {
  const StatelessExpressionListen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ProviderListener(
        provider: counterProvider,
        onChange: (context, i) {
          // ignore: avoid_print
          print(i);
        },
        child: const Text('Counter'),
      );
}

class StatefulConsumer extends StatefulWidget {
  const StatefulConsumer({Key? key}) : super(key: key);

  @override
  _StatefulConsumerState createState() => _StatefulConsumerState();
}

class _StatefulConsumerState extends State<StatefulConsumer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          context.refresh(counterProvider);
        },
        child: Consumer(
          builder: (context, watch, child) {
            return Text('${watch(counterProvider)}');
          },
        ),
      ),
    );
  }
}

class _StatefulConsumerState2 extends State<StatefulConsumer2> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          context.refresh(counterProvider);
        },
        child: const Text('Hi'),
      ),
    );
  }
}

class StatefulConsumer2 extends StatefulWidget {
  const StatefulConsumer2({Key? key}) : super(key: key);

  @override
  _StatefulConsumerState2 createState() => _StatefulConsumerState2();
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
      child: HookBuilder(
        builder: (context) {
          useProvider(counterProvider);
          return ElevatedButton(
            onPressed: () {
              context.read(counterProvider.notifier);
              context.read(counterProvider);
            },
            child: const Text('Press Me'),
          );
        },
      ),
    );
  }
}

class BasicUseOfCustomHook extends HookWidget {
  const BasicUseOfCustomHook({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    useAnotherHook();
    return Container();
  }
}

Object useMyHook() {
  return useProvider(counterProvider);
}

void useAnotherHook() {
  useMyHook();
}
