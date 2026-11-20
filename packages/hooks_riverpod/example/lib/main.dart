import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(
    /// [MyApp] is wrapped in a [ProviderScope].
    /// This widget is where the state of most of our providers will be stored.
    /// This replaces `MultiProvider` if you've used `provider` before.
    const ProviderScope(child: MyApp()),
  );
}

/// A provider that creates and listen to a [Notifier].
///
/// Providers are declared as global variables.
/// This does not hinder testability, as the state of a provider is instead
/// stored inside a [ProviderScope].
final counterProvider = NotifierProvider<Counter, int>(Counter.new);

/// A simple [Notifier] that implements a counter.
///
/// It doesn't have to be a [Notifier], and could be anything else such as:
/// - [AsyncNotifier], with [AsyncNotifierProvider]
/// - [Stream], with [StreamProvider]
/// ...
class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod counter example')),
      body: Center(
        // HookConsumer is a builder widget that allows you to read providers and utilize hooks.
        child: HookConsumer(
          builder: (context, ref, _) {
            final count = ref.watch(counterProvider);

            return Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
