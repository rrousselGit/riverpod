import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:internal_lint/src/ignore_check.dart';
import 'package:test/test.dart';

/// The lines and texts of the ignore comments of [content].
List<(int, String)> _ignores(String content) {
  final unit = parseString(content: content, throwIfDiagnostics: false).unit;
  return [
    for (final (:offset, :text) in ignoreCheck.find(unit))
      (unit.lineInfo.getLocation(offset).lineNumber, text),
  ];
}

void main() {
  test('finds ignore and ignore_for_file comments', () {
    expect(
      _ignores('''
// ignore_for_file: a
final a = 1; // ignore: b, https://github.com/owner/repo/issues/1
//ignore : c
'''),
      [
        (1, '// ignore_for_file: a'),
        (2, '// ignore: b, https://github.com/owner/repo/issues/1'),
        (3, '//ignore : c'),
      ],
    );
  });

  test('reads comments anywhere, even in invalid code', () {
    expect(
      _ignores(r'''
void main() {
  print('${a // ignore: a
  }');
  final x = ; // ignore: b
}'''),
      [(2, '// ignore: a'), (4, '// ignore: b')],
    );
  });

  test('skips what the analyzer does not read as an ignore', () {
    expect(
      _ignores('''
final a = '// ignore: a';
final b = \'\'\'
// ignore: b
\'\'\';
/// ignore: c
/* ignore: d */
// See ignore: e
//   // ignore: f
'''),
      isEmpty,
    );
  });
}
