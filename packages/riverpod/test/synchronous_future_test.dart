import 'package:riverpod/src/synchronous_future.dart';
import 'package:test/test.dart';

void main() {
  group('SynchronousFuture', () {
    test('can be awaited synchronously', () {
      var x = 0;

      Future<void> fn() async {
        x = await SynchronousFuture(42);
      }

      fn();

      expect(x, 42);
    });

    test('implements ==', () {
      expect(
        SynchronousFuture(42),
        SynchronousFuture(42),
      );

      expect(
        SynchronousFuture(42),
        isNot(SynchronousFuture(21)),
      );
    });

    test('overrides hashCode', () {
      expect(
        SynchronousFuture(42).hashCode,
        SynchronousFuture(42).hashCode,
      );

      expect(
        SynchronousFuture(42).hashCode,
        isNot(SynchronousFuture(21).hashCode),
      );
    });

    test('overrides toString', () {
      expect(
        SynchronousFuture(42).toString(),
        'SynchronousFuture<int>(42)',
      );
    });
  });
}
