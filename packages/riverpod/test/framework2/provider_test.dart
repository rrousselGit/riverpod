import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  ProviderContainer container;
  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('Read creates the value only once', () {
    var callCount = 0;
    final provider = Provider((ref) {
      callCount++;
      return 42;
    });

    expect(callCount, 0);
    expect(container.read(provider), 42);
    expect(callCount, 1);

    expect(container.read(provider), 42);
    expect(callCount, 1);
  });
  test("rebuild don't notify clients if == doesn't change", () {
    final counter = Counter();
    final other = StateNotifierProvider((ref) => counter);
    final provider = Provider((ref) {
      return ref.watch(other.state).isEven;
    });

    final sub = container.listen(provider);

    expect(sub.read(), true);

    counter.increment();
    counter.increment();

    expect(sub.flush(), false);
    expect(sub.read(), true);
  });
  test('rebuild notify clients if == did change', () {
    final counter = Counter();
    final other = StateNotifierProvider((ref) => counter);
    final provider = Provider((ref) {
      return ref.watch(other.state).isEven;
    });

    final sub = container.listen(provider);

    expect(sub.read(), true);

    counter.increment();

    expect(sub.flush(), true);
    expect(sub.read(), false);
  });
}
