import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ProviderElement;
import 'package:test/test.dart';

void main() {
  test('supports .name', () {
    expect(
      StateProvider.autoDispose((ref) => 0).name,
      null,
    );
    expect(
      StateProvider.autoDispose((ref) => 0, name: 'foo').name,
      'foo',
    );
  });

  test('can be auto-scoped', () async {
    final dep = Provider(
      (ref) => 0,
      dependencies: const [],
    );
    final provider = StateProvider.autoDispose(
      (ref) => ref.watch(dep),
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
    final provider = StateProvider.autoDispose<int>((ref) => initialValue);
    final container = ProviderContainer.test();

    container.listen(provider.notifier, (prev, value) {});

    expect(container.read(provider), 1);
    expect(container.read(provider.notifier).state, 1);

    initialValue = 42;

    expect(container.refresh(provider.notifier).state, 42);
    expect(container.read(provider), 42);
  });

  test('can be refreshed', () async {
    var result = 0;
    final container = ProviderContainer.test();
    final provider = StateProvider.autoDispose<int>((ref) => result);

    final notifier = container.read(provider.notifier);
    expect(container.read(provider), 0);
    expect(notifier.state, 0);

    result = 42;
    expect(container.refresh(provider), 42);

    expect(container.read(provider), 42);
    expect(container.read(provider.notifier), isNot(notifier));
    expect(container.read(provider.notifier).state, 42);
  });

  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider = StateProvider.autoDispose<int>(
        (ref) => 0,
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [provider],
      );

      expect(container.read(provider.notifier).state, 0);
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
      final provider = StateProvider.autoDispose<int>(
        (ref) => 0,
        name: 'true',
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [
          provider.overrideWith((ref) => 42),
        ],
      );

      expect(container.read(provider.notifier).state, 42);
      expect(container.read(provider), 42);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
        ]),
      );
      expect(root.getAllProviderElements(), isEmpty);
    });
  });

  group('overrideWith', () {
    test(
      'properly disposes of the StateController when the provider is disposed',
      () async {
        final container = ProviderContainer.test();
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
