import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('can be auto-scoped', () async {
    final dep = Provider((ref) => 0);
    final provider = StateProvider.autoDispose(
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

  group('ref.state', () {
    test('can read and change current value', () {
      final container = createContainer();
      final listener = Listener<int>();
      late StateProviderRef<int> ref;
      final provider = StateProvider.autoDispose<int>((r) {
        ref = r;
        return 0;
      });

      container.listen<StateController<int>>(
        provider.state,
        (prev, value) => listener(prev?.state, value.state),
      );
      verifyZeroInteractions(listener);

      expect(ref.controller, container.read(provider.notifier));

      ref.controller.state = 42;

      verifyOnly(listener, listener(42, 42));

      expect(ref.controller.state, 42);
    });

    test('fails if trying to read the state before it was set', () {
      final container = createContainer();
      Object? err;
      final provider = StateProvider.autoDispose<int>((ref) {
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
      final provider = StateProvider.autoDispose<int>((ref) {
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

  test('is compatible with ProviderObserver', () {
    // regression test for https://github.com/rrousselGit/river_pod/issues/623

    final observer = ObserverMock();
    final container = createContainer(observers: [observer]);
    final provider = StateProvider.autoDispose<int>((_) => 0);

    final notifier = container.read(provider.state);

    clearInteractions(observer);

    notifier.state++;

    verifyOnly(
      observer,
      observer.didUpdateProvider(provider.state, notifier, notifier, container),
    );
  });

  test('can refresh .notifier', () async {
    var initialValue = 1;
    final provider = StateProvider.autoDispose<int>((ref) => initialValue);
    final container = createContainer();

    container.listen(provider.notifier, (prev, value) {});

    expect(container.read(provider), 1);
    expect(container.read(provider.notifier).debugState, 1);

    initialValue = 42;

    expect(container.refresh(provider.notifier).debugState, 42);
    expect(container.read(provider), 42);
  });

  test('can refresh .state', () async {
    // TODO fix this test
    var initialValue = 1;
    final provider = StateProvider.autoDispose<int>((ref) => initialValue);
    final container = createContainer();

    container.listen(provider.state, (prev, value) {});

    expect(container.read(provider), 1);
    expect(container.read(provider.state).debugState, 1);

    initialValue = 42;

    expect(container.refresh(provider.state).debugState, 42);
    expect(container.read(provider), 42);
  }, skip: true);

  test('can be refreshed', () async {
    var result = 0;
    final container = createContainer();
    final provider = StateProvider.autoDispose<int>((ref) => result);

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
      final provider = StateProvider.autoDispose<int>((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider]);

      expect(container.read(provider.notifier).state, 0);
      expect(container.read(provider.state).state, 0);
      expect(container.read(provider), 0);
      expect(root.getAllProviderElements(), isEmpty);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.state),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.notifier),
        ]),
      );
    });

    test('when using provider.overrideWithValue', () async {
      final provider = StateProvider.autoDispose<int>((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithValue(StateController(42)),
      ]);

      expect(container.read(provider.notifier).state, 42);
      expect(container.read(provider.state).state, 42);
      expect(container.read(provider), 42);
      expect(root.getAllProviderElements(), isEmpty);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.state),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.notifier),
        ]),
      );
    });

    test('when using provider.overrideWithProvider', () async {
      final provider = StateProvider.autoDispose<int>((ref) => 0, name: 'true');
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithProvider(
          StateProvider.autoDispose((ref) => 42, name: 'meh'),
        ),
      ]);

      expect(container.read(provider.notifier).state, 42);
      expect(container.read(provider.state).state, 42);
      expect(container.read(provider), 42);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.state),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.notifier),
        ]),
      );
      expect(root.getAllProviderElements(), isEmpty);
    });
  });

  group('overrideWithProvider', () {
    test('listens to state changes', () {
      final override = StateController(42);
      final provider = StateProvider.autoDispose((ref) => 0);
      final container = createContainer(overrides: [
        provider.overrideWithValue(override),
      ]);
      addTearDown(container.dispose);
      final container2 = ProviderContainer(overrides: [
        provider.overrideWithProvider(
          StateProvider.autoDispose((ref) => 42),
        ),
      ]);
      addTearDown(container.dispose);

      expect(container.read(provider), 42);
      expect(container.read(provider.notifier), override);
      expect(container2.read(provider.state).state, 42);
    });

    test(
      'properly disposes of the StateController when the provider is disposed',
      () async {
        final container = createContainer();
        final provider = StateProvider.autoDispose((ref) => 0);

        final notifier = container.read(provider.notifier);
        final sub = container.listen(provider, (prev, value) {});

        expect(notifier.hasListeners, true);

        sub.close();
        await container.pump();

        expect(() => notifier.hasListeners, throwsStateError);
      },
    );
  });
}
