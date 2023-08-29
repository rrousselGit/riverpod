import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('can read and set current StateNotifier', () async {
    final container = createContainer();
    final listener = Listener<int>();
    late AutoDisposeStateNotifierProviderRef<Counter, int> ref;
    final provider = StateNotifierProvider.autoDispose<Counter, int>((r) {
      ref = r;
      return Counter();
    });

    container.listen(provider, listener.call);

    verifyZeroInteractions(listener);
    expect(ref.notifier.state, 0);
  });

  test('can be auto-scoped', () async {
    final dep = Provider((ref) => 0);
    final provider =
        StateNotifierProvider.autoDispose<StateController<int>, int>(
      (ref) => StateController(ref.watch(dep)),
      dependencies: [dep],
    );
    final root = createContainer();
    final container = createContainer(
      parent: root,
      overrides: [dep.overrideWithValue(42)],
    );

    expect(container.read(provider), 42);
    expect(container.read(provider.notifier).state, 42);

    expect(root.getAllProviderElements(), isEmpty);
  });

  test('can refresh .notifier', () async {
    var initialValue = 1;
    final provider = StateNotifierProvider.autoDispose<Counter, int>(
      (ref) => Counter(initialValue),
    );
    final container = createContainer();

    container.listen(provider, (prev, value) {});

    expect(container.read(provider), 1);
    expect(container.read(provider.notifier).state, 1);

    initialValue = 42;

    expect(container.refresh(provider.notifier).state, 42);
    expect(container.read(provider), 42);
  });

  test('can be refreshed', () async {
    var result = StateController(0);
    final container = createContainer();
    final provider =
        StateNotifierProvider.autoDispose<StateController<int>, int>(
      (ref) => result,
    );

    expect(container.read(provider), 0);
    expect(container.read(provider.notifier), result);

    result = StateController(42);
    expect(container.refresh(provider), 42);

    expect(container.read(provider), 42);
    expect(container.read(provider.notifier), result);
  });

  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final controller = StateController(0);
      final provider =
          StateNotifierProvider.autoDispose<StateController<int>, int>(
        (ref) => controller,
      );
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider]);

      expect(container.read(provider.notifier), controller);
      expect(container.read(provider), 0);
      expect(root.getAllProviderElements(), isEmpty);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase<Object?>>()
              .having((e) => e.origin, 'origin', provider),
        ]),
      );
    });

    // test('when using provider.overrideWithValue', () async {
    //   final controller = StateController(0);
    //   final provider =
    //       StateNotifierProvider.autoDispose<StateController<int>, int>(
    //           (ref) => controller);
    //   final root = createContainer();
    //   final controllerOverride = StateController(42);
    //   final container = createContainer(parent: root, overrides: [
    //     provider.overrideWithValue(controllerOverride),
    //   ]);

    //   expect(container.read(provider.notifier), controllerOverride);
    //   expect(container.read(provider), 42);
    //   expect(root.getAllProviderElements(), isEmpty);
    //   expect(
    //     container.getAllProviderElements(),
    //     unorderedEquals(<Object?>[
    //       isA<ProviderElementBase<Object?>>()
    //           .having((e) => e.origin, 'origin', provider),
    //       isA<ProviderElementBase<Object?>>()
    //           .having((e) => e.origin, 'origin', provider.notifier),
    //     ]),
    //   );
    // });
  });

  // test('overriding the provider overrides provider.state too', () {
  //   final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
  //     return TestNotifier();
  //   });
  //   final notifier = TestNotifier(42);
  //   final container = createContainer(
  //     overrides: [
  //       provider.overrideWithValue(TestNotifier(10)),
  //     ],
  //   );
  //   addTearDown(container.dispose);
  //   final stateListener = Listener<int>();
  //   final notifierListener = Listener<TestNotifier>();

  //   // does not crash
  //   container.updateOverrides([
  //     provider.overrideWithValue(notifier),
  //   ]);

  //   container.listen(
  //     provider.notifier,
  //     notifierListener,
  //     fireImmediately: true,
  //   );
  //   verify(notifierListener(null, notifier)).called(1);
  //   verifyNoMoreInteractions(notifierListener);

  //   container.listen(provider, stateListener, fireImmediately: true);
  //   verify(stateListener(null, 42)).called(1);
  //   verifyNoMoreInteractions(stateListener);

  //   notifier.increment();

  //   verify(stateListener(42, 43)).called(1);
  //   verifyNoMoreInteractions(notifierListener);
  //   verifyNoMoreInteractions(stateListener);
  // });

  test('can specify name', () {
    final provider = StateNotifierProvider.autoDispose(
      (_) => TestNotifier(),
      name: 'example',
    );
    final provider2 = StateNotifierProvider.autoDispose((_) => TestNotifier());

    expect(provider.name, 'example');
    expect(provider2.name, isNull);
  });

  test('disposes the notifier when provider is unmounted', () {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
      return notifier;
    });
    final container = createContainer();
    addTearDown(container.dispose);

    container.listen(provider, (prev, value) {});
    expect(notifier.mounted, isTrue);

    container.dispose();

    expect(notifier.mounted, isFalse);
  });

  test('provider subscribe the callback is never', () async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
      return notifier;
    });
    final listener = Listener<TestNotifier>();
    final container = createContainer();
    addTearDown(container.dispose);

    container.listen(provider.notifier, listener.call, fireImmediately: true);

    verifyOnly(
      listener,
      listener(argThat(isNull), argThat(isA<TestNotifier>())),
    );

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

    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, 0));

    notifier.increment();

    verifyOnly(listener, listener(0, 1)).called(1);

    container.dispose();

    verifyNoMoreInteractions(listener);
  });

  test('.notifier obtains the controller without listening to it', () async {
    final dep = StateProvider((ref) => 0);
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final provider =
        StateNotifierProvider.autoDispose<TestNotifier, int>((ref) {
      return ref.watch(dep) == 0 ? notifier : notifier2;
    });
    final container = createContainer();
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(provider.notifier, (_, __) => callCount++);

    expect(sub.read(), notifier);
    expect(callCount, 0);

    notifier.increment();

    expect(callCount, 0);

    container.read(dep.notifier).state++;

    expect(sub.read(), notifier2);

    await container.pump();

    expect(sub.read(), notifier2);
    expect(callCount, 1);
  });

  test('overrideWithProvider preserves the state across update', () async {
    final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier(42);
    final notifier2 = TestNotifier(21);
    final container = createContainer(
      overrides: [
        // ignore: deprecated_member_use_from_same_package
        provider.overrideWithProvider(
          StateNotifierProvider.autoDispose<TestNotifier, int>((_) {
            return notifier;
          }),
        ),
      ],
    );
    addTearDown(container.dispose);
    final listener = Listener<int>();

    container.listen<int>(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, 42));
    expect(container.read(provider.notifier), notifier);
    expect(notifier.hasListeners, true);

    notifier.increment();

    verifyOnly(listener, listener(42, 43));

    container.updateOverrides([
      // ignore: deprecated_member_use_from_same_package
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
    verifyOnly(listener, listener(43, 44));
    expect(notifier.mounted, true);

    container.dispose();

    expect(notifier.mounted, false);
  });
}

class TestNotifier extends StateNotifier<int> {
  TestNotifier([super.initialValue = 0]);

  void increment() => state++;

  @override
  String toString() {
    return 'TestNotifier($state)';
  }
}
