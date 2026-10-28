import 'package:riverpod_analyzer_utils/src/string_utils.dart';
import 'package:test/test.dart';

void main() {
  group('CaseChangeExtension', () {
    test('encoded escapes dollar signs', () {
      expect(r'a$b$c'.encoded, r'a\$b\$c');
      expect('abc'.encoded, 'abc');
    });

    test('titled uppercases the first letter', () {
      expect('foo'.titled, 'Foo');
      expect(r'_$foo'.titled, r'_$Foo');
      expect('Foo'.titled, 'Foo');
      expect('_1'.titled, '_1');
    });

    test('lowerFirst lowercases the first letter', () {
      expect('Foo'.lowerFirst, 'foo');
      expect('_FOO'.lowerFirst, '_fOO');
      expect('foo'.lowerFirst, 'foo');
    });

    test('public removes one leading underscore', () {
      expect('_foo'.public, 'foo');
      expect('__foo'.public, '_foo');
      expect('foo'.public, 'foo');
    });
  });
}
