import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider = FutureProvider.family<int, int>((ref, _) async => 0);
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
  });

  test('FutureProvider.family', () async {
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
