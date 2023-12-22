import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

import 'provider_container_test.dart';

void main() {
  group('AutoDispose', () {
    test('supports disposing of overridden families', () async {
      // Regression test for https://github.com/rrousselGit/riverpod/issues/2480
      final provider = Provider.autoDispose.family<int, int>(
        (ref, _) => -1,
        dependencies: const [],
      );

      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [provider.overrideWith((ref, arg) => 0)],
      );

      container.read(provider(0));

      expect(container.pointerManager.readPointer(provider(0)), isNotNull);
      expect(container.pointerManager.familyPointers[provider], isNotNull);

      await container.pump();

      // The family pointer should still be there, as it comes from an override
      expect(container.pointerManager.familyPointers[provider], isNotNull);
      // The provider should've been disposed.
      expect(container.pointerManager.readPointer(provider(0)), isNull);
    });

    // TODO test recursive dispose does not remove pointers in unrelated containers

    test(
        'When a non-overridden autoDispose provider is disposed '
        'and the associated ProviderContainer has a child ProviderContainer which overrides said provider, '
        'the child container keeps its override', () async {
// Regression test for https://github.com/rrousselGit/riverpod/issues/1519

      final provider = Provider.autoDispose(
        (ref) => 0,
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final child = ProviderContainer.test(
        parent: root,
        overrides: [
          provider.overrideWith((ref) {
            ref.keepAlive();
            return 42;
          })
        ],
      );

      root.read(provider);
      child.read(provider);

      await root.pump();

      expect(
        root.pointerManager.readPointer(provider),
        isNull,
      );

      expect(
        child.pointerManager.readPointer(provider),
        isPointer(override: isNotNull, element: isNotNull),
      );
    });
  });
}
