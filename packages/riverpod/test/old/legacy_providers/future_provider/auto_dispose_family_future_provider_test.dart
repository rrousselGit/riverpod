import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

import '../../../new/core/provider_container_test.dart';
import '../../utils.dart';

void main() {
  test('specifies `from` & `argument` for related providers', () {
    final provider = FutureProvider.autoDispose.family<int, int>((ref, _) => 0);

    expect(provider(0).from, provider);
    expect(provider(0).argument, 0);
  });

  group('scoping an override overrides all the associated sub-providers', () {
    test('when passing the provider itself', () async {
      final provider = FutureProvider.autoDispose.family<int, int>(
        (ref, _) async => 0,
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [provider],
      );

      container.listen(provider(0), (_, __) {});

      expect(
        container.pointerManager.familyPointers[provider],
        isProviderDirectory(
          pointers: {provider(0): isPointer(element: isNotNull)},
        ),
      );

      expect(
        root.pointerManager.orphanPointers.pointers,
        isEmpty,
      );
      expect(
        root.pointerManager.familyPointers,
        isEmpty,
      );
    });

    test('can be auto-scoped', () async {
      final dep = Provider(
        (ref) => 0,
        dependencies: const [],
      );
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

    test('when using provider.overrideWith', () async {
      final provider = FutureProvider.autoDispose.family<int, int>(
        (ref, _) => 0,
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [
          provider.overrideWith((ref, value) => 42),
        ],
      );

      expect(await container.read(provider(0).future), 42);
      expect(container.read(provider(0)), const AsyncData(42));
      expect(root.getAllProviderElementsInOrder(), isEmpty);
      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElement>().having((e) => e.origin, 'origin', provider(0)),
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
