// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show InternalProviderContainer;
import 'package:riverpod/src/internals.dart' show ProviderElement;
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('StateNotifierProvider', () {
    test('Guards StateNotifier.dispose', () {
      final notifier = DelegateNotifier(
        onDispose: () => throw StateError('called'),
      );
      final errors = <Object>[];
      final container = runZonedGuarded(
        ProviderContainer.test,
        (err, stack) => errors.add(err),
      )!;
      final provider = StateNotifierProvider<DelegateNotifier, int>(
        (_) => notifier,
      );

      container.read(provider);
      container.invalidate(provider);

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
      },
    );

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
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
      final provider = StateNotifierProvider<Counter, int>(
        (ref) => Counter(initialValue),
      );
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
      final provider = StateNotifierProvider<StateController<int>, int>(
        (ref) => result,
      );

      expect(container.read(provider), 0);
      expect(container.read(provider.notifier), result);

      result = StateController(42);
      expect(container.refresh(provider), 42);

      expect(container.read(provider), 42);
      expect(container.read(provider.notifier), result);
    });

    group('scope', () {
      group(
        'scoping an override overrides all the associated subproviders',
        () {
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
                isA<ProviderElement>().having(
                  (e) => e.origin,
                  'origin',
                  provider,
                ),
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
              overrides: [provider.overrideWith((ref) => controllerOverride)],
            );

            expect(container.read(provider.notifier), controllerOverride);
            expect(container.read(provider), 42);
            expect(root.getAllProviderElements(), isEmpty);
            expect(
              container.getAllProviderElements(),
              unorderedEquals(<Object?>[
                isA<ProviderElement>().having(
                  (e) => e.origin,
                  'origin',
                  provider,
                ),
              ]),
            );
          });
        },
      );
    });

    test('can specify name', () {
      final provider = StateNotifierProvider<TestNotifier, int>((_) {
        return TestNotifier();
      }, name: 'example');
      final provider2 = StateNotifierProvider<TestNotifier, int>(
        (_) => TestNotifier(),
      );

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
      final sub = container.listen(provider.notifier, (_, _) => callCount++);

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
        overrides: [provider.overrideWith((_) => notifier)],
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

      container.updateOverrides([provider.overrideWith((_) => notifier2)]);

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
  });

  group('StateNotifierProvider.family', () {
    test('specifies `from` & `argument` for related providers', () {
      final provider = StateNotifierProvider.family<Counter, int, int>(
        (ref, _) => Counter(),
      );

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider =
          StateNotifierProvider.family<StateController<int>, int, int>(
            (ref, i) => StateController(ref.watch(dep) + i),
            dependencies: [dep],
          );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10)), 52);
      expect(container.read(provider(10).notifier).state, 52);

      expect(root.getAllProviderElements(), isEmpty);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final controller = StateController(0);
        final provider =
            StateNotifierProvider.family<StateController<int>, int, int>(
              (ref, _) => controller,
              dependencies: const [],
            );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        expect(container.read(provider(0).notifier), controller);
        expect(container.read(provider(0)), 0);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having(
              (e) => e.origin,
              'origin',
              provider(0),
            ),
          ]),
        );
        expect(root.getAllProviderElementsInOrder(), isEmpty);
      });

      test('when using provider.overrideWith', () async {
        final controller = StateController(0);
        final provider =
            StateNotifierProvider.family<StateController<int>, int, int>(
              (ref, _) => controller,
              dependencies: const [],
            );
        final root = ProviderContainer.test();
        final controllerOverride = StateController(42);
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            provider.overrideWith((ref, value) => controllerOverride),
          ],
        );

        expect(container.read(provider(0).notifier), controllerOverride);
        expect(container.read(provider(0)), 42);
        expect(root.getAllProviderElementsInOrder(), isEmpty);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having(
              (e) => e.origin,
              'origin',
              provider(0),
            ),
          ]),
        );
      });
    });

    test('StateNotifierProviderFamily.toString includes argument & name', () {
      final family = StateNotifierProvider.family<Counter, int, String>(
        (ref, id) => Counter(),
        name: 'Example',
      );

      expect(family('foo').toString(), equalsIgnoringHashCodes('Example(foo)'));
    });

    test('properly overrides ==', () {
      final family = StateNotifierProvider.family<Counter, int, int>(
        (ref, _) => Counter(),
      );

      expect(family(0), family(0));
      expect(family(1), isNot(family(0)));
      expect(family(1), family(1));
    });

    test('scoping a provider overrides all the associated subproviders', () {
      final family = StateNotifierProvider.family<Counter, int, String>(
        (ref, id) => Counter(),
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [family],
      );

      expect(container.read(family('0')), 0);
      expect(container.read(family('0').notifier), isA<Counter>());

      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElement>().having(
          (e) => e.provider,
          'provider',
          family('0'),
        ),
      ]);
    });

    test('StateNotifierFamily override', () async {
      final notifier2 = TestNotifier(42);
      final provider = StateNotifierProvider.autoDispose
          .family<TestNotifier, int, int>((ref, a) => TestNotifier());
      final container = ProviderContainer.test(
        overrides: [provider.overrideWith((ref, a) => notifier2)],
      );
      addTearDown(container.dispose);
      final ownerStateListener = Listener<int>();
      final ownerNotifierListener = Listener<TestNotifier>();

      // access in the child container
      // try to read provider.state before provider and see if it points to the override
      final stateSub = container.listen(
        provider(0),
        ownerStateListener.call,
        fireImmediately: true,
      );

      verify(ownerStateListener(null, 42)).called(1);
      verifyNoMoreInteractions(ownerStateListener);

      final notifierSub = container.listen(
        provider(0).notifier,
        ownerNotifierListener.call,
        fireImmediately: true,
      );
      verifyOnly(ownerNotifierListener, ownerNotifierListener(null, notifier2));

      notifierSub.close();

      await container.pump();

      expect(notifier2.mounted, true);

      stateSub.close();

      expect(notifier2.mounted, true);

      await container.pump();

      await container.pump();

      expect(notifier2.mounted, false);
    });

    test('supports family overrideWith', () {
      final family = StateNotifierProvider.family<TestNotifier, int, int>(
        (ref, arg) => TestNotifier(0 + arg),
      );
      final autoDisposeFamily = StateNotifierProvider.autoDispose
          .family<TestNotifier, int, int>((ref, arg) => TestNotifier(0 + arg));
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
  });

  group('StateNotifierProvider.autoDispose', () {
    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider =
          StateNotifierProvider.autoDispose<StateController<int>, int>(
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
      final provider = StateNotifierProvider.autoDispose<Counter, int>(
        (ref) => Counter(initialValue),
      );
      final container = ProviderContainer.test();

      container.listen(provider, (prev, value) {});

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
    });

    test('can specify name', () {
      final provider = StateNotifierProvider.autoDispose<TestNotifier, int>(
        (_) => TestNotifier(),
        name: 'example',
      );
      final provider2 = StateNotifierProvider.autoDispose<TestNotifier, int>(
        (_) => TestNotifier(),
      );

      expect(provider.name, 'example');
      expect(provider2.name, isNull);
    });

    test('disposes the notifier when provider is unmounted', () {
      final notifier = TestNotifier();
      final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((
        _,
      ) {
        return notifier;
      });
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.listen(provider, (prev, value) {});
      expect(notifier.mounted, isTrue);

      container.dispose();

      expect(notifier.mounted, isFalse);
    });

    test('provider subscribe the callback is never', () async {
      final notifier = TestNotifier();
      final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((
        _,
      ) {
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
      final notifier = TestNotifier();
      final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((
        _,
      ) {
        return notifier;
      });
      final listener = Listener<int>();
      final container = ProviderContainer.test();
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
      final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((
        ref,
      ) {
        return ref.watch(dep) == 0 ? notifier : notifier2;
      });
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      var callCount = 0;
      final sub = container.listen(provider.notifier, (_, _) => callCount++);

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

    test('overrideWith preserves the state across update', () async {
      final provider = StateNotifierProvider.autoDispose<TestNotifier, int>((
        _,
      ) {
        return TestNotifier();
      });
      final notifier = TestNotifier(42);
      final notifier2 = TestNotifier(21);
      final container = ProviderContainer.test(
        overrides: [provider.overrideWith((_) => notifier)],
      );
      addTearDown(container.dispose);
      final listener = Listener<int>();

      container.listen<int>(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 42));
      expect(container.read(provider.notifier), notifier);
      expect(notifier.hasListeners, true);

      notifier.increment();

      verifyOnly(listener, listener(42, 43));

      container.updateOverrides([provider.overrideWith((_) => notifier2)]);

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
  });

  group('StateNotifierProvider.autoDispose.family', () {
    test('specifies `from` & `argument` for related providers', () {
      final provider = StateNotifierProvider.autoDispose
          .family<Counter, int, int>((ref, _) => Counter());

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider = StateNotifierProvider.autoDispose
          .family<StateController<int>, int, int>(
            (ref, i) => StateController(ref.watch(dep) + i),
            dependencies: [dep],
          );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10)), 52);
      expect(container.read(provider(10).notifier).state, 52);

      expect(root.getAllProviderElements(), isEmpty);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final controller = StateController(0);
        final provider = StateNotifierProvider.autoDispose
            .family<StateController<int>, int, int>(
              (ref, _) => controller,
              dependencies: const [],
            );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        expect(container.read(provider(0).notifier), controller);
        expect(container.read(provider(0)), 0);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having(
              (e) => e.origin,
              'origin',
              provider(0),
            ),
          ]),
        );
        expect(root.getAllProviderElementsInOrder(), isEmpty);
      });

      test('when using provider.overrideWith', () async {
        final controller = StateController(0);
        final provider = StateNotifierProvider.autoDispose
            .family<StateController<int>, int, int>(
              (ref, _) => controller,
              dependencies: const [],
            );
        final root = ProviderContainer.test();
        final controllerOverride = StateController(42);
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            provider.overrideWith((ref, value) => controllerOverride),
          ],
        );

        expect(container.read(provider(0).notifier), controllerOverride);
        expect(container.read(provider(0)), 42);
        expect(root.getAllProviderElementsInOrder(), isEmpty);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having(
              (e) => e.origin,
              'origin',
              provider(0),
            ),
          ]),
        );
      });
    });

    test('properly overrides ==', () {
      final family = StateNotifierProvider.autoDispose
          .family<Counter, int, int>((ref, _) => Counter());

      expect(family(0), family(0));
      expect(family(1), isNot(family(0)));
      expect(family(1), family(1));
    });
  });
}

class TestNotifier extends StateNotifier<int> {
  TestNotifier([super._state = 0]);

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
