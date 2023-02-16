part of '../riverpod_ast.dart';

class RiverpodAnalysisException implements Exception {
  RiverpodAnalysisException(
    this.message, {
    this.targetNode,
    this.targetElement,
  });

  final String message;
  final AstNode? targetNode;
  final Element? targetElement;

  @override
  String toString() {
    var trailing = '';
    if (targetElement != null) {
      trailing += '\nelement: $targetElement (${targetElement.runtimeType})';
    }
    if (targetNode != null) {
      trailing += '\nelement: $targetNode (${targetNode.runtimeType})';
    }

    return 'RiverpodAnalysisException: $message$trailing';
  }
}

RiverpodAst? _currentParent;

R _computeChildren<R>(
  RiverpodAst pending,
  R Function() callback,
) {
  final previous = _currentParent;
  _currentParent = pending;
  try {
    return callback();
  } finally {
    _currentParent = previous;
  }
}

T _registerAst<T extends RiverpodAst?>(
  T ast,
  void Function() superCall,
) {
  if (ast != null) {
    ast.setParent(_currentParent!);
    _computeChildren(ast, superCall);
  } else {
    superCall();
  }

  return ast;
}

class ResolvedRiverpodLibraryResult extends RiverpodAst {
  ResolvedRiverpodLibraryResult._();

  factory ResolvedRiverpodLibraryResult.from(
    ResolvedLibraryResult libraryUnit,
  ) {
    final result = ResolvedRiverpodLibraryResult._();
    final visitor = _ParseRiverpodUnitVisitor(result);

    _computeChildren(result, () {
      for (final unit in libraryUnit.units) {
        unit.unit.accept(visitor);
      }
    });

    return result;
  }

  final statelessProviderDeclarations = <StatelessProviderDeclaration>[];
  final statefulProviderDeclarations = <StatefulProviderDeclaration>[];

  final legacyProviderDeclarations = <LegacyProviderDeclaration>[];

  final consumerWidgetDeclarations = <ConsumerWidgetDeclaration>[];
  final statefulConsumerWidgetDeclarations =
      <StatefulConsumerWidgetDeclaration>[];
  final consumerStateDeclaration = <ConsumerStateDeclaration>[];

  @override
  Null get parent => null;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitResolvedRiverpodUnit(this);
  }
}

class _ParseRiverpodUnitVisitor extends RecursiveAstVisitor<void> {
  _ParseRiverpodUnitVisitor(this.result);

  final ResolvedRiverpodLibraryResult result;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final declaration = StatefulProviderDeclaration.parse(node);
    declaration.let(result.statefulProviderDeclarations.add);

    _registerAst(
      declaration,
      () => super.visitClassDeclaration(node),
    );
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final declaration = StatelessProviderDeclaration.parse(node);
    declaration.let(result.statelessProviderDeclarations.add);

    _registerAst(
      declaration,
      () => super.visitFunctionDeclaration(node),
    );
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    final declaration = LegacyProviderDeclaration.parse(node);
    declaration.let(result.legacyProviderDeclarations.add);

    _registerAst(
      declaration,
      () => super.visitVariableDeclaration(node),
    );
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    void superCall() => super.visitMethodInvocation(node);

    final refInvocation = RefInvocation.parse(node, superCall: superCall) ??
        WidgetRefInvocation.parse(node, superCall: superCall);

    _registerAst(refInvocation, () {});
  }
}
