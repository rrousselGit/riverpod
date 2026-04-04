import 'package:analyzer/dart/ast/ast.dart';

extension NodeX on AstNode {
  T? findEnclosing<T extends AstNode>({bool Function(T node)? where}) {
    for (AstNode? node = this; node != null; node = node.parent) {
      if (node is T && (where == null || where(node))) return node;
    }

    return null;
  }
}
