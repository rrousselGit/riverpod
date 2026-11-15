import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  group('ProviderScheduler', () {
    test('does not dispose the new element of a provider when its previous '
        'element was scheduled twice (#4806)', () async {
      final container = ProviderContainer.test();
      final provider = Provider.autoDispose((ref) => 0);
      ProviderSubscription<int>? sub;
      final other = Provider.autoDispose((ref) {
        ref.onDispose(() => sub = container.listen(provider, (_, _) {}));
        return 0;
      });

      // Dispose queue: [provider, other, provider]
      container.read(provider);
      container.read(other);
      container.read(provider);
      await container.pump();

      expect(sub!.closed, false);
      expect(sub!.read(), 0);
    });
  });
}
