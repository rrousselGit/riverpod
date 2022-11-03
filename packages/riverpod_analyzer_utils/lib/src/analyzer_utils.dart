import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

/// Obtains the [AstNode] of an [Element]
Future<AstNode?> findAstNodeForElement(Element element) async {
  final libraryElement = element.library;
  if (libraryElement == null) return null;
  final inSdk = element.library?.isInSdk ?? false;
  if (inSdk) {
    return null;
  }
  final parsedLibrary =
      await element.session?.getResolvedLibraryByElement(libraryElement);
  if (parsedLibrary is! ResolvedLibraryResult) return null;

  final declaration = parsedLibrary.getElementDeclaration(element);
  return declaration?.node;
}

/// A [GeneralizingAstVisitor] that returns a [Stream] containing the combination
/// of all events.
///
/// See also [CombiningRecursiveVisitor] for a synchronous variant.
class AsyncRecursiveVisitor<T> extends GeneralizingAstVisitor<Stream<T>> {
  @override
  Stream<T>? visitNode(AstNode node) {
    final visitor = _VisitChildren();
    node.visitChildren(visitor);

    return Stream.fromIterable(visitor._children)
        .asyncExpand((event) => event.accept(this));
  }
}

/// A [CombiningRecursiveVisitor] that returns an [Iterable] containing the combination
/// of all events.
///
/// See also [AsyncRecursiveVisitor] for a asynchronous variant.
class CombiningRecursiveVisitor<T> extends GeneralizingAstVisitor<Iterable<T>> {
  @override
  Iterable<T> visitNode(AstNode node) {
    final visitor = _VisitChildren();
    node.visitChildren(visitor);

    return visitor._children.expand((e) => e.accept(this) ?? const []);
  }
}

class _VisitChildren extends GeneralizingAstVisitor<void> {
  final List<AstNode> _children = [];

  @override
  void visitNode(AstNode node) {
    _children.add(node);
  }
}
