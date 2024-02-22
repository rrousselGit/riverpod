part of '../riverpod_ast.dart';

abstract base class ConsumerDeclaration {
  ClassDeclaration get node;
}

final class ConsumerWidgetDeclaration extends ConsumerDeclaration {
  ConsumerWidgetDeclaration._({
    required this.buildMethod,
    required this.node,
  });

  static ConsumerWidgetDeclaration? _parse(ClassDeclaration node) {
    final type = node.extendsClause?.superclass.type;
    if (type == null || !consumerWidgetType.isExactlyType(type)) return null;

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
  final ClassDeclaration node;
}

final class HookConsumerWidgetDeclaration extends ConsumerDeclaration {
  HookConsumerWidgetDeclaration({
    required this.buildMethod,
    required this.node,
  });

  static HookConsumerWidgetDeclaration? _parse(ClassDeclaration node) {
    final type = node.extendsClause?.superclass.type;
    if (type == null || !hookConsumerWidgetType.isExactlyType(type)) {
      return null;
    }

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
  final ClassDeclaration node;
}

final class ConsumerStatefulWidgetDeclaration extends ConsumerDeclaration {
  ConsumerStatefulWidgetDeclaration._({required this.node});

  static ConsumerStatefulWidgetDeclaration? _parse(ClassDeclaration node) {
    final type = node.extendsClause?.superclass.type;
    if (type == null || !consumerStatefulWidgetType.isExactlyType(type)) {
      return null;
    }

    return ConsumerStatefulWidgetDeclaration._(node: node);
  }

  @override
  final ClassDeclaration node;
}

final class StatefulHookConsumerWidgetDeclaration extends ConsumerDeclaration {
  StatefulHookConsumerWidgetDeclaration._({required this.node});

  static StatefulHookConsumerWidgetDeclaration? _parse(ClassDeclaration node) {
    final type = node.extendsClause?.superclass.type;
    if (type == null || !statefulHookConsumerStateType.isExactlyType(type)) {
      return null;
    }

    return StatefulHookConsumerWidgetDeclaration._(node: node);
  }

  @override
  final ClassDeclaration node;
}

final class ConsumerStateDeclaration extends ConsumerDeclaration {
  ConsumerStateDeclaration._({required this.node});

  static ConsumerStateDeclaration? _parse(ClassDeclaration node) {
    final type = node.extendsClause?.superclass.type;
    if (type == null || !consumerStateType.isExactlyType(type)) return null;

    return ConsumerStateDeclaration._(node: node);
  }

  @override
  final ClassDeclaration node;
}
