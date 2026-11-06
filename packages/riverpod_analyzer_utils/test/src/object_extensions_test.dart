import 'package:riverpod_analyzer_utils/src/object_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('ObjectX', () {
    test('cast returns the value if it has the type, null otherwise', () {
      expect(42.cast<int>(), 42);
      expect(42.cast<num>(), 42);
      expect(42.cast<String>(), isNull);
      expect(null.cast<int>(), isNull);
    });

    test('let calls the callback with non-null values', () {
      expect(21.let((value) => value * 2), 42);
      expect((null as int?).let((value) => value * 2), isNull);
    });

    test('let returns null without a callback', () {
      expect(42.let<int>(null), isNull);
    });
  });
}
