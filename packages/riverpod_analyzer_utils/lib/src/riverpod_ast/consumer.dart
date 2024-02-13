part of '../riverpod_ast.dart';

abstract base class ConsumerDeclaration extends RiverpodAst
    with _$ConsumerDeclaration {
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

final class ConsumerWidgetDeclaration extends ConsumerDeclaration
    with _$ConsumerWidgetDeclaration {
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
  @override
  final List<WidgetRefInvocation> widgetRefInvocations = [];
  @override
  final List<ProviderScopeInstanceCreationExpression>
      providerScopeInstanceCreateExpressions = [];

  @override
  final ClassDeclaration node;
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

final class HookConsumerWidgetDeclaration extends ConsumerDeclaration
    with _$HookConsumerWidgetDeclaration {
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
  @override
  final List<WidgetRefInvocation> widgetRefInvocations = [];
  @override
  final List<ProviderScopeInstanceCreationExpression>
      providerScopeInstanceCreateExpressions = [];

  @override
  final ClassDeclaration node;
}

final class ConsumerStatefulWidgetDeclaration extends ConsumerDeclaration
    with _$ConsumerStatefulWidgetDeclaration {
  ConsumerStatefulWidgetDeclaration._({required this.node});

  ConsumerStatefulWidgetDeclaration.parse(ClassDeclaration node)
      : this._(node: node);

  @override
  final ClassDeclaration node;
}

final class StatefulHookConsumerWidgetDeclaration extends ConsumerDeclaration
    with _$StatefulHookConsumerWidgetDeclaration {
  StatefulHookConsumerWidgetDeclaration._({required this.node});

  StatefulHookConsumerWidgetDeclaration.parse(ClassDeclaration node)
      : this._(node: node);

  @override
  final ClassDeclaration node;
}

final class ConsumerStateDeclaration extends ConsumerDeclaration
    with _$ConsumerStateDeclaration {
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

  @override
  final List<WidgetRefInvocation> widgetRefInvocations = [];
  @override
  final List<ProviderScopeInstanceCreationExpression>
      providerScopeInstanceCreateExpressions = [];

  @override
  final ClassDeclaration node;
}
