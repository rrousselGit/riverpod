import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('Provider.autoDispose.family', () {
    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () {
        final provider = Provider.autoDispose.family<int, int>((ref, _) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider(0)), 0);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider(0))
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0);
      final provider = Provider.family.autoDispose<int, int>(
        (ref, i) => ref.watch(dep) + i,
        dependencies: [dep],
      );
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10)), 52);

      expect(root.getAllProviderElements(), isEmpty);
    });

    test('works', () async {
      final onDispose = OnDisposeMock();
      final provider = Provider.autoDispose.family<String, int>((ref, value) {
        ref.onDispose(onDispose);
        return '$value';
      });
      final listener = Listener<String>();
      final container = createContainer();

      final sub =
          container.listen(provider(0), listener, fireImmediately: true);

      verifyOnly(listener, listener('0'));

      sub.close();

      verifyZeroInteractions(onDispose);

      await container.pump();

      verifyOnly(onDispose, onDispose());
    });
  });
}
