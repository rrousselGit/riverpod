// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ProviderElement;
import 'package:test/test.dart';

import '../../../utils.dart';

void main() {
  test('Guards StateNotifier.dispose', () {
    final notifier = DelegateNotifier(
      onDispose: () => throw StateError('called'),
    );
    final container = ProviderContainer.test();
    final provider = StateNotifierProvider((_) => notifier);

    container.read(provider);

    final errors = <Object>[];

    runZonedGuarded(
      () => container.invalidate(provider),
      (error, stack) => errors.add(error),
    );

    expect(errors, [isStateError]);
  });

  test('supports overrideWith', () {
    final provider = StateNotifierProvider<TestNotifier, int>(
      (ref) => TestNotifier(),
    );
    final autoDispose = StateNotifierProvider.autoDispose<TestNotifier, int>(
      (ref) => TestNotifier(),
    );
    final container = ProviderContainer.test(
      overrides: [
        provider.overrideWith((ref) => TestNotifier(42)),
        autoDispose.overrideWith((ref) => TestNotifier(84)),
      ],
    );

    expect(container.read(provider), 42);
    expect(container.read(autoDispose), 84);
  });

  test('supports family overrideWith', () {
    final family = StateNotifierProvider.family<TestNotifier, int, int>(
      (ref, arg) => TestNotifier(0 + arg),
    );
    final autoDisposeFamily =
        StateNotifierProvider.autoDispose.family<TestNotifier, int, int>(
      (ref, arg) => TestNotifier(0 + arg),
    );
    final container = ProviderContainer.test(
      overrides: [
        family.overrideWith((ref, int arg) => TestNotifier(42 + arg)),
        autoDisposeFamily.overrideWith(
          (ref, int arg) => TestNotifier(84 + arg),
        ),
      ],
    );

    expect(container.read(family(10)), 52);
    expect(container.read(autoDisposeFamily(10)), 94);
  });

  test(
      'on refresh, does not notify listeners if the new value is identical to the previous one',
      () {
    // regression test for https://github.com/rrousselGit/riverpod/issues/1560
    final container = ProviderContainer.test();
    final provider = StateNotifierProvider<StateController<int>, int>(
      (ref) => StateController(0),
    );
    final listener = Listener<int>();

    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, 0));

    container.refresh(provider);

    verifyNoMoreInteractions(listener);
  });

  test('ref.listenSelf listens to state changes', () {
    final listener = Listener<int>();
    final container = ProviderContainer.test();
    final provider = StateNotifierProvider<StateController<int>, int>((ref) {
      ref.listenSelf(listener.call);
      return StateController(0);
    });

    final notifier = container.read(provider.notifier);

    verifyOnly(listener, listener(null, 0));

    notifier.state++;

    verifyOnly(listener, listener(0, 1));
  });

  test('can read and set current StateNotifier', () async {
    final container = ProviderContainer.test();
    final listener = Listener<int>();
    late Ref<int> ref;
    final provider = StateNotifierProvider<Counter, int>((r) {
      ref = r;
      return Counter();
    });

    container.listen(provider, listener.call);

    verifyZeroInteractions(listener);
    expect(ref.state, 0);
  });

  test('can be auto-scoped', () async {
    final dep = Provider(
      (ref) => 0,
      dependencies: const [],
    );
    final provider = StateNotifierProvider<StateController<int>, int>(
      (ref) => StateController(ref.watch(dep)),
      dependencies: [dep],
    );
    final root = ProviderContainer.test();
    final container = ProviderContainer.test(
      parent: root,
      overrides: [dep.overrideWithValue(42)],
    );

    expect(container.read(provider), 42);
    expect(container.read(provider.notifier).state, 42);

    expect(root.getAllProviderElements(), isEmpty);
  });

  test('can refresh .notifier', () async {
    var initialValue = 1;
    final provider =
        StateNotifierProvider<Counter, int>((ref) => Counter(initialValue));
    final container = ProviderContainer.test();

    expect(container.read(provider), 1);
    expect(container.read(provider.notifier).state, 1);

    initialValue = 42;

    expect(container.refresh(provider.notifier).state, 42);
    expect(container.read(provider), 42);
  });

  test('can be refreshed', () async {
    var result = StateController(0);
    final container = ProviderContainer.test();
    final provider =
        StateNotifierProvider<StateController<int>, int>((ref) => result);

    expect(container.read(provider), 0);
    expect(container.read(provider.notifier), result);

    result = StateController(42);
    expect(container.refresh(provider), 42);

    expect(container.read(provider), 42);
    expect(container.read(provider.notifier), result);
  });

  group('scope', () {
    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final controller = StateController(0);
        final provider = StateNotifierProvider<StateController<int>, int>(
          (ref) => controller,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        expect(container.read(provider.notifier), controller);
        expect(container.read(provider), 0);
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          ]),
        );
      });

      test('when using provider.overrideWith', () async {
        final controller = StateController(0);
        final provider =
            StateNotifierProvider.autoDispose<StateController<int>, int>(
          (ref) => controller,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final controllerOverride = StateController(42);
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            provider.overrideWith((ref) => controllerOverride),
          ],
        );

        expect(container.read(provider.notifier), controllerOverride);
        expect(container.read(provider), 42);
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          ]),
        );
      });
    });
  });

  test('can specify name', () {
    final provider = StateNotifierProvider<TestNotifier, int>(
      (_) {
        return TestNotifier();
      },
      name: 'example',
    );
    final provider2 =
        StateNotifierProvider<TestNotifier, int>((_) => TestNotifier());

    expect(provider.name, 'example');
    expect(provider2.name, isNull);
  });

  test('disposes the notifier when provider is unmounted', () {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return notifier;
    });
    final container = ProviderContainer.test();
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
    final listener = Listener<TestNotifier>();
    final container = ProviderContainer.test();
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
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final listener = Listener<int>();
    final container = ProviderContainer.test();
    addTearDown(container.dispose);

    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, 0));

    container.read(provider.notifier).increment();

    verifyOnly(listener, listener(0, 1));

    container.dispose();

    verifyNoMoreInteractions(listener);
  });

  test('.notifier obtains the controller without listening to it', () async {
    final dep = StateProvider((ref) => 0);
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final provider = StateNotifierProvider<TestNotifier, int>((ref) {
      return ref.watch(dep) == 0 ? notifier : notifier2;
    });
    final container = ProviderContainer.test();
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(
      provider.notifier,
      (_, __) => callCount++,
    );

    expect(sub.read(), notifier);
    expect(callCount, 0);

    notifier.increment();

    await container.pump();

    expect(callCount, 0);

    container.read(dep.notifier).state++;

    expect(sub.read(), notifier2);

    await container.pump();

    expect(sub.read(), notifier2);
    expect(callCount, 1);
  });

  // test(
  //     'overrideWithValue listens to the notifier, support notifier change, and does not dispose of the notifier',
  //     () async {
  //   final provider = StateNotifierProvider<TestNotifier, int>((_) {
  //     return TestNotifier();
  //   });
  //   final notifier = TestNotifier(42);
  //   final notifier2 = TestNotifier(21);
  //   final container = ProviderContainer.test(overrides: [
  //     provider.overrideWithValue(notifier),
  //   ]);
  //   addTearDown(container.dispose);
  //   final listener = Listener<int>();

  //   container.listen<int>(provider, listener, fireImmediately: true);

  //   verifyOnly(listener, listener(null, 42));
  //   expect(container.read(provider.notifier), notifier);
  //   expect(notifier.hasListeners, true);

  //   notifier.increment();

  //   await container.pump();

  //   verifyOnly(listener, listener(42, 43));

  //   container.updateOverrides([
  //     provider.overrideWithValue(notifier2),
  //   ]);

  //   await container.pump();

  //   verifyOnly(listener, listener(43, 21));

  //   expect(notifier.hasListeners, false);
  //   expect(notifier.mounted, true);
  //   expect(container.read(provider.notifier), notifier2);

  //   notifier2.increment();

  //   await container.pump();

  //   verifyOnly(listener, listener(21, 22));
  // });

  test('overrideWith preserves the state across update', () async {
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier(42);
    final notifier2 = TestNotifier(21);
    final container = ProviderContainer.test(
      overrides: [
        provider.overrideWith((_) => notifier),
      ],
    );
    addTearDown(container.dispose);
    final listener = Listener<int>();

    container.listen<int>(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, 42));
    expect(container.read(provider.notifier), notifier);
    expect(notifier.hasListeners, true);

    notifier.increment();

    await container.pump();
    verifyOnly(listener, listener(42, 43));

    container.updateOverrides([
      provider.overrideWith((_) => notifier2),
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

class DelegateNotifier extends StateNotifier<int> {
  DelegateNotifier({this.onDispose}) : super(0);

  final void Function()? onDispose;

  @override
  void dispose() {
    onDispose?.call();
    super.dispose();
  }
}
