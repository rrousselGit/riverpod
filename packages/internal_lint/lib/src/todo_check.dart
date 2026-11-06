import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:meta/meta.dart';

import 'issue_links.dart';
import 'yaml_comments.dart';

// The analyzer's TodoFinder, which is not public, finds the `TODO`s that IDEs
// show. Its rules follow.

// A `TODO` after whitespace, `/` or `*`, and not followed by a letter, a digit
// or `_`.
final _todo = RegExp(r'(?<=[ \t\r\n/*])TODO(?![A-Za-z0-9_])');
final _lineBreak = RegExp('[\r\n]');
// The lines of a block comment that continue a `TODO`: `*` and two spaces.
final _blockContinuation = RegExp(r'[ \t\r\n]*\*  ');
final _nonMarker = RegExp('[^/ ]');

// The same rules, for the `#` comments of YAML files.
final _yamlTodo = RegExp(r'(?<=[ \t#])TODO(?![A-Za-z0-9_])');
final _yamlNonMarker = RegExp('[^# ]');

/// Every `TODO` comment that the analyzer reports, and IDEs show, must link
/// the GitHub issue that requires it, in its text. So must the `TODO`s of the
/// `#` comments of YAML files.
@internal
const todoCheck = LinkedCommentCheck(
  name: 'todos',
  label: 'TODO',
  whenClosed: 'Do the TODO',
  keyword: 'TODO',
  find: _todos,
  findInYaml: _yamlTodos,
);

/// The `TODO`s of [unit], as the analyzer finds them: their text runs to the
/// end of the line, and includes the lines indented to continue it.
Iterable<({int offset, String text})> _todos(CompilationUnit unit) sync* {
  for (final comment in commentsOf(unit)) {
    final lexeme = comment.lexeme;
    final isBlock = lexeme.startsWith('/*');
    var scanFrom = 0;
    for (final match in _todo.allMatches(lexeme)) {
      // Part of the text of the previous `TODO`.
      if (match.start < scanFrom) continue;

      var end = _lineEnd(lexeme, match.end);
      if (isBlock) {
        for (
          var next = _blockContinuation.matchAsPrefix(lexeme, end);
          next != null;
          next = _blockContinuation.matchAsPrefix(lexeme, end)
        ) {
          end = _lineEnd(lexeme, next.end);
        }
      }
      scanFrom = end;
      final text = StringBuffer(lexeme.substring(match.start, end));

      if (!isBlock) {
        // The `//` comments on the next lines, starting in the same column,
        // whose text starts one column after the `TODO`.
        final location = unit.lineInfo.getLocation(comment.offset);
        var line = location.lineNumber;
        for (var next = comment.next; next != null; next = next.next) {
          final nextLocation = unit.lineInfo.getLocation(next.offset);
          final isContinuation =
              next.type == TokenType.SINGLE_LINE_COMMENT &&
              !next.lexeme.startsWith('///') &&
              nextLocation.lineNumber == ++line &&
              nextLocation.columnNumber == location.columnNumber &&
              next.lexeme.indexOf(_nonMarker) == match.start + 1 &&
              !_todo.hasMatch(next.lexeme);
          if (!isContinuation) break;
          text.write(' ${next.lexeme}');
        }
      }

      yield (offset: comment.offset + match.start, text: text.toString());
    }
  }
}

/// The `TODO`s of the YAML [content], with the same rules as [_todos] for
/// `//` comments: their text runs to the end of the line, and includes the
/// `#` comments on the next lines that are indented to continue it.
Iterable<({int offset, String text})> _yamlTodos(String content) sync* {
  final lineInfo = LineInfo.fromContent(content);
  final comments = yamlCommentsOf(content).toList();
  for (var i = 0; i < comments.length; i++) {
    final comment = comments[i];
    // The rest of the line is the text of the first `TODO`.
    final match = _yamlTodo.firstMatch(comment.text);
    if (match == null) continue;
    final text = StringBuffer(comment.text.substring(match.start));

    final location = lineInfo.getLocation(comment.offset);
    var line = location.lineNumber;
    for (final next in comments.skip(i + 1)) {
      final nextLocation = lineInfo.getLocation(next.offset);
      final isContinuation =
          nextLocation.lineNumber == ++line &&
          nextLocation.columnNumber == location.columnNumber &&
          next.text.indexOf(_yamlNonMarker) == match.start + 1 &&
          !_yamlTodo.hasMatch(next.text);
      if (!isContinuation) break;
      text.write(' ${next.text}');
    }

    yield (offset: comment.offset + match.start, text: text.toString());
  }
}

int _lineEnd(String text, int from) {
  final index = text.indexOf(_lineBreak, from);
  return index == -1 ? text.length : index;
}
