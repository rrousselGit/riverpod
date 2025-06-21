import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

@internal
class Box<T> {
  Box(this.value);
  final T value;
}

@internal
extension AstUtils on AstNode {
  Iterable<AstNode> get ancestors sync* {
    var parent = this.parent;
    while (parent != null) {
      yield parent;
      parent = parent.parent;
    }
  }
}

@internal
extension ExpandoUtils<NodeT> on Expando<Box<NodeT>> {
  NodeT upsert(
    AstNode key,
    NodeT Function() create,
  ) {
    // Using a record to differentiate "null value" from "no value".
    final existing = this[key];
    if (existing != null) return existing.value;

    final created = create();
    this[key] = Box(created);
    return created;
  }
}
