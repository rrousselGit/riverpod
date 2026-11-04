import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

import 'issue_links.dart';

final _ignoreComment = RegExp(r'^//\s*ignore(_for_file)?\s*:');

/// Every `// ignore` and `// ignore_for_file` comment must link the GitHub
/// issue that requires it, on its line.
@internal
const ignoreCheck = LinkedCommentCheck(
  name: 'ignores',
  label: '`// ignore`',
  whenClosed: 'Remove the ignore',
  keyword: 'ignore',
  find: _ignoreComments,
);

/// Like the analyzer, only comments that start with `ignore:` or
/// `ignore_for_file:` count, not the same text elsewhere in a comment.
Iterable<({int offset, String text})> _ignoreComments(
  CompilationUnit unit,
) sync* {
  for (final comment in commentsOf(unit)) {
    if (_ignoreComment.hasMatch(comment.lexeme)) {
      yield (offset: comment.offset, text: comment.lexeme);
    }
  }
}
