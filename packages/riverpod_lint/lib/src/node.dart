import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';

extension NodeX on AstNode {
  TargetT? findEnclosing<TargetT extends AstNode>({
    bool Function(TargetT node)? where,
  }) {
    for (AstNode? node = this; node != null; node = node.parent) {
      if (node is TargetT && (where == null || where(node))) return node;
    }

    return null;
  }
}

extension ClassMembers on ClassDeclaration {
  List<ClassMember> get members => switch (body) {
    BlockClassBody(:final members) => members,
    EmptyClassBody() => const [],
  };

  Token? get leftBracket => switch (body) {
    BlockClassBody(:final leftBracket) => leftBracket,
    EmptyClassBody() => null,
  };

  Token? get rightBracket => switch (body) {
    BlockClassBody(:final rightBracket) => rightBracket,
    EmptyClassBody() => null,
  };

  Token get headingEndToken => switch (body) {
    BlockClassBody(:final leftBracket) => leftBracket,
    EmptyClassBody(:final endToken) => endToken,
  };
}
