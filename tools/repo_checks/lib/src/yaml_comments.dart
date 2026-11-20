import 'package:meta/meta.dart';

final _whitespace = RegExp(r'\s');
// The last characters before a quote that starts a quoted scalar, where null
// is the start of the line. Elsewhere, such as in `key: it's`, a quote is
// part of a plain scalar.
const _beforeQuotedScalar = {null, ':', '-', '?', '[', '{', ','};
// The header of a block scalar, `|` or `>` and their indicators, after a key,
// a `-`, a tag, an anchor or nothing.
final _blockScalarHeader = RegExp(
  r'(?:^|[:?-]\s|[!&]\S*\s)\s*[|>][1-9+-]*\s*$',
);

/// The `#` comments of the YAML [content], with their offset in it. Their
/// text runs to the end of the line.
///
/// Like YAML, only a `#` at the start of a line or after whitespace starts a
/// comment, and not in a quoted or block scalar, so that `a#b`, `'# a'` and
/// the lines of a `key: |` are not mistaken for one.
@internal
Iterable<({int offset, String text})> yamlCommentsOf(String content) sync* {
  // The quote of the quoted scalar that the current line is in, if any.
  String? quote;
  // The indentation of the line that starts the current block scalar, whose
  // lines are indented more, if any.
  int? blockIndent;
  var lineOffset = 0;
  for (final rawLine in content.split('\n')) {
    final offset = lineOffset;
    lineOffset += rawLine.length + 1;
    final line = rawLine.endsWith('\r')
        ? rawLine.substring(0, rawLine.length - 1)
        : rawLine;

    final indent = line.length - line.trimLeft().length;
    if (blockIndent != null) {
      if (line.trim().isEmpty || indent > blockIndent) continue;
      blockIndent = null;
    }

    int? commentStart;
    String? previous;
    for (var i = 0; i < line.length && commentStart == null; i++) {
      final char = line[i];
      if (quote != null) {
        if (quote == '"' && char == r'\') {
          // Escapes the next character.
          i++;
        } else if (quote == "'" && line.startsWith("''", i)) {
          // An escaped `'`.
          i++;
        } else if (char == quote) {
          quote = null;
          previous = char;
        }
      } else if (char == '#' && (i == 0 || _whitespace.hasMatch(line[i - 1]))) {
        commentStart = i;
      } else if ((char == "'" || char == '"') &&
          _beforeQuotedScalar.contains(previous)) {
        quote = char;
      } else if (!_whitespace.hasMatch(char)) {
        previous = char;
      }
    }

    if (commentStart != null) {
      yield (offset: offset + commentStart, text: line.substring(commentStart));
    }
    if (quote == null &&
        _blockScalarHeader.hasMatch(line.substring(0, commentStart))) {
      blockIndent = indent;
    }
  }
}
