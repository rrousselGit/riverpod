import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider =
          FutureProvider.autoDispose.family<int, int>((ref, _) async => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider]);

      expect(await container.read(provider(0).future), 0);
      expect(container.read(provider(0)), const AsyncData(0));
      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElementBase>()
            .having((e) => e.origin, 'origin', provider(0)),
        isA<ProviderElementBase>()
            .having((e) => e.origin, 'origin', provider(0).future),
      ]);
      expect(root.getAllProviderElementsInOrder(), isEmpty);
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0);
      final provider = FutureProvider.family.autoDispose<int, int>(
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

    test('worls', () async {
      final provider = FutureProvider.autoDispose.family<int, int>((ref, a) {
        return Future.value(a * 2);
      });
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider(21), listener, fireImmediately: true);

      verifyOnly(listener, listener(const AsyncValue.loading()));

      await container.pump();

      verifyOnly(listener, listener(const AsyncValue.data(42)));
    });
  });
}
