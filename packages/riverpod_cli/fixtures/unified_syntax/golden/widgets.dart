// ignore_for_file: avoid_types_on_closure_parameters, type_init_formals, unused_local_variable, avoid_print, unnecessary_lambdas, unused_import
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: unnecessary_import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: unnecessary_import
import 'package:riverpod/riverpod.dart';

extension on ProviderBase<Object?> {
  // ignore: unused_element
  Override overrideWithValue(Object? value) => throw UnimplementedError();
}

class Counter extends StateNotifier<int> {
  Counter(Ref this.ref) : super(1);
  final Ref ref;
  void increment() => state++;
  void decrement() => state--;
}

class CounterTest extends StateNotifier<int> implements Counter {
  CounterTest() : super(1);

  @override
  void increment() => state++;
  @override
  void decrement() => state--;

  @override
  Ref get ref => throw UnimplementedError();
}

final testProvider = Provider<int>((ref) => 0);
final counterProvider =
    StateNotifierProvider<Counter, int>((ref) => Counter(ref));
final futureProvider = FutureProvider<int>((FutureProviderRef<int> ref) async {
  await Future<void>.delayed(const Duration(seconds: 1));
  return Future.value(0);
});
final streamProvider = StreamProvider<int>((StreamProviderRef<int> ref) async* {
  yield 0;
  await Future<void>.delayed(const Duration(seconds: 1));
  final state = ref.watch(stateProvider.state).state;
  yield 1;
});
final plainProvider = Provider<String>((ProviderRef<String> ref) => '');
final plainNullProvider = Provider<String?>((ProviderRef<String?> ref) => null);
final plainProviderAD =
    Provider.autoDispose<String>((AutoDisposeProviderRef<String> ref) => '');
final stateProvider =
    StateProvider<String>((StateProviderRef<String> ref) => '');
final changeNotifier = ChangeNotifierProvider<ChangeNotifier>(
  (ChangeNotifierProviderRef<ChangeNotifier> ref) => ChangeNotifier(),
);
final plainProviderFamilyAD = Provider.family
    .autoDispose<String, String>((AutoDisposeProviderRef<String> ref, _) => '');
final futureProviderAD = FutureProvider.autoDispose<String>(
  (AutoDisposeFutureProviderRef<String> ref) async => '',
);
final streamProviderAD = StreamProvider.autoDispose<String>(
  (AutoDisposeStreamProviderRef<String> ref) =>
      Stream.fromIterable(['1', '2', '3']),
);
final stateNotifierProvider = StateNotifierProvider<Counter, int>(
  (StateNotifierProviderRef<Counter, int> ref) => Counter(ref),
);
final scopedProvider = Provider<int>((ref) => 0);
final otherScopedProvider = Provider<int>((ref) => ref.watch(scopedProvider));

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? oldValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('$provider $newValue');
  }
}

class ImageProvider extends StatelessWidget {
  const ImageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.plus_one);
  }
}

class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countNotifier = ref.watch(counterProvider.notifier);
    final count = ref.watch(counterProvider);
    final fam = ref.watch(plainProviderFamilyAD(''));
    final state = ref.watch(stateProvider.state).state;
    return Column(
      children: [
        const ImageProvider(),
        Text('$count'),
      ],
    );
  }
}

class StatelessRead extends ConsumerWidget {
  const StatelessRead({super.key});

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

class StatelessConsumerRead extends ConsumerWidget {
  const StatelessConsumerRead({super.key});

  void onPressed(WidgetRef ref, BuildContext context) {
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          onPressed(ref, context);
          onPressed2(ref, context);
        },
        child: Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(counterProvider);

            return Text('Counter $count');
          },
        ),
      ),
    );
  }

  void onPressed2(WidgetRef ref, BuildContext context) {
    ref.refresh(counterProvider.notifier);
  }
}

class StatelessListen extends ConsumerWidget {
  const StatelessListen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<int>(counterProvider, (previous, i) {
      print(i);
    });
    return const Text('Counter');
  }
}

class StatelessListen2 extends ConsumerWidget {
  const StatelessListen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<int>(counterProvider, _onChange);
    return const Text('Counter');
  }
}

class StatelessListen3 extends ConsumerWidget {
  const StatelessListen3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<int>>(futureProvider, (previous, i) {
      print(i);
    });
    return const Text('Counter');
  }
}

void _onChange(int? previous, int i) {
  print(i);
}

class StatelessExpressionListen extends ConsumerWidget {
  const StatelessExpressionListen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<int>(counterProvider, onChange);
    return const Text('Counter');
  }

  void onChange(int? previous, int i) {
    print(i);
  }
}

class StatefulConsumerBasic extends ConsumerStatefulWidget {
  const StatefulConsumerBasic({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StatefulConsumerBasicState();
}

class _StatefulConsumerBasicState extends ConsumerState<StatefulConsumerBasic> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          ref.read(counterProvider);
        },
      ),
    );
  }
}

class StatefulConsumer extends ConsumerStatefulWidget {
  const StatefulConsumer({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
  const StatefulConsumer2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StatefulConsumerState2 createState() => _StatefulConsumerState2();
}

class HooksWatch extends HookConsumerWidget {
  const HooksWatch({super.key});

  void empty() {}
  void error(Object err, StackTrace? st) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countNotifier = ref.watch(counterProvider.notifier);
    final count = ref.watch(counterProvider);
    final asyncValue = ref.watch(futureProvider);
    asyncValue.when(loading: () {}, data: (_) {}, error: (_, __) {});
    asyncValue.maybeWhen(
      loading: () {},
      data: (_) {},
      error: (_, __) {},
      orElse: () {},
    );
    asyncValue.when(loading: empty, data: (_) {}, error: error);
    asyncValue.maybeWhen(
      loading: empty,
      data: (_) {},
      error: error,
      orElse: () {},
    );
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
  const HooksConsumerWatch({super.key});

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

class HooksConsumerSimple extends ConsumerWidget {
  const HooksConsumerSimple({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => _build(ref);
  Widget _build(WidgetRef ref) => HookConsumer(
        builder: (context, ref, child) {
          ref.watch(counterProvider);
          final value = useAHook(ref, '');
          return const Text('Press Me');
        },
      );
}

class BasicUseOfCustomHook extends HookConsumerWidget {
  const BasicUseOfCustomHook({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAnotherHook(ref);
    return Container();
  }
}

Object useAHook(WidgetRef ref, String value) {
  return ref.watch(plainProviderFamilyAD(value));
}

Object useMyHook(WidgetRef ref) {
  return ref.watch(counterProvider);
}

void useAnotherHook(WidgetRef ref) {
  useMyHook(ref);
}

class NoMigrateHook extends HookWidget {
  const NoMigrateHook({super.key});
  @override
  Widget build(BuildContext context) {
    final state = useState('');
    return Container();
  }
}

void main() {
  final container = ProviderContainer();
  final count = container.read(testProvider);
  ProviderContainer(
    overrides: [
      stateNotifierProvider.overrideWithValue(CounterTest()),
    ],
  )
      .listen<Counter>(stateNotifierProvider.notifier, (previous, value) {})
      .read();
  ProviderContainer().read(testProvider);
  final _ = ProviderContainer(
    overrides: [
      testProvider.overrideWithValue(100),
    ],
  );
  final fut = container.refresh(futureProvider.future);
  final val = container.refresh(stateNotifierProvider.notifier);
  runApp(const ProviderScope(child: MaterialApp()));
}
