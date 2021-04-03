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
    addTearDown(container.dispose);

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
    addTearDown(container.dispose);

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
    addTearDown(container.dispose);

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
    addTearDown(container.dispose);

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

  test('.notifier obtains the controller without listening to it', () {
    final dep = StateProvider((ref) => 0);
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final provider = StateNotifierProvider<TestNotifier, int>((ref) {
      return ref.watch(dep).state == 0 ? notifier : notifier2;
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(
      provider.notifier,
      didChange: (_) => callCount++,
    );

    expect(sub.read(), notifier);
    expect(callCount, 0);

    notifier.increment();

    sub.flush();
    expect(callCount, 0);

    container.read(dep).state++;

    expect(sub.read(), notifier2);

    sub.flush();
    expect(sub.read(), notifier2);
    expect(callCount, 1);
  });

  test(
      'overrideWithValue listens to the notifier, support notifier change, and does not dispose of the notifier',
      () async {
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier(42);
    final notifier2 = TestNotifier(21);
    final container = ProviderContainer(overrides: [
      provider.overrideWithValue(notifier),
    ]);
    addTearDown(container.dispose);
    final listener = ListenerMock();

    final sub = container.listen<int>(
      provider,
      didChange: (sub) => listener(sub.read()),
    );

    expect(sub.read(), 42);
    expect(container.read(provider.notifier), notifier);
    expect(notifier.hasListeners, true);

    notifier.increment();

    sub.flush();
    verifyOnly(listener, listener(43));

    container.updateOverrides([
      provider.overrideWithValue(notifier2),
    ]);

    sub.flush();
    verifyOnly(listener, listener(21));
    expect(notifier.hasListeners, false);
    expect(notifier.mounted, true);
    expect(container.read(provider.notifier), notifier2);

    notifier2.increment();

    sub.flush();
    verifyOnly(listener, listener(22));
  });

  test('overrideWithProvider preserves the state accross update', () {
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier(42);
    final notifier2 = TestNotifier(21);
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider(
        StateNotifierProvider<TestNotifier, int>((_) {
          return notifier;
        }),
      ),
    ]);
    addTearDown(container.dispose);
    final listener = ListenerMock();

    final sub = container.listen<int>(
      provider,
      didChange: (sub) => listener(sub.read()),
    );

    expect(sub.read(), 42);
    expect(container.read(provider.notifier), notifier);
    expect(notifier.hasListeners, true);

    notifier.increment();

    sub.flush();
    verifyOnly(listener, listener(43));

    container.updateOverrides([
      provider.overrideWithProvider(
        StateNotifierProvider<TestNotifier, int>((_) {
          return notifier2;
        }),
      ),
    ]);

    sub.flush();
    expect(container.read(provider.notifier), notifier);
    expect(notifier2.hasListeners, false);
    verifyNoMoreInteractions(listener);

    notifier.increment();

    sub.flush();
    expect(container.read(provider.notifier), notifier);
    verifyOnly(listener, listener(44));
    expect(notifier.mounted, true);

    container.dispose();

    expect(notifier.mounted, false);
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
