import 'package:test/test.dart';

import '../../riverpod.dart';
import '../internals.dart' show ContainerReadElement;

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

  group('ProviderElementProxy', () {
    test('implements ==/hashCode', () {
      final a = FutureProvider((ref) => 0);
      final b = FutureProvider((ref) => 0);

      expect(a.future, a.future);
      expect(a.future, isNot(b.future));

      expect(a.future.hashCode, a.future.hashCode);
      expect(a.future.hashCode, isNot(b.future.hashCode));
    });
  });
}
