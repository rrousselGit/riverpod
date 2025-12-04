import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

@internal
class Box<BoxedT> {
  Box(this.value);
  final BoxedT value;
}

@internal
extension ExpandoUtils<NodeT> on Expando<Box<NodeT>> {
  NodeT upsert(AstNode key, NodeT Function() create) {
    // Using a record to differentiate "null value" from "no value".
    final existing = this[key];
    if (existing != null) return existing.value;

    final created = create();
    this[key] = Box(created);
    return created;
  }
}
