import 'package:analyzer/dart/ast/ast.dart';

extension NodeX on AstNode {
  TargetT? findEnclosing<TargetT extends AstNode>({bool Function(TargetT node)? where}) {
    for (AstNode? node = this; node != null; node = node.parent) {
      if (node is TargetT && (where == null || where(node))) return node;
    }

    return null;
  }
}
