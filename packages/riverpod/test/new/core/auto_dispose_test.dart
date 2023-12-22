import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

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
  });
}
