// The application that the tests inspect through its VM service.
import 'dart:async';

import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

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
  final _secret = 42;

  String get greeting => 'Hello $name ($_secret)';
}

final userProvider = FutureProvider.family<User, String>(
  name: 'userProvider',
  (ref, name) async => User(name, tags: ['a', 'b']),
);

final valuesProvider = Provider<Map<String, Object?>>(
  name: 'valuesProvider',
  (ref) => {
    'record': (1, name: 'named'),
    'set': {1.5},
    'type': int,
    'null': null,
    'bool': true,
    'closure': () {},
    'user': User('jane', tags: []),
    'loading': const AsyncLoading<int>(progress: .5),
    'error': AsyncError<int>('oops', StackTrace.empty),
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
