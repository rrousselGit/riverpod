import 'package:riverpod/src/common/string.dart';
import 'package:test/test.dart';

void main() {
  group('StringX', () {
    test('indent prefixes every line', () {
      expect('a\nb'.indent(1), '  a\n  b');
      expect('a'.indent(2), '    a');
      expect('a\nb'.indent(0), 'a\nb');
    });

    test('indentAfterFirstLine leaves the first line as is', () {
      expect('a\nb\nc'.indentAfterFirstLine(1), 'a\n  b\n  c');
      expect('a'.indentAfterFirstLine(1), 'a');
    });
  });
}
