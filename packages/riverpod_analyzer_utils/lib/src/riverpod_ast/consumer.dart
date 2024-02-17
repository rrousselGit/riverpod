part of '../riverpod_ast.dart';

abstract base class ConsumerDeclaration extends RiverpodAst
    with _$ConsumerDeclaration {
  static ConsumerDeclaration? _parse(ClassDeclaration node) {
    final extendsClause = node.extendsClause;
    if (extendsClause == null) return null;
    final extendsType = extendsClause.superclass.type;
    if (extendsType == null) return null;

    if (consumerWidgetType.isExactlyType(extendsType)) {
      return ConsumerWidgetDeclaration._parse(node);
    } else if (hookConsumerWidgetType.isExactlyType(extendsType)) {
      return HookConsumerWidgetDeclaration._parse(node);
    } else if (consumerStatefulWidgetType.isExactlyType(extendsType)) {
      return ConsumerStatefulWidgetDeclaration.parse(node);
    } else if (statefulHookConsumerStateType.isExactlyType(extendsType)) {
      return StatefulHookConsumerWidgetDeclaration.parse(node);
    } else if (consumerStateType.isExactlyType(extendsType)) {
      return ConsumerStateDeclaration._parse(node);
    }

    return null;
  }

  @override
  ClassDeclaration get node;
}

final class ConsumerWidgetDeclaration extends ConsumerDeclaration
    with _$ConsumerWidgetDeclaration {
  ConsumerWidgetDeclaration._({
    required this.buildMethod,
    required this.node,
  });

  static ConsumerWidgetDeclaration? _parse(ClassDeclaration node) {
    final buildMethod = node.members
        .whereType<MethodDeclaration>()
        .firstWhereOrNull((e) => e.name.lexeme == 'build');

    return ConsumerWidgetDeclaration._(
      buildMethod: buildMethod,
      node: node,
    );
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

final class HookConsumerWidgetDeclaration extends ConsumerDeclaration
    with _$HookConsumerWidgetDeclaration {
  HookConsumerWidgetDeclaration({
    required this.buildMethod,
    required this.node,
  });

  static HookConsumerWidgetDeclaration? _parse(ClassDeclaration node) {
    final buildMethod = node.members
        .whereType<MethodDeclaration>()
        .firstWhereOrNull((e) => e.name.lexeme == 'build');

    return HookConsumerWidgetDeclaration(
      buildMethod: buildMethod,
      node: node,
    );
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

  static ConsumerStateDeclaration? _parse(ClassDeclaration node) {
    return ConsumerStateDeclaration._(node: node);
  }

  @override
  final List<WidgetRefInvocation> widgetRefInvocations = [];
  @override
  final List<ProviderScopeInstanceCreationExpression>
      providerScopeInstanceCreateExpressions = [];

  @override
  final ClassDeclaration node;
}
