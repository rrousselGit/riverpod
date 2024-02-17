part of '../riverpod_ast.dart';

final class ResolvedRiverpodLibraryResult extends RiverpodAst
    with _$ResolvedRiverpodLibraryResult {
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

    result.visitChildren(_SetParentVisitor(result));

    return result;
  }

  final errors = <RiverpodAnalysisError>[];

  @override
  final functionalProviderDeclarations = <FunctionalProviderDeclaration>[];
  @override
  final classBasedProviderDeclarations = <ClassBasedProviderDeclaration>[];

  @override
  final legacyProviderDeclarations = <LegacyProviderDeclaration>[];

  @override
  final consumerWidgetDeclarations = <ConsumerWidgetDeclaration>[];
  @override
  final consumerStatefulWidgetDeclarations =
      <ConsumerStatefulWidgetDeclaration>[];
  @override
  final consumerStateDeclaration = <ConsumerStateDeclaration>[];
  @override
  final statefulHookConsumerWidgetDeclarations =
      <StatefulHookConsumerWidgetDeclaration>[];
  @override
  final hookConsumerWidgetDeclarations = <HookConsumerWidgetDeclaration>[];

  @override
  Null get parent => null;

  // TODO changelog breaking renamed visitResolvedRiverpodLibraryResult
}

mixin _ParseRefInvocationMixin on GeneralizingAstVisitor<void> {
  @override
  void visitMethodInvocation(MethodInvocation node) {
    final refInvocation = RefInvocation._parse(node);
    if (refInvocation != null) {
      visitRefInvocation(refInvocation);
      // Don't call super as RefInvocation should already be recursive
      return;
    }

    final widgetRefInvocation = WidgetRefInvocation._parse(node);
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

class _ParseRiverpodUnitVisitor extends SimpleAstVisitor<void> {
  _ParseRiverpodUnitVisitor(this.result);

  final ResolvedRiverpodLibraryResult result;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final declaration = ClassBasedProviderDeclaration._parse(node);
    if (declaration != null) {
      result.classBasedProviderDeclarations.add(declaration);
      // Don't call super as ClassBasedProviderDeclaration should already be recursive
      return;
    }

    final consumerDeclaration = ConsumerDeclaration._parse(node);
    if (consumerDeclaration != null) {
      consumerDeclaration.accept(_AddConsumerDeclarationVisitor(result));
      // Don't call super as ClassBasedProviderDeclaration should already be recursive
      return;
    }

    super.visitClassDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final declaration = FunctionalProviderDeclaration._parse(node);
    if (declaration != null) {
      result.functionalProviderDeclarations.add(declaration);
      // Don't call super as FunctionalProviderDeclaration should already be recursive
      return;
    }

    super.visitFunctionDeclaration(node);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    final declaration = LegacyProviderDeclaration._parse(node);
    if (declaration != null) {
      result.legacyProviderDeclarations.add(declaration);
      // Don't call super as LegacyProviderDeclaration should already be recursive
      return;
    }

    super.visitVariableDeclaration(node);
  }
}
