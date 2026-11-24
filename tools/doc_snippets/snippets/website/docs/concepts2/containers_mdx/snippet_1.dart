// GENERATED from website/docs/concepts2/containers.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:riverpod/riverpod.dart';

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
}

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

void main() {
  final container = ProviderContainer();

  try {
    final sub = container.listen(counterProvider, (previous, next) {
      print('Counter changed from $previous to $next');
    });
    print('Counter starts at ${sub.read()}');
  } finally {
    // Dispose the container when done
    container.dispose();
  }
}
