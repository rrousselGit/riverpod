import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:meta/meta.dart';

/// Renders the [code] of a snippet as a Dart library that the analyzer
/// accepts whenever the snippet is valid.
///
/// The snippets of docs are rarely whole libraries, so the code is completed
/// as the Flutter SDK does for its own:
///
/// - It follows the [imports] and the [assumptions] of its file, which is
///   Dart code too. The directives of the three are hoisted to the top.
/// - Declarations are kept as is. Code that is not made of declarations is
///   the body of a `snippet` function when it is made of statements, and what
///   that function returns when it is an expression. The function is `async`,
///   so that the snippet can `await`.
///
/// [source] is where the snippet is from, for the header.
@internal
String renderSnippet({
  required String source,
  required String code,
  String assumptions = '',
  List<String> imports = const [],
}) {
  final (assumedDirectives, assumedCode) = _splitDirectives(assumptions);
  final (directives, body) = _splitDirectives(code);

  final buffer = StringBuffer()
    ..writeln('// GENERATED from $source by scripts/snippets.sh.')
    ..writeln('// Do not modify by hand: edit the snippet instead.')
    ..writeln();

  final allDirectives = [
    for (final import in imports) "import '$import';",
    if (assumedDirectives.isNotEmpty) assumedDirectives,
    if (directives.isNotEmpty) directives,
  ];
  if (allDirectives.isNotEmpty) {
    buffer
      ..writeAll(allDirectives, '\n')
      ..writeln()
      ..writeln();
  }
  if (assumedCode.isNotEmpty) {
    buffer
      ..writeln(assumedCode)
      ..writeln();
  }
  buffer.writeln(_complete(body));
  return buffer.toString();
}

/// Splits [code] into its directives, which are its lines up to the end of
/// the last one, and the rest.
(String, String) _splitDirectives(String code) {
  final result = parseString(content: code, throwIfDiagnostics: false);
  final directives = result.unit.directives;
  if (directives.isEmpty) return ('', code.trim());

  final lastLine = result.lineInfo.getLocation(directives.last.end).lineNumber;
  final lines = code.split('\n');
  return (
    lines.take(lastLine).join('\n').trim(),
    lines.skip(lastLine).join('\n').trim(),
  );
}

/// Wraps [body] in what makes it parse, if anything does.
String _complete(String body) {
  final candidates = [
    body,
    'dynamic snippet() async {\n$body\n}',
    'dynamic snippet() async =>\n$body\n;',
  ];
  return candidates.firstWhere(
    _parses,
    // Invalid, whatever it is. The analyzer reports why on the code as is.
    orElse: () => body,
  );
}

bool _parses(String code) =>
    parseString(content: code, throwIfDiagnostics: false).errors.isEmpty;
