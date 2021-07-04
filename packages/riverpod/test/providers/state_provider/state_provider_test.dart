import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('can be refreshed', () {}, skip: true);

  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider = StateProvider<int>((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider]);

      expect(container.read(provider.notifier).state, 0);
      expect(container.read(provider).state, 0);
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
      final provider = StateProvider<int>((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithValue(StateController(42)),
      ]);

      expect(container.read(provider.notifier).state, 42);
      expect(container.read(provider).state, 42);
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
      final provider = StateProvider<int>((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithProvider(
          StateProvider((ref) => 42),
        ),
      ]);

      expect(container.read(provider.notifier).state, 42);
      expect(container.read(provider).state, 42);
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

  test(
    'overrideWithValue listens to the new StateController and support controller changes',
    () {
      final provider = StateProvider((ref) => 0);
      final container = createContainer(overrides: [
        provider.overrideWithValue(StateController(42)),
      ]);
      final listener = Listener<int>();

      container.listen<StateController<int>>(
        provider,
        (controller) => listener(controller.state),
        fireImmediately: true,
      );

      verifyOnly(listener, listener(42));

      container.read(provider).state++;

      verifyOnly(listener, listener(43));
    },
  );

  group('overrideWithProvider', () {
    test('listens to state changes', () {
      final override = StateController(42);
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

      expect(container.read(provider), override);
      expect(container2.read(provider).state, 42);
    });

    test(
      'properly disposes of the StateController when the provider is disposed',
      () {},
      skip: true,
    );
  });

  test('StateProvideyFamily', () async {
    final provider = StateProvider.family<String, int>((ref, a) {
      return '$a';
    });
    final container = createContainer();

    expect(
      container.read(provider(0)),
      isA<StateController>().having((s) => s.state, 'state', '0'),
    );
    expect(
      container.read(provider(1)),
      isA<StateController>().having((s) => s.state, 'state', '1'),
    );
  });

  test('StateProvideyFamily override', () async {
    final provider = StateProvider.family<String, int>((ref, a) {
      return '$a';
    });
    final container = createContainer(overrides: [
      provider.overrideWithProvider((a) {
        return StateProvider((ref) => 'override $a');
      }),
    ]);

    expect(
      container.read(provider(0)),
      isA<StateController>().having((s) => s.state, 'state', 'override 0'),
    );
    expect(
      container.read(provider(1)),
      isA<StateController>().having((s) => s.state, 'state', 'override 1'),
    );
  });

  test('Expose a state and allows modifying it', () {
    final container = createContainer();
    final provider = StateProvider((ref) => 0);
    final listener = Listener<StateController<int>>();

    final controller = container.read(provider);
    expect(controller.state, 0);

    container.listen(provider, listener, fireImmediately: true);
    verifyOnly(listener, listener(controller));

    controller.state = 42;

    verifyOnly(listener, listener(controller));
  });

  test('disposes the controller when the container is disposed', () {
    final container = createContainer();
    final provider = StateProvider((ref) => 0);

    final controller = container.read(provider);

    expect(controller.mounted, true);

    container.dispose();

    expect(controller.mounted, false);
  });

  test('disposes the controller when the provider is re-evaluated', () {
    final container = createContainer();
    final other = StateProvider((ref) => 0);
    final provider = StateProvider((ref) => ref.watch(other).state * 2);

    final otherController = container.read(other);
    final firstController = container.read(provider);

    final sub = container.listen(provider, (_) {});

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
        (_) => callCount++,
      );

      final controller = container.read(provider);

      expect(sub.read(), controller);
      expect(callCount, 0);

      controller.state++;

      await container.pump();
      expect(callCount, 0);

      container.read(dep).state++;

      final controller2 = container.read(provider);
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
        (_) => callCount++,
      );

      final controller = container.read(provider);

      expect(sub.read(), controller);
      expect(callCount, 0);

      controller.state++;

      await container.pump();
      expect(callCount, 0);

      container.read(dep).state++;

      final controller2 = container.read(provider);
      expect(controller2, isNot(controller));

      await container.pump();
      expect(sub.read(), controller2);
      expect(callCount, 1);
    });

    test('creates a new controller when no-longer listened', () async {
      final container = createContainer();
      final provider = StateProvider.autoDispose((ref) => 0);

      final sub = container.listen(provider, (_) {});
      final first = sub.read();

      first.state++;
      expect(first.state, 1);
      expect(first.mounted, true);

      sub.close();
      await container.pump();

      final second = container.read(provider);

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

      final sub = container.listen(provider(0), (_) {});
      final sub2 = container.listen(provider(42), (_) {});
      final first = sub.read();

      first.state++;
      expect(sub2.read().state, 42);
      expect(first.state, 1);
      expect(first.mounted, true);

      sub.close();
      await container.pump();

      final second = container.read(provider(0));

      expect(first.mounted, false);
      expect(second, isNot(first));
      expect(second.state, 0);
      expect(second.mounted, true);
    });
  });
}
