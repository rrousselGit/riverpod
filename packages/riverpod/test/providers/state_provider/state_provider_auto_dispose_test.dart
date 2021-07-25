import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('is compatible with ProviderObserver', () {
    // regression test for https://github.com/rrousselGit/river_pod/issues/623

    final observer = ObserverMock();
    final container = createContainer(observers: [observer]);
    final provider = StateProvider.autoDispose<int>((_) => 0);

    final notifier = container.read(provider);

    clearInteractions(observer);

    notifier.state++;

    verifyOnly(
      observer,
      observer.didUpdateProvider(provider, notifier, notifier, container),
    );
  });

  test('can be refreshed', () async {
    var result = 0;
    final container = createContainer();
    final provider = StateProvider.autoDispose<int>((ref) => result);

    final notifier = container.read(provider.notifier);
    expect(container.read(provider).state, 0);
    expect(notifier.state, 0);

    result = 42;
    expect(container.refresh(provider).state, 42);

    expect(container.read(provider).state, 42);
    expect(container.read(provider.notifier), isNot(notifier));
    expect(container.read(provider.notifier).state, 42);
  });

  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider = StateProvider.autoDispose<int>((ref) => 0);
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
      final provider = StateProvider.autoDispose<int>((ref) => 0);
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
      final provider = StateProvider.autoDispose<int>((ref) => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithProvider(
          StateProvider.autoDispose((ref) => 42),
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

      expect(container.read(provider), override);
      expect(container2.read(provider).state, 42);
    });

    test(
      'properly disposes of the StateController when the provider is disposed',
      () {},
      skip: true,
    );
  });
}
