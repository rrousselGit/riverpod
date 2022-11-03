import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

/// A function that resolves the [AstNode] of an Element
typedef AstResolver = Future<AstNode?> Function(
  Element element, {
  bool resolve,
});
