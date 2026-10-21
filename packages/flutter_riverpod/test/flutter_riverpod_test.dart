import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exports provider.listenable', () {
    final container = ProviderContainer.test();
    final provider = NotifierProvider<_Counter, int>(_Counter.new);

    final sub = container.listen(provider.listenable, (_, _) {});
    final listenable = sub.read();
    expect(listenable.value, 0);

    container.read(provider.notifier).increment();
    expect(listenable.value, 1);
  });
}

class _Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}
