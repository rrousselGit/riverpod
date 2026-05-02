import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/object.dart';

void main() {
  group('Let', () {
    test('let transforms non-null values', () {
      expect(21.let((value) => value * 2), 42);
    });

    test('let returns null for null values', () {
      int? value;

      expect(value.let((it) => it * 2), isNull);
    });

    test('bind creates a callback for non-null values', () {
      final callback = 'riverpod'.bind((value) => value.toUpperCase());

      expect(callback, isNotNull);
      expect(callback!(), 'RIVERPOD');
    });

    test('bind returns null for null values', () {
      String? value;

      expect(value.bind((it) => it.toUpperCase()), isNull);
    });
  });
}
