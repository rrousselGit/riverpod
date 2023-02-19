part of '../riverpod_ast.dart';

abstract class ConsumerDeclaration extends RiverpodAst {
  static ConsumerDeclaration? _parse(
    ClassDeclaration node,
    _ParseRefInvocationMixin parent,
  ) {
    final extendsClause = node.extendsClause;
    if (extendsClause == null) return null;
    final extendsType = extendsClause.superclass.type;
    if (extendsType == null) return null;

    if (consumerWidgetType.isExactlyType(extendsType)) {
      return ConsumerWidgetDeclaration._parse(node, parent);
    } else if (hookConsumerWidgetType.isExactlyType(extendsType)) {
      return HookConsumerWidgetDeclaration._parse(node, parent);
    } else if (consumerStatefulWidgetType.isExactlyType(extendsType)) {
      return ConsumerStatefulWidgetDeclaration.parse(node);
    } else if (statefulHookConsumerStateType.isExactlyType(extendsType)) {
      return StatefulHookConsumerWidgetDeclaration.parse(node);
    } else if (consumerStateType.isExactlyType(extendsType)) {
      return ConsumerStateDeclaration._parse(node, parent);
    }

    return null;
  }

  ClassDeclaration get node;
}

class ConsumerWidgetDeclaration extends ConsumerDeclaration {
  ConsumerWidgetDeclaration._({
    required this.buildMethod,
    required this.node,
  });

  static ConsumerWidgetDeclaration? _parse(
    ClassDeclaration node,
    _ParseRefInvocationMixin parent,
  ) {
    final buildMethod = node.members
        .whereType<MethodDeclaration>()
        .firstWhereOrNull((e) => e.name.lexeme == 'build');

    final consumerWidgetDeclaration = ConsumerWidgetDeclaration._(
      buildMethod: buildMethod,
      node: node,
    );
    final visitor = _ParseConsumerRefInvocationVisitor(
      consumerWidgetDeclaration,
      consumerWidgetDeclaration.widgetRefInvocations,
      consumerWidgetDeclaration.providerScopeInstanceCreateExpressions,
      parent,
    );

    buildMethod?.accept(visitor);

    return consumerWidgetDeclaration;
  }

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
    this.parentVisitor,
  );

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
  });

  static HookConsumerWidgetDeclaration? _parse(
    ClassDeclaration node,
    _ParseRefInvocationMixin parent,
  ) {
    final buildMethod = node.members
        .whereType<MethodDeclaration>()
        .firstWhereOrNull((e) => e.name.lexeme == 'build');

    final consumerWidgetDeclaration = HookConsumerWidgetDeclaration(
      buildMethod: buildMethod,
      node: node,
    );
    final visitor = _ParseConsumerRefInvocationVisitor(
      consumerWidgetDeclaration,
      consumerWidgetDeclaration.widgetRefInvocations,
      consumerWidgetDeclaration.providerScopeInstanceCreateExpressions,
      parent,
    );

    buildMethod?.accept(visitor);

    return consumerWidgetDeclaration;
  }

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
  ConsumerStatefulWidgetDeclaration._({required this.node});

  ConsumerStatefulWidgetDeclaration.parse(ClassDeclaration node)
      : this._(node: node);

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
  StatefulHookConsumerWidgetDeclaration._({required this.node});

  StatefulHookConsumerWidgetDeclaration.parse(ClassDeclaration node)
      : this._(node: node);

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
  });

  static ConsumerStateDeclaration? _parse(
    ClassDeclaration node,
    _ParseRefInvocationMixin parent,
  ) {
    final consumerWidgetDeclaration = ConsumerStateDeclaration._(
      node: node,
    );
    final visitor = _ParseConsumerRefInvocationVisitor(
      consumerWidgetDeclaration,
      consumerWidgetDeclaration.widgetRefInvocations,
      consumerWidgetDeclaration.providerScopeInstanceCreateExpressions,
      parent,
    );

    node.accept(visitor);

    return consumerWidgetDeclaration;
  }

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
