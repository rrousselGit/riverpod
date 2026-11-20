// An application with a value that takes a while to read.
import 'dart:async';

import 'package:riverpod/riverpod.dart';

class Slow {
  int get value {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsedMilliseconds < 500) {}
    return 42;
  }
}

final slowProvider = Provider<Slow>(name: 'slowProvider', (ref) => Slow());

void main() {
  final container = ProviderContainer();
  container.listen(slowProvider, (_, _) {});

  print('ready');

  Timer.periodic(const Duration(hours: 1), (_) {});
}
