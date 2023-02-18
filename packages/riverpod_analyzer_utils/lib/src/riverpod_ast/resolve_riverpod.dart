part of '../riverpod_ast.dart';

class ResolvedRiverpodLibraryResult extends RiverpodAst {
  ResolvedRiverpodLibraryResult._();

  factory ResolvedRiverpodLibraryResult.from(
    List<ResolvedUnitResult> units,
  ) {
    final result = ResolvedRiverpodLibraryResult._();
    final visitor = _ParseRiverpodUnitVisitor(result);

    try {
      errorReporter = result.errors.add;

      for (final unit in units) {
        unit.unit.accept(visitor);
      }
    } finally {
      errorReporter = null;
    }

    return result;
  }

  final errors = <RiverpodAnalysisError>[];

  final statelessProviderDeclarations = <StatelessProviderDeclaration>[];
  final statefulProviderDeclarations = <StatefulProviderDeclaration>[];

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
    final declaration = StatefulProviderDeclaration.parse(node);
    if (declaration != null) {
      result.statefulProviderDeclarations.add(declaration);
      declaration._parent = result;
      // Don't call super as StatefulProviderDeclaration should already be recursive
      return;
    }

    final consumerDeclaration = ConsumerDeclaration.parse(node);
    if (consumerDeclaration != null) {
      consumerDeclaration._parent = result;
      consumerDeclaration.accept(_AddConsumerDeclarationVisitor(result));
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
      declaration._parent = result;
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
}
