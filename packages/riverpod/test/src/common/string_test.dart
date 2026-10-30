import 'package:riverpod/src/common/string.dart';
import 'package:test/test.dart';

void main() {
  group('StringX', () {
    test('indent prefixes every line', () {
      expect('a\nb'.indent(1), '  a\n  b');
      expect('a'.indent(2), '    a');
      expect('a\nb'.indent(0), 'a\nb');
      expect('a\n\nb'.indent(1), '  a\n\n  b');
    });

    test('indent skips empty lines', () {
      expect('a\n\nb'.indent(1), '  a\n\n  b');
    });

    test('indent of a single line', () {
      expect('x'.indent(1), '  x');
    });

    test('indentAfterFirstLine leaves the first line as is', () {
      expect('a\nb\nc'.indentAfterFirstLine(1), 'a\n  b\n  c');
      expect('a'.indentAfterFirstLine(1), 'a');
    });
  });
}
