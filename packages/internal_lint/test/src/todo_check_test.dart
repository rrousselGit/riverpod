import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:internal_lint/src/todo_check.dart';
import 'package:test/test.dart';

/// The lines and texts of the TODOs of [content].
List<(int, String)> _todos(String content) {
  final unit = parseString(content: content, throwIfDiagnostics: false).unit;
  return [
    for (final (:offset, :text) in todoCheck.find(unit))
      (unit.lineInfo.getLocation(offset).lineNumber, text),
  ];
}

void main() {
  test('finds the TODOs the analyzer reports', () {
    expect(
      _todos('''
// TODO(name): a
//TODO b
/// TODO c, in a doc comment
final a = 'TODO'; // A TODO in a trailing comment
/* TODO d */ /** TODO e */
// TODO f TODO, once per line
'''),
      [
        (1, 'TODO(name): a'),
        (2, 'TODO b'),
        (3, 'TODO c, in a doc comment'),
        (4, 'TODO in a trailing comment'),
        (5, 'TODO d */'),
        (5, 'TODO e */'),
        (6, 'TODO f TODO, once per line'),
      ],
    );
  });

  test('skips what the analyzer does not report', () {
    expect(
      _todos('''
final a = '// TODO a';
// Quoted `TODO`, (TODO), TODOS, TODO_X, xTODO, todo and FIXME
'''),
      isEmpty,
    );
  });

  test('includes the lines that continue a TODO', () {
    expect(
      _todos('''
/* TODO: a block comment,
 *  continued
 * not continued
 */
// TODO: also a TODO,
//  continued
//   not continued
/// TODO: doc comments
///  are not continued
var a; // TODO: nor are comments
var b; //  in another column
// TODO: nor TODOs
//  TODO on the next line
'''),
      [
        (1, 'TODO: a block comment,\n *  continued'),
        (5, 'TODO: also a TODO, //  continued'),
        (8, 'TODO: doc comments'),
        (10, 'TODO: nor are comments'),
        (12, 'TODO: nor TODOs'),
        (13, 'TODO on the next line'),
      ],
    );
  });
}
