import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

/// Obtains the [AstNode] of an [Element]
Future<AstNode?> findAstNodeForElement(Element element) async {
  final libraryElement = element.library;
  if (libraryElement == null) return null;
  try {
    final parsedLibrary =
        await element.session?.getResolvedLibraryByElement(libraryElement);
    if (parsedLibrary is! ResolvedLibraryResult) return null;

    final declaration = parsedLibrary.getElementDeclaration(element);
    return declaration?.node;
  } on InconsistentAnalysisException {
    final libraryResult =
        await element.session?.getLibraryByUri(libraryElement.source.fullName);
    if (libraryResult is! LibraryElementResult) return null;
    return findAstNodeForElement(libraryResult.element);
  }
}

class AsyncRecursiveVisitor<T> extends GeneralizingAstVisitor<Stream<T>> {
  @override
  Stream<T>? visitNode(AstNode node) {
    final visitor = _VisitChildren();
    node.visitChildren(visitor);

    return Stream.fromIterable(visitor._children)
        .asyncExpand((event) => event.accept(this));
  }
}

class _VisitChildren extends GeneralizingAstVisitor<void> {
  final List<AstNode> _children = [];

  @override
  void visitNode(AstNode node) {
    _children.add(node);
  }
}
