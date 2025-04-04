import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('specifies `from` & `argument` for related providers', () {
    final provider = FutureProvider.autoDispose.family<int, int>((ref, _) => 0);

    expect(provider(0).from, provider);
    expect(provider(0).argument, 0);
  });

  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider =
          FutureProvider.autoDispose.family<int, int>((ref, _) async => 0);
      final root = ProviderContainer.test();
      final container =
          ProviderContainer.test(parent: root, overrides: [provider]);

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
      final provider = FutureProvider.family.autoDispose<int, int>(
        (ref, i) => ref.watch(dep) + i,
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10)), const AsyncData(52));
      expect(container.read(provider(10).future), completion(52));

      expect(root.getAllProviderElements(), isEmpty);
    });

    test('when using provider.overrideWithProvider', () async {
      final provider = FutureProvider.autoDispose.family<int, int>((ref, _) {
        return 0;
      });
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [
          provider.overrideWithProvider(
            (value) => FutureProvider.autoDispose((ref) => 42),
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
    final provider = FutureProvider.autoDispose.family<int, int>((ref, a) {
      return Future.value(a * 2);
    });
    final container = ProviderContainer.test();
    final listener = Listener<AsyncValue<int>>();

    container.listen(provider(21), listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue.loading()));

    await container.pump();

    verifyOnly(
      listener,
      listener(const AsyncValue.loading(), const AsyncValue.data(42)),
    );
  });
}
