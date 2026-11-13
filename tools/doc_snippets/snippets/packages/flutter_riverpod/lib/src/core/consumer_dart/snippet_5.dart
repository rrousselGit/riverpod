// GENERATED from packages/flutter_riverpod/lib/src/core/consumer.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show riverpod;

class User {
  String get name => 'John';
}

final userProvider = FutureProvider<User>((ref) async => User());
final someProvider = Provider((ref) => 'Hello world');
final anotherProvider = Provider((ref) => 42);

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                // This builder will only get called when the counterProvider
                // is updated.
                final count = ref.watch(counterProvider);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[Text('$count'), child!],
                );
              },
              // The child parameter is most helpful if the child is
              // expensive to build and does not depend on the value from
              // the notifier.
              child: Text('Good job!'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one),
        onPressed: () => ref.read(counterProvider.notifier).increment(),
      ),
    );
  }
}
