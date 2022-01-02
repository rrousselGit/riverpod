import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('can be auto-scoped', () async {
    final dep = Provider((ref) => 0);
    final provider = StateProvider(
      (ref) => ref.watch(dep),
      dependencies: [dep],
    );
    final root = createContainer();
    final container = createContainer(
      parent: root,
      overrides: [dep.overrideWithValue(42)],
    );

    expect(container.read(provider.state).state, 42);
    expect(container.read(provider.notifier).state, 42);

    expect(root.getAllProviderElements(), isEmpty);
  });

  test('is compatible with ProviderObserver', () {
    // regression test for https://github.com/rrousselGit/river_pod/issues/623

    final observer = ObserverMock();
    final container = createContainer(observers: [observer]);
    final provider = StateProvider<int>((ref) => 0);

    final notifier = container.read(provider.state);

    clearInteractions(observer);

    notifier.state++;

    verifyOnly(
      observer,
      observer.didUpdateProvider(provider.state, notifier, notifier, container),
    );
  });

  group('ref.state', () {
    test('can read and change current value', () {
      final container = createContainer();
      final listener = Listener<int>();
      late StateProviderRef<int> ref;
      final provider = StateProvider<int>((r) {
        ref = r;
        return 0;
      });

      container.listen<StateController<int>>(
        provider.state,
        (prev, value) => listener(prev?.state, value.state),
      );
      verifyZeroInteractions(listener);

      expect(ref.controller, container.read(provider.state));

      ref.controller.state = 42;

      verifyOnly(listener, listener(42, 42));

      expect(ref.controller.state, 42);
    });

    test('fails if trying to read the state before it was set', () {
      final container = createContainer();
      Object? err;
      final provider = StateProvider<int>((ref) {
        try {
          ref.controller;
        } catch (e) {
          err = e;
        }
        return 0;
      });

      container.read(provider);
      expect(err, isStateError);
    });

    test('on rebuild, still fails if trying to read the state before was built',
        () {
      final dep = StateProvider((ref) => false);
      final container = createContainer();
      Object? err;
      final provider = StateProvider<int>((ref) {
        if (ref.watch(dep.state).state) {
          try {
            ref.controller;
          } catch (e) {
            err = e;
          }
        }
        return 0;
      });

      container.read(provider);
      expect(err, isNull);

      container.read(dep.state).state = true;
      container.read(provider);

      expect(err, isStateError);
    });
  });

  test('can refresh .notifier', () async {
    var initialValue = 1;
    final provider = StateProvider<int>((ref) => initialValue);
    final container = createContainer();

    expect(container.read(provider), 1);
    expect(container.read(provider.notifier).debugState, 1);

    initialValue = 42;

    expect(container.refresh(provider.notifier).debugState, 42);
    expect(container.read(provider), 42);
  });

  test('can refresh .state', () async {
    // TODO fix this test
    var initialValue = 1;
    final provider = StateProvider<int>((ref) => initialValue);
    final container = createContainer();

    expect(container.read(provider), 1);
    expect(container.read(provider.state).debugState, 1);

    initialValue = 42;

    expect(container.refresh(provider.state).debugState, 42);
    expect(container.read(provider), 42);
  }, skip: true);

  test('can be refreshed', () async {
    var result = 0;
    final container = createContainer();
    final provider = StateProvider<int>((ref) => result);

    final notifier = container.read(provider.notifier);
    expect(container.read(provider.state).state, 0);
    expect(notifier.state, 0);

    result = 42;
    expect(container.refresh(provider), 42);

    expect(container.read(provider.state).state, 42);
    expect(container.read(provider.notifier), isNot(notifier));
    expect(container.read(provider.notifier).state, 42);
  });

  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider = StateProvider<int>((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider]);

      expect(container.read(provider.notifier).state, 0);
      expect(container.read(provider.state).state, 0);
      expect(root.getAllProviderElements(), isEmpty);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.state),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.notifier),
        ]),
      );
    });

    test('when using provider.overrideWithValue', () async {
      final provider = StateProvider<int>((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithValue(StateController(42)),
      ]);

      expect(container.read(provider.notifier).state, 42);
      expect(container.read(provider.state).state, 42);
      expect(root.getAllProviderElements(), isEmpty);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.state),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.notifier),
        ]),
      );
    });

    test('when using provider.overrideWithProvider', () async {
      final provider = StateProvider<int>((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithProvider(
          StateProvider((ref) => 42),
        ),
      ]);

      expect(container.read(provider.notifier).state, 42);
      expect(container.read(provider.state).state, 42);
      expect(root.getAllProviderElements(), isEmpty);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.state),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.notifier),
        ]),
      );
    });
  });

  test(
    'overrideWithValue listens to the new StateController and support controller changes',
    () {
      final provider = StateProvider((ref) => 0);
      final container = createContainer(overrides: [
        provider.overrideWithValue(StateController(42)),
      ]);
      final listener = Listener<int>();

      container.listen<StateController<int>>(
        provider.state,
        (prev, controller) => listener(prev?.state, controller.state),
        fireImmediately: true,
      );

      verifyOnly(listener, listener(null, 42));

      container.read(provider.state).state++;

      verifyOnly(listener, listener(43, 43));
    },
  );

  group('overrideWithProvider', () {
    test('listens to state changes', () {
      final override = StateController(21);
      final provider = StateProvider((ref) => 0);
      final container = createContainer(overrides: [
        provider.overrideWithValue(override),
      ]);
      addTearDown(container.dispose);
      final container2 = ProviderContainer(overrides: [
        provider.overrideWithProvider(
          StateProvider((ref) => 42),
        ),
      ]);
      addTearDown(container.dispose);

      expect(container.read(provider.notifier), override);
      expect(container.read(provider), 21);
      expect(container2.read(provider.state).state, 42);
    });

    test(
      'properly disposes of the StateController when the provider is disposed',
      () async {
        final container = createContainer();
        final provider = StateProvider.autoDispose((ref) => 0);

        final notifier = container.read(provider.notifier);
        final sub = container.listen(provider, (pref, value) {});

        expect(notifier.hasListeners, true);

        sub.close();
        await container.pump();

        expect(() => notifier.hasListeners, throwsStateError);
      },
    );
  });

  test('Expose a state and allows modifying it', () {
    final container = createContainer();
    final provider = StateProvider((ref) => 0);
    final listener = Listener<StateController<int>>();

    final controller = container.read(provider.state);
    expect(controller.state, 0);

    container.listen(provider.state, listener, fireImmediately: true);
    verifyOnly(listener, listener(null, controller));

    controller.state = 42;

    verifyOnly(listener, listener(controller, controller));
  });

  test('disposes the controller when the container is disposed', () {
    final container = createContainer();
    final provider = StateProvider((ref) => 0);

    final controller = container.read(provider.state);

    expect(controller.mounted, true);

    container.dispose();

    expect(controller.mounted, false);
  });

  test('disposes the controller when the provider is re-evaluated', () {
    final container = createContainer();
    final other = StateProvider((ref) => 0);
    final provider = StateProvider((ref) => ref.watch(other.state).state * 2);

    final otherController = container.read(other.state);
    final firstController = container.read(provider.state);

    final sub = container.listen(provider.state, (_, __) {});

    expect(sub.read(), firstController);
    expect(firstController.mounted, true);

    otherController.state++;

    final secondController = sub.read();
    expect(secondController, isNot(firstController));
    expect(secondController.mounted, true);
    expect(secondController.state, 2);
    expect(firstController.mounted, false);
  });

  group('StateProvider', () {
    test('.notifier obtains the controller without listening to it', () async {
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = StateProvider((ref) {
        ref.watch(dep);
        return 0;
      });

      var callCount = 0;
      final sub = container.listen(
        provider.notifier,
        (_, __) => callCount++,
      );

      final controller = container.read(provider.state);

      expect(sub.read(), controller);
      expect(callCount, 0);

      controller.state++;

      await container.pump();
      expect(callCount, 0);

      container.read(dep.state).state++;

      final controller2 = container.read(provider.state);
      expect(controller2, isNot(controller));

      await container.pump();
      expect(sub.read(), controller2);
      expect(callCount, 1);
    });
  });

  group('StateProvider.autoDispose', () {
    test('.notifier obtains the controller without listening to it', () async {
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = StateProvider.autoDispose((ref) {
        ref.watch(dep);
        return 0;
      });

      var callCount = 0;
      final sub = container.listen(
        provider.notifier,
        (_, __) => callCount++,
      );

      final controller = container.read(provider.state);

      expect(sub.read(), controller);
      expect(callCount, 0);

      controller.state++;

      await container.pump();
      expect(callCount, 0);

      container.read(dep.state).state++;

      final controller2 = container.read(provider.state);
      expect(controller2, isNot(controller));

      await container.pump();
      expect(sub.read(), controller2);
      expect(callCount, 1);
    });

    test('creates a new controller when no-longer listened', () async {
      final container = createContainer();
      final provider = StateProvider.autoDispose((ref) => 0);

      final sub = container.listen(provider.state, (_, __) {});
      final first = sub.read();

      first.state++;
      expect(first.state, 1);
      expect(first.mounted, true);

      sub.close();
      await container.pump();

      final second = container.read(provider.state);

      expect(first.mounted, false);
      expect(second, isNot(first));
      expect(second.state, 0);
      expect(second.mounted, true);
    });
  });

  group('StateProvider.family.autoDispose', () {
    test('creates a new controller when no-longer listened', () async {
      final container = createContainer();

      StateProvider.family.autoDispose<int, String>((ref, id) {
        return 42;
      });

      final provider =
          StateProvider.autoDispose.family<int, int>((ref, id) => id);

      final sub = container.listen(provider(0).state, (_, __) {});
      final sub2 = container.listen(provider(42).state, (_, __) {});
      final first = sub.read();

      first.state++;
      expect(sub2.read().state, 42);
      expect(first.state, 1);
      expect(first.mounted, true);

      sub.close();
      await container.pump();

      final second = container.read(provider(0).state);

      expect(first.mounted, false);
      expect(second, isNot(first));
      expect(second.state, 0);
      expect(second.mounted, true);
    });
  });
}
