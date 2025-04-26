import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show NodeInternal;
import 'package:test/test.dart';

void main() {
  group('_ProviderSelector', () {
    test('handles pause/resume', () {
      final container = ProviderContainer.test();
      final provider = Provider((ref) => 0);

      final element = container.readProviderElement(provider);

      final sub = container.listen(
        provider.select((value) => null),
        (previous, next) {},
      );

      expect(element.isActive, true);

      sub.pause();

      expect(element.isActive, false);

      sub.resume();

      expect(element.isActive, true);
    });
  });
}
