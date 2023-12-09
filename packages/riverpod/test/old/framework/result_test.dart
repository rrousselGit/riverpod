import 'package:riverpod/src/result.dart';
import 'package:test/test.dart';

void main() {
  group('Result.data', () {
    test('implements hashCode/==', () {
      expect(Result.data(42), Result.data(42));
      expect(Result.data(42), isNot(Result.data(21)));

      expect(Result.data(42).hashCode, Result.data(42).hashCode);
      expect(Result.data(42).hashCode, isNot(Result.data(21).hashCode));
    });
  });

  group('Result.error', () {
    test('implements hashCode/==', () {
      expect(
        Result<int>.error(42, StackTrace.empty),
        Result<int>.error(42, StackTrace.empty),
      );
      expect(
        Result<int>.error(42, StackTrace.empty),
        isNot(Result<int>.error(21, StackTrace.empty)),
      );

      expect(
        Result<int>.error(42, StackTrace.empty).hashCode,
        Result<int>.error(42, StackTrace.empty).hashCode,
      );
      expect(
        Result<int>.error(42, StackTrace.empty).hashCode,
        isNot(Result<int>.error(21, StackTrace.empty).hashCode),
      );
    });
  });
}
