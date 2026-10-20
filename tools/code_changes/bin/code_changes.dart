// Tells which Dart files changed in more than comments and whitespace.
//
// Usage: dart run code_changes OLD NEW [OLD NEW...]
//
// For each pair of files (two versions of one Dart file), prints NEW when
// their code differs. Pairs that only differ in comments (docs included) or
// whitespace print nothing.
//
// Both versions are parsed into an unresolved AST, then compared token by
// token. Comments are not tokens of the AST (they are attached to the tokens
// that follow them), so they take no part in the comparison.

import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/token.dart';

void main(List<String> args) {
  if (args.isEmpty || args.length.isOdd) {
    stderr.writeln('usage: code_changes OLD NEW [OLD NEW...]');
    exitCode = 2;
    return;
  }
  for (var i = 0; i < args.length; i += 2) {
    final before = File(args[i]).readAsStringSync();
    final after = File(args[i + 1]).readAsStringSync();
    if (!_sameCode(before, after)) stdout.writeln(args[i + 1]);
  }
}

/// Whether two Dart sources only differ in comments and whitespace.
bool _sameCode(String before, String after) {
  var left = _firstToken(before);
  var right = _firstToken(after);
  while (left.type == right.type && left.lexeme == right.lexeme) {
    // Both are the end of file, since they have the same type.
    if (left.isEof) return true;
    left = left.next!;
    right = right.next!;
  }
  return false;
}

/// The first token of the unresolved AST of [source].
///
/// Syntax errors are tolerated: the parser recovers in the same way for both
/// versions of a file, so they compare equal unless the code changed.
Token _firstToken(String source) {
  final result = parseString(content: source, throwIfDiagnostics: false);
  return result.unit.beginToken;
}
