// ignore_for_file: avoid_types_on_closure_parameters, type_init_formals, unused_local_variable, avoid_print, unnecessary_lambdas, unused_import
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/riverpod.dart';

class Counter extends StateNotifier<int> {
  Counter(ProviderRefBase this.ref) : super(1);
  final ProviderRefBase ref;
  void increment() => state++;
  void decrement() => state--;
}

final counterProvider =
    StateNotifierProvider<Counter, int>((ref) => Counter(ref));
final futureProvider = FutureProvider<int>((FutureProviderRef<int> ref) async {
  await Future<void>.delayed(const Duration(seconds: 1));
  return Future.value(0);
});
final streamProvider = StreamProvider<int>((StreamProviderRef<int> ref) async* {
  yield 0;
  await Future<void>.delayed(const Duration(seconds: 1));
  yield 1;
});
final plainProvider = Provider<String>((ProviderRef<String> ref) => '');
final plainNullProvider = Provider<String?>((ProviderRef<String?> ref) => null);
final plainProviderAD =
    Provider.autoDispose<String>((AutoDisposeProviderRef<String> ref) => '');
final plainProviderFamilyAD = Provider.family
    .autoDispose<String, String>((AutoDisposeProviderRef<String> ref, _) => '');
final futureProviderAD = FutureProvider.autoDispose<String>(
    (AutoDisposeFutureProviderRef<String> ref) async => '');
final streamProviderAD = StreamProvider.autoDispose<String>(
    (AutoDisposeStreamProviderRef<String> ref) =>
        Stream.fromIterable(['1', '2', '3']));
final stateNotifierProvider = StateNotifierProvider<Counter, int>(
    (StateNotifierProviderRef<Counter, int> ref) => Counter(ref));
final scopedProvider = Provider<int>((ref) => 0);

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider, Object? oldValue,
      Object? newValue, ProviderContainer container) {
    print('$provider $newValue');
  }
}

class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          ref.read(counterProvider);
          ref.refresh(counterProvider.notifier);
        },
        child: const Text('Counter'),
      ),
    );
  }
}

class StatelessListen extends ConsumerWidget {
  const StatelessListen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(counterProvider, (i) {
      print(i);
    });
    return const Text('Counter');
  }
}

class StatelessExpressionListen extends ConsumerWidget {
  const StatelessExpressionListen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(counterProvider, onChange);
    return const Text('Counter');
  }

  void onChange(int i) {
    print(i);
  }
}

class StatefulConsumer extends ConsumerStatefulWidget {
  const StatefulConsumer({Key? key}) : super(key: key);

  @override
  _StatefulConsumerState createState() => _StatefulConsumerState();
}

class _StatefulConsumerState extends ConsumerState<StatefulConsumer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          ref.refresh(counterProvider.notifier);
          ref.refresh(futureProvider.future);
          ref.refresh(streamProvider);
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

class _StatefulConsumerState2 extends ConsumerState<StatefulConsumer2> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          ref.refresh(counterProvider.notifier);
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
  Widget build(BuildContext context, WidgetRef ref) {
    final countNotifier = ref.watch(counterProvider.notifier);
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
  Widget build(BuildContext context, WidgetRef ref) {
    useAnotherHook(ref);
    return Container();
  }
}

Object useMyHook(WidgetRef ref) {
  return ref.watch(counterProvider);
}

void useAnotherHook(WidgetRef ref) {
  useMyHook(ref);
}

class NoMigrateHook extends HookWidget {
  const NoMigrateHook({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = useState('');
    return Container();
  }
}
