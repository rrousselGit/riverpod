// The application that the tests inspect through the MCP server.
import 'dart:async';

import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;

  /// Creates a provider and changes it right away, within the same frame.
  void addAndUpdate() {
    ref.container.listen(extraProvider, (_, _) {});
    ref.read(extraProvider.notifier).increment();
    // Frames are published from a microtask, and evaluations alone do not
    // run those.
    Timer.run(() {});
  }
}

final extraProvider = NotifierProvider<Counter, int>(
  Counter.new,
  name: 'extraProvider',
);

final counterProvider = NotifierProvider<Counter, int>(
  Counter.new,
  name: 'counterProvider',
);

final doubleProvider = Provider<int>(
  name: 'doubleProvider',
  (ref) => ref.watch(counterProvider) * 2,
);

class User {
  User(this.name, {required this.tags});

  final String name;
  final List<String> tags;
}

final userProvider = FutureProvider.family<User, String>(
  name: 'userProvider',
  (ref, name) async => User(name, tags: ['a', 'b']),
);

final valuesProvider = Provider<Map<String, Object?>>(
  name: 'valuesProvider',
  (ref) => {
    'nan': double.nan,
    'big': List.generate(150, (index) => index),
    'record': (1.5, name: 'named'),
    'set': {true},
    'type': int,
    'nothing': null,
    'empty': <int>[],
  },
);

void main() {
  debugTrackProviderCreation = true;
  final container = ProviderContainer();
  container.listen(doubleProvider, (_, _) {});
  container.listen(userProvider('john'), (_, _) {});
  container.listen(valuesProvider, (_, _) {});

  // Tells the test that providers can be inspected.
  print('ready');

  // Keep the application running until the test kills it.
  Timer.periodic(const Duration(hours: 1), (_) {});
}
