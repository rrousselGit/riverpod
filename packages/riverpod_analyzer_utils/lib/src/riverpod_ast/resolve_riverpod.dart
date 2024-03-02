part of '../riverpod_ast.dart';

class ResolvedRiverpodLibraryResult extends RiverpodAst {
  ResolvedRiverpodLibraryResult._();

  factory ResolvedRiverpodLibraryResult.from(
    List<CompilationUnit> units,
  ) {
    final result = ResolvedRiverpodLibraryResult._();
    final visitor = _ParseRiverpodUnitVisitor(result);

    try {
      errorReporter = result.errors.add;

      for (final unit in units) {
        // Let's not parse generated files
        const generatedExtensions = {'.freezed.dart', '.g.dart'};
        final shortName = unit.declaredElement?.source.shortName ?? '';
        if (generatedExtensions.any(shortName.endsWith)) {
          continue;
        }
        unit.accept(visitor);
      }
    } finally {
      errorReporter = null;
    }

    return result;
  }

  final errors = <RiverpodAnalysisError>[];

  final providerScopeInstanceCreationExpressions =
      <ProviderScopeInstanceCreationExpression>[];
  final providerContainerInstanceCreationExpressions =
      <ProviderContainerInstanceCreationExpression>[];

  final functionalProviderDeclarations = <FunctionalProviderDeclaration>[];
  final classBasedProviderDeclarations = <ClassBasedProviderDeclaration>[];

  final legacyProviderDeclarations = <LegacyProviderDeclaration>[];

  final consumerWidgetDeclarations = <ConsumerWidgetDeclaration>[];
  final consumerStatefulWidgetDeclarations =
      <ConsumerStatefulWidgetDeclaration>[];
  final consumerStateDeclaration = <ConsumerStateDeclaration>[];
  final statefulHookConsumerWidgetDeclarations =
      <StatefulHookConsumerWidgetDeclaration>[];
  final hookConsumerWidgetDeclarations = <HookConsumerWidgetDeclaration>[];

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
    for (final declaration in providerScopeInstanceCreationExpressions) {
      declaration.accept(visitor);
    }
    for (final declaration in providerContainerInstanceCreationExpressions) {
      declaration.accept(visitor);
    }

    for (final declaration in functionalProviderDeclarations) {
      declaration.accept(visitor);
    }
    for (final declaration in classBasedProviderDeclarations) {
      declaration.accept(visitor);
    }
    for (final declaration in legacyProviderDeclarations) {
      declaration.accept(visitor);
    }
    for (final declaration in consumerWidgetDeclarations) {
      declaration.accept(visitor);
    }
    for (final declaration in consumerStatefulWidgetDeclarations) {
      declaration.accept(visitor);
    }
    for (final declaration in consumerStateDeclaration) {
      declaration.accept(visitor);
    }
    for (final declaration in statefulHookConsumerWidgetDeclarations) {
      declaration.accept(visitor);
    }
    for (final declaration in hookConsumerWidgetDeclarations) {
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

    final refInvocation = RefInvocation._parse(node, superCall: superCall);
    if (refInvocation != null) {
      visitRefInvocation(refInvocation);
      // Don't call super as RefInvocation should already be recursive
      return;
    }

    final widgetRefInvocation =
        WidgetRefInvocation._parse(node, superCall: superCall);
    if (widgetRefInvocation != null) {
      visitWidgetRefInvocation(widgetRefInvocation);
      // Don't call super as WidgetRefInvocation should already be recursive
      return;
    }

    super.visitMethodInvocation(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final providerScopeInstanceCreationExpression =
        ProviderScopeInstanceCreationExpression._parse(node);
    if (providerScopeInstanceCreationExpression != null) {
      visitProviderScopeInstanceCreationExpression(
        providerScopeInstanceCreationExpression,
      );
      // Don't call super as ProviderScopeInstanceCreationExpression should
      // already be recursive
      return;
    }

    final providerContainerInstanceCreationExpression =
        ProviderContainerInstanceCreationExpression._parse(node);
    if (providerContainerInstanceCreationExpression != null) {
      visitProviderContainerInstanceCreationExpression(
        providerContainerInstanceCreationExpression,
      );
      // Don't call super as ProviderContainerInstanceCreationExpression should
      // already be recursive
      return;
    }

    super.visitInstanceCreationExpression(node);
  }

  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression expression,
  );
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression expression,
  );

  void visitRefInvocation(RefInvocation invocation);

  void visitWidgetRefInvocation(WidgetRefInvocation invocation);
}

class _AddConsumerDeclarationVisitor extends UnimplementedRiverpodAstVisitor {
  _AddConsumerDeclarationVisitor(this.result);

  final ResolvedRiverpodLibraryResult result;

  @override
  void visitConsumerStatefulWidgetDeclaration(
    ConsumerStatefulWidgetDeclaration declaration,
  ) {
    result.consumerStatefulWidgetDeclarations.add(declaration);
  }

  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration declaration) {
    result.consumerStateDeclaration.add(declaration);
  }

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
    StatefulHookConsumerWidgetDeclaration declaration,
  ) {
    result.statefulHookConsumerWidgetDeclarations.add(declaration);
  }

  @override
  void visitHookConsumerWidgetDeclaration(
    HookConsumerWidgetDeclaration declaration,
  ) {
    result.hookConsumerWidgetDeclarations.add(declaration);
  }

  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration declaration) {
    result.consumerWidgetDeclarations.add(declaration);
  }
}

class _ParseRiverpodUnitVisitor extends RecursiveAstVisitor<void>
    with _ParseRefInvocationMixin {
  _ParseRiverpodUnitVisitor(this.result);

  final ResolvedRiverpodLibraryResult result;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final declaration = ClassBasedProviderDeclaration._parse(node, this);
    if (declaration != null) {
      result.classBasedProviderDeclarations.add(declaration);
      declaration._parent = result;
      // Don't call super as ClassBasedProviderDeclaration should already be recursive
      return;
    }

    final consumerDeclaration = ConsumerDeclaration._parse(node, this);
    if (consumerDeclaration != null) {
      consumerDeclaration._parent = result;
      consumerDeclaration.accept(_AddConsumerDeclarationVisitor(result));
      // Don't call super as ClassBasedProviderDeclaration should already be recursive
      return;
    }

    super.visitClassDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final declaration = FunctionalProviderDeclaration._parse(node, this);
    if (declaration != null) {
      result.functionalProviderDeclarations.add(declaration);
      declaration._parent = result;
      // Don't call super as FunctionalProviderDeclaration should already be recursive
      return;
    }

    super.visitFunctionDeclaration(node);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    final declaration = LegacyProviderDeclaration._parse(node, this);
    if (declaration != null) {
      result.legacyProviderDeclarations.add(declaration);
      declaration._parent = result;
      // Don't call super as LegacyProviderDeclaration should already be recursive
      return;
    }

    super.visitVariableDeclaration(node);
  }

  @override
  void visitRefInvocation(RefInvocation invocation) {
    result.unknownRefInvocations.add(invocation);
    invocation._parent = result;
  }

  @override
  void visitWidgetRefInvocation(WidgetRefInvocation invocation) {
    result.unknownWidgetRefInvocations.add(invocation);
    invocation._parent = result;
  }

  @override
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression expression,
  ) {
    result.providerContainerInstanceCreationExpressions.add(expression);
    expression._parent = result;
  }

  @override
  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression expression,
  ) {
    result.providerScopeInstanceCreationExpressions.add(expression);
    expression._parent = result;
  }
}
