import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
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
