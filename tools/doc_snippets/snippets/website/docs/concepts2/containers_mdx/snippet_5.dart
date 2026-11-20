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
    final container = ProviderContainer.test();

    expect(container.read(counterProvider), 0);
    container.read(counterProvider.notifier).increment();
    expect(container.read(counterProvider), 1);
  });

  test('Counter cannot go below 0', () {
    final container = ProviderContainer.test();

    expect(container.read(counterProvider), 0);
    container.read(counterProvider.notifier).decrement();
    expect(container.read(counterProvider), 0);
  });
}
