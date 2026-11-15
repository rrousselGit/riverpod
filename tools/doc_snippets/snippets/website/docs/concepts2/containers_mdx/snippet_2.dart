// GENERATED from website/docs/concepts2/containers.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
}

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

dynamic snippet() async {
  test('Counter starts at 0 and can be incremented', () {
    // No need to dispose the container when the test ends
    final container = ProviderContainer.test();

    // Use the container to test your providers
  });
}
