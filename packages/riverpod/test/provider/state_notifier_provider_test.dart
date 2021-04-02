import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('StateNotifierFamily override', () {
    final provider =
        StateNotifierProvider.family<TestNotifier, int, int>((ref, a) {
      return TestNotifier();
    });
    final notifier2 = TestNotifier(42);
    final container = ProviderContainer(
      overrides: [
        provider.overrideWithProvider((ref, a) => notifier2),
      ],
    );

    expect(container.read(provider(0).notifier), notifier2);
    // access in the child container
    // try to read provider.state before provider and see if it points to the override
    expect(container.read(provider(0)), 42);
  });

  test('overriding the provider overrides provider.state too', () {
    final notifier = TestNotifier(42);
    final provider =
        StateNotifierProvider<TestNotifier, int>((_) => TestNotifier());
    final container = ProviderContainer(
      overrides: [
        provider.overrideWithValue(TestNotifier(10)),
      ],
    );

    // does not crash
    container.updateOverrides([
      provider.overrideWithValue(notifier),
    ]);

    expect(container.read(provider.notifier), notifier);
    expect(container.read(provider), 42);

    notifier.increment();

    expect(container.read(provider), 43);
  });

  test('can specify name', () {
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return TestNotifier();
    }, name: 'example');

    expect(provider.notifier.name, 'example.notifier');
    expect(provider.name, 'example');

    final provider2 =
        StateNotifierProvider<TestNotifier, int>((_) => TestNotifier());

    expect(provider2.notifier.name, isNull);
    expect(provider2.name, isNull);
  });

  test('disposes the notifier when provider is unmounted', () {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return notifier;
    });
    final container = ProviderContainer();

    expect(container.read(provider.notifier), notifier);
    expect(notifier.mounted, isTrue);

    container.dispose();

    expect(notifier.mounted, isFalse);
  });

  test('provider subscribe the callback is never', () async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return notifier;
    });
    final listener = ControllerListenerMock();
    final container = ProviderContainer();

    final sub = provider.notifier.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(argThat(isA<TestNotifier>()))).called(1);
    verifyNoMoreInteractions(listener);

    notifier.increment();

    verifyNoMoreInteractions(listener);
    sub.read();

    verifyNoMoreInteractions(listener);

    container.dispose();
    await Future.value(null);

    verifyNoMoreInteractions(listener);
  });

  test('provider subscribe callback never called', () async {
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final listener = ListenerMock();
    final container = ProviderContainer();

    final sub = provider.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);

    container.read(provider.notifier).increment();

    verifyNoMoreInteractions(listener);
    sub.read();
    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);

    container.dispose();
    await Future.value(null);

    verifyNoMoreInteractions(listener);
  });
}

class TestNotifier extends StateNotifier<int> {
  TestNotifier([int initialValue = 0]) : super(initialValue);

  void increment() => state++;

  @override
  String toString() {
    return 'TestNotifier($state)';
  }
}

class ListenerMock extends Mock {
  void call(int value);
}

class ControllerListenerMock extends Mock {
  void call(TestNotifier? value);
}
