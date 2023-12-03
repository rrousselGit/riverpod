part of '../riverpod_ast.dart';

abstract class ConsumerDeclaration extends RiverpodAst {
  static ConsumerDeclaration? _parse(
    ClassDeclaration node,
    _ParseRefInvocationMixin parent, {
    required CompilationUnit unit,
  }) {
    final extendsClause = node.extendsClause;
    if (extendsClause == null) return null;
    final extendsType = extendsClause.superclass.type;
    if (extendsType == null) return null;

    if (consumerWidgetType.isExactlyType(extendsType)) {
      return ConsumerWidgetDeclaration._parse(node, parent, unit: unit);
    } else if (hookConsumerWidgetType.isExactlyType(extendsType)) {
      return HookConsumerWidgetDeclaration._parse(node, parent, unit: unit);
    } else if (consumerStatefulWidgetType.isExactlyType(extendsType)) {
      return ConsumerStatefulWidgetDeclaration.parse(node, unit: unit);
    } else if (statefulHookConsumerStateType.isExactlyType(extendsType)) {
      return StatefulHookConsumerWidgetDeclaration.parse(node, unit: unit);
    } else if (consumerStateType.isExactlyType(extendsType)) {
      return ConsumerStateDeclaration._parse(node, parent, unit: unit);
    }

    return null;
  }

  ClassDeclaration get node;
  @override
  CompilationUnit get unit;
}

class ConsumerWidgetDeclaration extends ConsumerDeclaration {
  ConsumerWidgetDeclaration._({
    required this.buildMethod,
    required this.node,
    required this.unit,
  });

  static ConsumerWidgetDeclaration? _parse(
    ClassDeclaration node,
    _ParseRefInvocationMixin parent, {
    required CompilationUnit unit,
  }) {
    final buildMethod = node.members
        .whereType<MethodDeclaration>()
        .firstWhereOrNull((e) => e.name.lexeme == 'build');

    final consumerWidgetDeclaration = ConsumerWidgetDeclaration._(
      buildMethod: buildMethod,
      node: node,
      unit: unit,
    );
    final visitor = _ParseConsumerRefInvocationVisitor(
      consumerWidgetDeclaration,
      consumerWidgetDeclaration.widgetRefInvocations,
      consumerWidgetDeclaration.providerScopeInstanceCreateExpressions,
      parent,
      unit: unit,
    );

    buildMethod?.accept(visitor);

    return consumerWidgetDeclaration;
  }

  @override
  final CompilationUnit unit;
  final MethodDeclaration? buildMethod;
  final List<WidgetRefInvocation> widgetRefInvocations = [];
  final List<ProviderScopeInstanceCreationExpression>
      providerScopeInstanceCreateExpressions = [];

  @override
  final ClassDeclaration node;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerWidgetDeclaration(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    for (final invocation in widgetRefInvocations) {
      invocation.accept(visitor);
    }
    for (final expression in providerScopeInstanceCreateExpressions) {
      expression.accept(visitor);
    }
  }
}

class _ParseConsumerRefInvocationVisitor extends RecursiveAstVisitor<void>
    with _ParseRefInvocationMixin {
  _ParseConsumerRefInvocationVisitor(
    this.parent,
    this.widgetRefInvocations,
    this.providerScopeInstanceCreateExpressions,
    this.parentVisitor, {
    required this.unit,
  });

  @override
  final CompilationUnit unit;
  final RiverpodAst parent;
  final List<WidgetRefInvocation> widgetRefInvocations;
  final List<ProviderScopeInstanceCreationExpression>
      providerScopeInstanceCreateExpressions;

  final _ParseRefInvocationMixin parentVisitor;

  @override
  void visitRefInvocation(RefInvocation invocation) {
    parentVisitor.visitRefInvocation(invocation);
  }

  @override
  void visitWidgetRefInvocation(WidgetRefInvocation invocation) {
    widgetRefInvocations.add(invocation);
    invocation._parent = parent;
  }

  @override
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression expression,
  ) {
    parentVisitor.visitProviderContainerInstanceCreationExpression(expression);
  }

  @override
  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression expression,
  ) {
    providerScopeInstanceCreateExpressions.add(expression);
    expression._parent = parent;
  }
}

class HookConsumerWidgetDeclaration extends ConsumerDeclaration {
  HookConsumerWidgetDeclaration({
    required this.buildMethod,
    required this.node,
    required this.unit,
  });

  static HookConsumerWidgetDeclaration? _parse(
    ClassDeclaration node,
    _ParseRefInvocationMixin parent, {
    required CompilationUnit unit,
  }) {
    final buildMethod = node.members
        .whereType<MethodDeclaration>()
        .firstWhereOrNull((e) => e.name.lexeme == 'build');

    final consumerWidgetDeclaration = HookConsumerWidgetDeclaration(
      buildMethod: buildMethod,
      node: node,
      unit: unit,
    );
    final visitor = _ParseConsumerRefInvocationVisitor(
      consumerWidgetDeclaration,
      consumerWidgetDeclaration.widgetRefInvocations,
      consumerWidgetDeclaration.providerScopeInstanceCreateExpressions,
      parent,
      unit: unit,
    );

    buildMethod?.accept(visitor);

    return consumerWidgetDeclaration;
  }

  @override
  final CompilationUnit unit;
  final MethodDeclaration? buildMethod;
  final List<WidgetRefInvocation> widgetRefInvocations = [];
  final List<ProviderScopeInstanceCreationExpression>
      providerScopeInstanceCreateExpressions = [];

  @override
  final ClassDeclaration node;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitHookConsumerWidgetDeclaration(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    for (final invocation in widgetRefInvocations) {
      invocation.accept(visitor);
    }
    for (final expression in providerScopeInstanceCreateExpressions) {
      expression.accept(visitor);
    }
  }
}

class ConsumerStatefulWidgetDeclaration extends ConsumerDeclaration {
  ConsumerStatefulWidgetDeclaration._({
    required this.node,
    required this.unit,
  });

  ConsumerStatefulWidgetDeclaration.parse(
    ClassDeclaration node, {
    required CompilationUnit unit,
  }) : this._(node: node, unit: unit);

  @override
  final CompilationUnit unit;
  @override
  final ClassDeclaration node;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerStatefulWidgetDeclaration(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

class StatefulHookConsumerWidgetDeclaration extends ConsumerDeclaration {
  StatefulHookConsumerWidgetDeclaration._({
    required this.node,
    required this.unit,
  });

  StatefulHookConsumerWidgetDeclaration.parse(
    ClassDeclaration node, {
    required CompilationUnit unit,
  }) : this._(node: node, unit: unit);

  @override
  final CompilationUnit unit;
  @override
  final ClassDeclaration node;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitStatefulHookConsumerWidgetDeclaration(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

class ConsumerStateDeclaration extends ConsumerDeclaration {
  ConsumerStateDeclaration._({
    required this.node,
    required this.unit,
  });

  static ConsumerStateDeclaration? _parse(
    ClassDeclaration node,
    _ParseRefInvocationMixin parent, {
    required CompilationUnit unit,
  }) {
    final consumerWidgetDeclaration = ConsumerStateDeclaration._(
      node: node,
      unit: unit,
    );
    final visitor = _ParseConsumerRefInvocationVisitor(
      consumerWidgetDeclaration,
      consumerWidgetDeclaration.widgetRefInvocations,
      consumerWidgetDeclaration.providerScopeInstanceCreateExpressions,
      parent,
      unit: unit,
    );

    node.accept(visitor);

    return consumerWidgetDeclaration;
  }

  @override
  final CompilationUnit unit;
  final List<WidgetRefInvocation> widgetRefInvocations = [];
  final List<ProviderScopeInstanceCreationExpression>
      providerScopeInstanceCreateExpressions = [];

  @override
  final ClassDeclaration node;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerStateDeclaration(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    for (final invocation in widgetRefInvocations) {
      invocation.accept(visitor);
    }
    for (final expression in providerScopeInstanceCreateExpressions) {
      expression.accept(visitor);
    }
  }
}
