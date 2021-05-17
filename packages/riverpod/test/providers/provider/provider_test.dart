import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('Provider', () {
    test('can specify name', () {
      final provider = Provider(
        (_) => 0,
        name: 'example',
      );

      expect(provider.name, 'example');

      final provider2 = Provider((_) => 0);

      expect(provider2.name, isNull);
    });

    test('is AlwaysAliveProviderBase', () {
      // ignore: unused_local_variable, testing that Provider can be assigned to AlwaysAliveProviderBase
      final AlwaysAliveProviderBase provider = Provider<int>((_) => 42);
    });
  });

  // test('subscribe', () {
  //   final container = ProviderContainer();
  //   final provider = Provider((_) => 42);

  //   int? value;
  //   var callCount = 0;

  //   final sub = container.listen<int>(provider, (v) {
  //     value = v;
  //     callCount++;
  //   });

  //   expect(callCount, 1);
  //   expect(value, 42);

  //   sub.close();
  //   expect(callCount, 1);
  // });

  test('dispose', () {
    final container = createContainer();
    final onDispose = OnDisposeMock();
    final provider = Provider((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    expect(container.read(provider), 42);

    verifyZeroInteractions(onDispose);

    container.dispose();

    verify(onDispose()).called(1);
  });

  test('Provider can be overriden by anything', () {
    final provider = Provider((_) => 42);
    final AlwaysAliveProviderBase<Object?, int> override = Provider((_) {
      return 21;
    });
    final container = createContainer(overrides: [
      provider.overrideWithProvider(override),
    ]);

    expect(container.read(provider), 21);
  });

  test('Read creates the value only once', () {
    final container = createContainer();
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
    final container = createContainer();
    final counter = Counter();
    final other = StateNotifierProvider<Counter, int>((ref) => counter);
    var buildCount = 0;
    final provider = Provider((ref) {
      buildCount++;
      return ref.watch(other).isEven;
    });
    final listener = Listener<bool>();

    final sub = container.listen(provider, listener);

    verifyOnly(listener, listener(true));
    expect(sub.read(), true);
    expect(buildCount, 1);

    counter.increment();
    counter.increment();

    expect(sub.read(), true);
    expect(buildCount, 2);
    verifyNoMoreInteractions(listener);
  });

  test('rebuild notify clients if == did change', () {
    final container = createContainer();
    final counter = Counter();
    final other = StateNotifierProvider<Counter, int>((ref) => counter);
    final provider = Provider((ref) {
      return ref.watch(other).isEven;
    });
    final listener = Listener<bool>();

    final sub = container.listen(provider, listener);

    verifyOnly(listener, listener(true));
    expect(sub.read(), true);

    counter.increment();

    expect(sub.read(), false);
    verifyOnly(listener, listener(false));
  });
}
