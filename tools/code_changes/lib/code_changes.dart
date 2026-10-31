import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/token.dart';

/// Whether two versions of a Dart source only differ in comments (docs
/// included) and whitespace.
///
/// Both versions are parsed into an unresolved AST, then compared token by
/// token. Comments are not tokens of the AST (they are attached to the tokens
/// that follow them), so they take no part in the comparison.
bool sameCode(String before, String after) {
  var left = _firstToken(before);
  var right = _firstToken(after);
  while (_sameToken(left, right)) {
    // Both are the end of file, since they have the same type.
    if (left.isEof) return true;
    left = left.next!;
    right = right.next!;
  }
  return false;
}

/// Whether two tokens are the same code.
///
/// Tokens the parser inserted to recover from a syntax error (such as a
/// missing `;`) have the lexeme of the token they stand for, so they are told
/// apart with [Token.isSynthetic].
bool _sameToken(Token left, Token right) {
  return left.type == right.type &&
      left.lexeme == right.lexeme &&
      left.isSynthetic == right.isSynthetic;
}

/// The first token of the unresolved AST of [source].
///
/// Syntax errors are tolerated: the parser recovers in the same way for both
/// versions of a file, so they compare equal unless the code changed.
Token _firstToken(String source) {
  final result = parseString(content: source, throwIfDiagnostics: false);
  return result.unit.beginToken;
}
