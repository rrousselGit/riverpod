import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  group('_ProxySubscription', () {
    test('handles pause/resume', () {
      final container = ProviderContainer.test();
      final provider = FutureProvider((ref) => 0);

      final element = container.readProviderElement(provider);

      final sub = container.listen(provider.future, (previous, next) {});

      expect(element.isActive, true);

      sub.pause();

      expect(element.isActive, false);

      sub.resume();

      expect(element.isActive, true);
    });

    test('closing a paused subscription unpauses the element', () {
      final container = ProviderContainer.test();
      final provider = FutureProvider((ref) => 0);

      final element = container.readProviderElement(provider);

      final sub = container.listen(provider.future, (previous, next) {});

      expect(element.isActive, true);

      sub.pause();

      expect(element.isActive, false);

      sub.close();
      container.listen(provider.future, (previous, next) {});

      expect(element.isActive, true);
    });
  });
}
