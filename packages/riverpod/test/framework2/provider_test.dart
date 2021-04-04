import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  late ProviderContainer container;
  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('Provider.autoDispose can be overriden by auto-dispose providers', () {
    final provider = Provider.autoDispose((_) => 42);
    final AutoDisposeProviderBase<Object?, int> override =
        Provider.autoDispose((_) => 21);
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider(override),
    ]);

    final sub = container.listen(provider);

    expect(sub.read(), 21);
  });

  test('Provider can be overriden by anything', () {
    final provider = Provider((_) => 42);
    final AlwaysAliveProviderBase<Object?, int> override = Provider((_) {
      return 21;
    });
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider(override),
    ]);

    final sub = container.listen(provider);

    expect(sub.read(), 21);
  });

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
    final other = StateNotifierProvider<Counter, int>((ref) => counter);
    final provider = Provider((ref) {
      return ref.watch(other).isEven;
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
    final other = StateNotifierProvider<Counter, int>((ref) => counter);
    final provider = Provider((ref) {
      return ref.watch(other).isEven;
    });

    final sub = container.listen(provider);

    expect(sub.read(), true);

    counter.increment();

    expect(sub.flush(), true);
    expect(sub.read(), false);
  });
}
