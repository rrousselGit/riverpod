// ignore_for_file: avoid_types_on_closure_parameters, type_init_formals, unused_local_variable, avoid_print, unnecessary_lambdas, unused_import
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/riverpod.dart';

class Counter extends StateNotifier<int> {
  Counter(ProviderReference this.ref) : super(1);
  final ProviderReference ref;
  void increment() => state++;
  void decrement() => state--;
}

final counterProvider =
    StateNotifierProvider<Counter, int>((ref) => Counter(ref));
final futureProvider = FutureProvider((ProviderReference ref) async {
  await Future<void>.delayed(const Duration(seconds: 1));
  return Future.value(0);
});
final streamProvider = StreamProvider((ProviderReference ref) async* {
  yield 0;
  await Future<void>.delayed(const Duration(seconds: 1));
  yield 1;
});
final plainProvider = Provider((ProviderReference ref) => '');
final plainNullProvider = Provider<String?>((ProviderReference ref) => null);
final plainProviderAD = Provider.autoDispose((ProviderReference ref) => '');
final plainProviderFamilyAD = Provider.family
    .autoDispose<String, String>((ProviderReference ref, _) => '');
final futureProviderAD =
    FutureProvider.autoDispose((ProviderReference ref) async => '');
final streamProviderAD = StreamProvider.autoDispose(
    (ProviderReference ref) => Stream.fromIterable(['1', '2', '3']));
final stateNotifierProvider = StateNotifierProvider<Counter, int>(
    (ProviderReference ref) => Counter(ref));
final scopedProvider = ScopedProvider<int>((ref) => 0);

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider, Object? newValue) {
    print('$provider $newValue');
  }
}

class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
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
        onChange: onChange,
        child: const Text('Counter'),
      );

  void onChange(BuildContext context, int i) {
    print(i);
  }
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
          context.refresh(futureProvider);
          context.refresh(streamProvider);
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

class NoMigrateHook extends HookWidget {
  const NoMigrateHook({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = useState('');
    return Container();
  }
}
