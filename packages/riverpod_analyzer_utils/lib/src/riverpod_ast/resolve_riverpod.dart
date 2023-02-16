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

class ResolvedRiverpodLibraryResult extends RiverpodAst {
  ResolvedRiverpodLibraryResult._();

  factory ResolvedRiverpodLibraryResult.from(
    ResolvedLibraryResult libraryUnit,
  ) {
    final result = ResolvedRiverpodLibraryResult._();
    final visitor = _ParseRiverpodUnitVisitor(result);

    for (final unit in libraryUnit.units) {
      unit.unit.accept(visitor);
    }

    return result;
  }

  final statelessProviderDeclarations = <StatelessProviderDeclaration>[];
  final statefulProviderDeclarations = <StatefulProviderDeclaration>[];

  final legacyProviderDeclarations = <LegacyProviderDeclaration>[];

  final consumerWidgetDeclarations = <ConsumerWidgetDeclaration>[];
  final statefulConsumerWidgetDeclarations =
      <StatefulConsumerWidgetDeclaration>[];
  final consumerStateDeclaration = <ConsumerStateDeclaration>[];

  final unknownRefInvocations = <RefInvocation>[];
  final unknownWidgetRefInvocations = <WidgetRefInvocation>[];

  @override
  Null get parent => null;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitResolvedRiverpodUnit(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    for (final declaration in statelessProviderDeclarations) {
      declaration.accept(visitor);
    }
    for (final declaration in statefulProviderDeclarations) {
      declaration.accept(visitor);
    }
    for (final declaration in legacyProviderDeclarations) {
      declaration.accept(visitor);
    }
    for (final declaration in consumerWidgetDeclarations) {
      declaration.accept(visitor);
    }
    for (final declaration in statefulConsumerWidgetDeclarations) {
      declaration.accept(visitor);
    }
    for (final declaration in consumerStateDeclaration) {
      declaration.accept(visitor);
    }

    for (final invocation in unknownRefInvocations) {
      invocation.accept(visitor);
    }
    for (final invocation in unknownWidgetRefInvocations) {
      invocation.accept(visitor);
    }
  }
}

mixin _ParseRefInvocationMixin on RecursiveAstVisitor<void> {
  @override
  void visitMethodInvocation(MethodInvocation node) {
    void superCall() => super.visitMethodInvocation(node);

    final refInvocation = RefInvocation.parse(node, superCall: superCall);
    if (refInvocation != null) {
      visitRefInvocation(refInvocation);
      // Don't call super as RefInvocation should already be recursive
      return;
    }

    final widgetRefInvocation =
        WidgetRefInvocation.parse(node, superCall: superCall);
    if (widgetRefInvocation != null) {
      visitWidgetRefInvocation(widgetRefInvocation);
      // Don't call super as WidgetRefInvocation should already be recursive
      return;
    }

    super.visitMethodInvocation(node);
  }

  void visitRefInvocation(RefInvocation invocation);

  void visitWidgetRefInvocation(WidgetRefInvocation invocation);
}

class _ParseRiverpodUnitVisitor extends RecursiveAstVisitor<void>
    with _ParseRefInvocationMixin {
  _ParseRiverpodUnitVisitor(this.result);

  final ResolvedRiverpodLibraryResult result;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final declaration = StatefulProviderDeclaration.parse(node);
    if (declaration != null) {
      result.statefulProviderDeclarations.add(declaration);
      // Don't call super as StatefulProviderDeclaration should already be recursive
      return;
    }

    super.visitClassDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final declaration = StatelessProviderDeclaration.parse(node);
    if (declaration != null) {
      result.statelessProviderDeclarations.add(declaration);
      // Don't call super as StatelessProviderDeclaration should already be recursive
      return;
    }

    super.visitFunctionDeclaration(node);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    final declaration = LegacyProviderDeclaration.parse(node);
    if (declaration != null) {
      result.legacyProviderDeclarations.add(declaration);
      // Don't call super as LegacyProviderDeclaration should already be recursive
      return;
    }

    super.visitVariableDeclaration(node);
  }

  @override
  void visitRefInvocation(RefInvocation invocation) {
    result.unknownRefInvocations.add(invocation);
  }

  @override
  void visitWidgetRefInvocation(WidgetRefInvocation invocation) {
    result.unknownWidgetRefInvocations.add(invocation);
  }
}
