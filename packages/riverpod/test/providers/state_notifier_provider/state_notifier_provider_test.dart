import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('can be refreshed', () {}, skip: true);

  group('scope', () {
    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final controller = StateController(0);
        final provider = StateNotifierProvider<StateController<int>, int>(
            (ref) => controller);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider.notifier), controller);
        expect(container.read(provider), 0);
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.notifier),
          ]),
        );
      });

      test('when using provider.overrideWithValue', () async {
        final controller = StateController(0);
        final provider = StateNotifierProvider<StateController<int>, int>(
            (ref) => controller);
        final root = createContainer();
        final controllerOverride = StateController(42);
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithValue(controllerOverride),
        ]);

        expect(container.read(provider.notifier), controllerOverride);
        expect(container.read(provider), 42);
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.notifier),
          ]),
        );
      });

      test('when using provider.overrideWithProvider', () async {
        final controller = StateController(0);
        final provider = StateNotifierProvider<StateController<int>, int>(
            (ref) => controller);
        final root = createContainer();
        final controllerOverride = StateController(42);
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider(
            StateNotifierProvider((ref) => controllerOverride),
          ),
        ]);

        expect(container.read(provider.notifier), controllerOverride);
        expect(container.read(provider), 42);
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.notifier),
          ]),
        );
      });
    });
  });

  test('StateNotifierFamily override', () {
    final provider =
        StateNotifierProvider.family<TestNotifier, int, int>((ref, a) {
      return TestNotifier();
    });
    final notifier2 = TestNotifier(42);
    final container = createContainer(
      overrides: [
        provider.overrideWithProvider((a) {
          return StateNotifierProvider<TestNotifier, int>(
            (ref) => notifier2,
          );
        }),
      ],
    );
    addTearDown(container.dispose);

    // try to read provider.state before provider and see if it points to the override
    expect(container.read(provider(0)), 42);
    expect(container.read(provider(0).notifier), notifier2);
  });

  test('overriding the provider overrides provider.state too', () {
    final notifier = TestNotifier(42);
    final provider =
        StateNotifierProvider<TestNotifier, int>((_) => TestNotifier());
    final container = createContainer(
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
    final container = createContainer();
    addTearDown(container.dispose);

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
    final container = createContainer();
    addTearDown(container.dispose);

    container.listen(provider.notifier, listener, fireImmediately: true);

    verifyOnly(listener, listener(argThat(isA<TestNotifier>())));

    notifier.increment();

    await container.pump();

    verifyNoMoreInteractions(listener);

    container.dispose();

    verifyNoMoreInteractions(listener);
  });

  test('provider subscribe callback never called', () async {
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final listener = ListenerMock();
    final container = createContainer();
    addTearDown(container.dispose);

    container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(0));

    container.read(provider.notifier).increment();

    verifyOnly(listener, listener(1));

    container.dispose();

    verifyNoMoreInteractions(listener);
  });

  test('.notifier obtains the controller without listening to it', () async {
    final dep = StateProvider((ref) => 0);
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final provider = StateNotifierProvider<TestNotifier, int>((ref) {
      return ref.watch(dep).state == 0 ? notifier : notifier2;
    });
    final container = createContainer();
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(
      provider.notifier,
      (_) => callCount++,
    );

    expect(sub.read(), notifier);
    expect(callCount, 0);

    notifier.increment();

    await container.pump();

    expect(callCount, 0);

    container.read(dep).state++;

    expect(sub.read(), notifier2);

    await container.pump();

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
    final container = createContainer(overrides: [
      provider.overrideWithValue(notifier),
    ]);
    addTearDown(container.dispose);
    final listener = ListenerMock();

    container.listen<int>(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(42));
    expect(container.read(provider.notifier), notifier);
    expect(notifier.hasListeners, true);

    notifier.increment();

    await container.pump();

    verifyOnly(listener, listener(43));

    container.updateOverrides([
      provider.overrideWithValue(notifier2),
    ]);

    await container.pump();

    verifyOnly(listener, listener(21));

    expect(notifier.hasListeners, false);
    expect(notifier.mounted, true);
    expect(container.read(provider.notifier), notifier2);

    notifier2.increment();

    await container.pump();

    verifyOnly(listener, listener(22));
  });

  test('overrideWithProvider preserves the state accross update', () async {
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier(42);
    final notifier2 = TestNotifier(21);
    final container = createContainer(overrides: [
      provider.overrideWithProvider(
        StateNotifierProvider<TestNotifier, int>((_) {
          return notifier;
        }),
      ),
    ]);
    addTearDown(container.dispose);
    final listener = ListenerMock();

    container.listen<int>(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(42));
    expect(container.read(provider.notifier), notifier);
    expect(notifier.hasListeners, true);

    notifier.increment();

    await container.pump();
    verifyOnly(listener, listener(43));

    container.updateOverrides([
      provider.overrideWithProvider(
        StateNotifierProvider<TestNotifier, int>((_) {
          return notifier2;
        }),
      ),
    ]);

    await container.pump();
    expect(container.read(provider.notifier), notifier);
    expect(notifier2.hasListeners, false);
    verifyNoMoreInteractions(listener);

    notifier.increment();

    await container.pump();
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
