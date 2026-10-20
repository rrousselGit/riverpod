import 'dart:io';

import 'package:test/test.dart';

import 'code_changes.dart';

void main() {
  group('sameCode', () {
    test('is true for identical sources', () {
      _expectSame('int a = 1;', 'int a = 1;');
    });

    test('is true for sources without code', () {
      _expectSame('', '');
      _expectSame('', '// Only a comment');
    });

    test('ignores changes to doc comments', () {
      _expectSame(
        '/// A number.\nint a = 1;',
        '/// The number.\n///\n/// More details.\nint a = 1;',
      );
    });

    test('ignores added and removed comments', () {
      _expectSame('int a = 1;', '/// Doc\nint a = 1; // Trailing');
      _expectSame('// Header\nint a = 1;', 'int a = 1;');
    });

    test('ignores comments at the end of the file', () {
      _expectSame('int a = 1;', 'int a = 1;\n// The end');
    });

    test('ignores block comments, nested ones included', () {
      _expectSame('int a = 1;', '/* a /* nested */ comment */ int a = 1;');
      _expectSame('int a = 1;', 'int a = /**/ 1;');
    });

    test('ignores comments inside string interpolations', () {
      _expectSame(r"var s = '${a}';", r"var s = '${a /* comment */}';");
    });

    test('ignores whitespace and formatting', () {
      _expectSame(
        'void fn() { print(1); }',
        'void fn() {\n  print(\n    1\n  );\n}\n',
      );
    });

    test('detects a changed value', () {
      _expectDifferent('int a = 1;', 'int a = 2;');
    });

    test('detects a renamed identifier', () {
      _expectDifferent('int a = 1;', 'int b = 1;');
    });

    test('detects a changed keyword', () {
      _expectDifferent('final a = 1;', 'const a = 1;');
    });

    test('detects added code', () {
      _expectDifferent('int a = 1;', 'int a = 1;\nint b = 2;');
      _expectDifferent('', 'int a = 1;');
    });

    test('detects removed code', () {
      _expectDifferent('int a = 1;\nint b = 2;', 'int a = 1;');
    });

    test('detects a trailing comma', () {
      _expectDifferent('void fn() { print(1); }', 'void fn() { print(1,); }');
    });

    test('detects code turned into a comment, and back', () {
      _expectDifferent('int a = 1;\nint b = 2;', 'int a = 1;\n// int b = 2;');
      _expectDifferent('// int a = 1;', 'int a = 1;');
    });

    test('treats comment-like text in strings as code', () {
      _expectDifferent("var s = '// a';", "var s = '// b';");
      _expectDifferent("var s = '/* a */';", "var s = '/* b */';");
      _expectDifferent("var s = '''\n// a\n''';", "var s = '''\n// b\n''';");
    });

    test('treats whitespace in strings as code', () {
      _expectDifferent("var s = 'a b';", "var s = 'a  b';");
    });

    test('tolerates syntax errors', () {
      _expectSame('int a = ;', '/// Doc\nint a = ;');
      _expectDifferent('int a = ;', 'int b = ;');
      _expectDifferent('int a = 1;', 'int a = 1');
    });
  });

  group('bin/code_changes.dart', () {
    late Directory temp;
    setUp(() => temp = Directory.systemTemp.createTempSync('code_changes'));
    tearDown(() => temp.deleteSync(recursive: true));

    String file(String name, String content) {
      final path = '${temp.path}/$name';
      File(path).writeAsStringSync(content);
      return path;
    }

    ProcessResult run(List<String> args) {
      const script = 'bin/code_changes.dart';
      return Process.runSync(Platform.resolvedExecutable, [script, ...args]);
    }

    test('prints the new file of each pair whose code changed', () {
      final docsBefore = file('docs_before.dart', '/// A\nint a = 1;');
      final docsAfter = file('docs_after.dart', '/// B\nint a = 1;');
      final codeBefore = file('code_before.dart', 'int a = 1;');
      final codeAfter = file('code_after.dart', 'int a = 2;');

      final result = run([docsBefore, docsAfter, codeBefore, codeAfter]);

      expect(result.stderr, isEmpty);
      expect(result.exitCode, 0);
      expect(result.stdout, '$codeAfter\n');
    });

    test('prints nothing when only comments changed', () {
      final before = file('before.dart', 'int a = 1;');
      final after = file('after.dart', '// Hello\nint a = 1;');

      final result = run([before, after]);

      expect(result.stderr, isEmpty);
      expect(result.exitCode, 0);
      expect(result.stdout, isEmpty);
    });

    test('fails without pairs of files', () {
      expect(run([]).exitCode, 2);
      expect(run([file('alone.dart', '')]).exitCode, 2);
    });
  });
}

void _expectSame(String before, String after) {
  expect(sameCode(before, after), isTrue, reason: '$before\n---\n$after');
}

void _expectDifferent(String before, String after) {
  expect(sameCode(before, after), isFalse, reason: '$before\n---\n$after');
}
