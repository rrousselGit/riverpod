import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('specifies `from` & `argument` for related providers', () {
    final provider = FutureProvider.family<int, int>((ref, _) => 0);

    expect(provider(0).from, provider);
    expect(provider(0).argument, 0);
  });

  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider = FutureProvider.family<int, int>((ref, _) async => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider]);

      expect(await container.read(provider(0).future), 0);
      expect(container.read(provider(0)), const AsyncData(0));
      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElementBase<Object?>>()
            .having((e) => e.origin, 'origin', provider(0)),
      ]);
      expect(root.getAllProviderElementsInOrder(), isEmpty);
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0);
      final provider = FutureProvider.family<int, int>(
        (ref, i) => ref.watch(dep) + i,
        dependencies: [dep],
      );
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10)), const AsyncData(52));
      expect(container.read(provider(10).future), completion(52));

      expect(root.getAllProviderElements(), isEmpty);
    });

    test('when using provider.overrideWithProvider', () async {
      final provider = FutureProvider.family<int, int>((ref, _) async => 0);
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [
          provider.overrideWithProvider(
            (value) => FutureProvider((ref) async => 42),
          ),
        ],
      );

      expect(await container.read(provider(0).future), 42);
      expect(container.read(provider(0)), const AsyncData(42));
      expect(root.getAllProviderElementsInOrder(), isEmpty);
      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElementBase<Object?>>()
            .having((e) => e.origin, 'origin', provider(0)),
      ]);
    });
  });

  test('works', () async {
    final provider = FutureProvider.family<String, int>((ref, a) {
      return Future.value('$a');
    });
    final container = createContainer();

    expect(container.read(provider(0)), const AsyncValue<String>.loading());

    await container.pump();

    expect(
      container.read(provider(0)),
      const AsyncValue<String>.data('0'),
    );
  });
}
