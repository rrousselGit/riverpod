import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// A Counter example implemented with riverpod

void main() {
  runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

final fam = Provider.family<int, int>((ref, id) => id);

/// Annotating a class by `@riverpod` defines a new shared state for your application,
/// accessible using the generated [counterProvider].
/// This class is both responsible for initializing the state (through the [build] method)
/// and exposing ways to modify it (cf [increment]).
@riverpod
class Counter extends _$Counter {
  /// Classes annotated by `@riverpod` **must** define a [build] function.
  /// This function is expected to return the initial state of your shared state.
  /// It is totally acceptable for this function to return a [Future] or [Stream] if you need to.
  /// You can also freely define parameters on this method.
  @override
  int build() => 0;

  void increment() => state++;
}

class Home extends ConsumerStatefulWidget {
  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Counter example with lots of hidden weird providers',
        ),
      ),
      body: Column(
        children: [
          Text('${ref.watch(counterProvider)}'),
          Opacity(
            opacity: 0.01,
            child: Column(
              children: [
                if (show) ProviderScope(child: Container(color: Colors.red)),
                ElevatedButton(
                  onPressed: () {
                    setState(() => show = !show);
                  },
                  child: Text(show ? 'Hide' : 'Show'),
                ),
                Text(ref.watch(complexProvider).nbr.toString()),
                Text(ref.watch(fam(42)).toString()),
                Text(ref.watch(fam(21)).toString()),
                Text(ref.watch(booleanProvider).toString()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // The read method is a utility to read a provider without listening to it
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

final complexProvider = Provider<Complex>((ref) {
  return Complex(ref.watch(counterProvider) * 2);
});

final booleanProvider = Provider<bool>((ref) {
  return true;
});

class Complex {
  Complex(this.nbr);
  final int nbr;
  final String str = 'Hello "John" and Mary\'s friend';
  final bool boolean = true;
  final double decimal = 3.14;

  Complex get recursion => this;

  late final int lateValue;
  late final int anotherLateValue = 42;
  final list = [1, 2, 3];
  final complexList = [
    [1, 2],
    [3, 4],
  ];
  final map = {'a': 1, 'b': 2};
  final complexMap = {
    [1]: [1],
    [2]: [2],
  };
  final hashSet = <int>{1, 2, 3};
  final complexHashSet = <List<int>>{
    [1, 2],
    [3, 4],
  };
  final record = (1, 'a', named: true);
}
