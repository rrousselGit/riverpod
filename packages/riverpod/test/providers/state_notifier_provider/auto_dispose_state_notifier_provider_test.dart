import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final controller = StateController(0);
      final provider =
          StateNotifierProvider.autoDispose<StateController<int>, int>(
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
      final provider =
          StateNotifierProvider.autoDispose<StateController<int>, int>(
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
      final provider =
          StateNotifierProvider.autoDispose<StateController<int>, int>(
              (ref) => controller);
      final root = createContainer();
      final controllerOverride = StateController(42);
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithProvider(
          StateNotifierProvider.autoDispose((ref) => controllerOverride),
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

  test('StateNotifierFamily override', () async {
    final notifier2 = TestNotifier(42);
    final provider = StateNotifierProvider.autoDispose
        .family<TestNotifier, int, int>((ref, a) => TestNotifier());
    final container = createContainer(
      overrides: [
        provider.overrideWithProvider((a) {
          return StateNotifierProvider.autoDispose<TestNotifier, int>(
            (ref) => notifier2,
          );
        }),
      ],
    );
    addTearDown(container.dispose);
    final ownerStateListener = Listener<int>();
    final ownerNotifierListener = Listener<TestNotifier>();

    // access in the child container
    // try to read provider.state before provider and see if it points to the override
    final stateSub = container.listen(
      provider(0),
      ownerStateListener,
      fireImmediately: true,
    );

    verify(ownerStateListener(42)).called(1);
    verifyNoMoreInteractions(ownerStateListener);

    final notifierSub = container.listen(
      provider(0).notifier,
      ownerNotifierListener,
      fireImmediately: true,
    );
    verifyOnly(ownerNotifierListener, ownerNotifierListener(notifier2));

    notifierSub.close();

    await container.pump();

    expect(notifier2.mounted, true);

    stateSub.close();

    expect(notifier2.mounted, true);

    await container.pump();

    await container.pump();

    expect(notifier2.mounted, false);
  });

  test('overriding the provider overrides provider.state too', () {
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier(42);
    final container = createContainer(
      overrides: [
        provider.overrideWithValue(TestNotifier(10)),
      ],
    );
    addTearDown(container.dispose);
    final stateListener = Listener<int>();
    final notifierListener = Listener<TestNotifier>();

    // does not crash
    container.updateOverrides([
      provider.overrideWithValue(notifier),
    ]);

    container.listen(provider.notifier, notifierListener,
        fireImmediately: true);
    verify(notifierListener(notifier)).called(1);
    verifyNoMoreInteractions(notifierListener);

    container.listen(provider, stateListener, fireImmediately: true);
    verify(stateListener(42)).called(1);
    verifyNoMoreInteractions(stateListener);

    notifier.increment();

    verify(stateListener(43)).called(1);
    verifyNoMoreInteractions(notifierListener);
    verifyNoMoreInteractions(stateListener);
  });

  test('can specify name', () {
    final provider = StateNotifierProvider.autoDispose(
      (_) => TestNotifier(),
      name: 'example',
    );

    expect(provider.notifier.name, 'example.notifier');
    expect(provider.name, 'example');

    final provider2 = StateNotifierProvider.autoDispose((_) => TestNotifier());

    expect(provider2.notifier.name, isNull);
    expect(provider2.name, isNull);
  });

  test('disposes the notifier when provider is unmounted', () {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
      return notifier;
    });
    final container = createContainer();
    addTearDown(container.dispose);

    container.listen(provider, (value) {});
    expect(notifier.mounted, isTrue);

    container.dispose();

    expect(notifier.mounted, isFalse);
  });

  test('provider subscribe the callback is never', () async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
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
    final notifier = TestNotifier();
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
      return notifier;
    });
    final listener = Listener<int>();
    final container = createContainer();
    addTearDown(container.dispose);

    container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(argThat(equals(0))));

    notifier.increment();

    verifyOnly(listener, listener(1)).called(1);

    container.dispose();

    verifyNoMoreInteractions(listener);
  });

  test('.notifier obtains the controller without listening to it', () async {
    final dep = StateProvider((ref) => 0);
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final provider =
        StateNotifierProvider.autoDispose<TestNotifier, int>((ref) {
      return ref.watch(dep).state == 0 ? notifier : notifier2;
    });
    final container = createContainer();
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(provider.notifier, (_) => callCount++);

    expect(sub.read(), notifier);
    expect(callCount, 0);

    notifier.increment();

    expect(callCount, 0);

    container.read(dep).state++;

    expect(sub.read(), notifier2);

    await container.pump();

    expect(sub.read(), notifier2);
    expect(callCount, 1);
  });

  test('overrideWithProvider preserves the state accross update', () async {
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier(42);
    final notifier2 = TestNotifier(21);
    final container = createContainer(overrides: [
      provider.overrideWithProvider(
        StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
          return notifier;
        }),
      ),
    ]);
    addTearDown(container.dispose);
    final listener = Listener<int>();

    container.listen<int>(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(42));
    expect(container.read(provider.notifier), notifier);
    expect(notifier.hasListeners, true);

    notifier.increment();

    verifyOnly(listener, listener(43));

    container.updateOverrides([
      provider.overrideWithProvider(
        StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
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

class ControllerListenerMock extends Mock {
  void call(TestNotifier? value);
}
