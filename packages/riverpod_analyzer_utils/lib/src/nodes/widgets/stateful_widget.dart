part of '../../nodes.dart';

@_ast
extension ConsumerStatefulWidgetDeclarationX on ClassDeclaration {
  ConsumerStatefulWidgetDeclaration? get consumerStatefulWidget {
    return upsert('ConsumerStatefulWidgetDeclaration', () {
      final type = extendsClause?.superclass.type;
      if (type == null || !consumerStatefulWidgetType.isExactlyType(type)) {
        return null;
      }

      return ConsumerStatefulWidgetDeclaration._(node: this);
    });
  }
}

final class ConsumerStatefulWidgetDeclaration extends ConsumerDeclaration {
  ConsumerStatefulWidgetDeclaration._({required this.node});

  @override
  final ClassDeclaration node;
}

@_ast
extension StatefulHookConsumerWidgetDeclarationX on ClassDeclaration {
  StatefulHookConsumerWidgetDeclaration? get statefulHookConsumerWidget {
    return upsert('StatefulHookConsumerWidgetDeclaration', () {
      final type = extendsClause?.superclass.type;
      if (type == null || !statefulHookConsumerStateType.isExactlyType(type)) {
        return null;
      }

      return StatefulHookConsumerWidgetDeclaration._(node: this);
    });
  }
}

final class StatefulHookConsumerWidgetDeclaration extends ConsumerDeclaration {
  StatefulHookConsumerWidgetDeclaration._({required this.node});

  @override
  final ClassDeclaration node;
}

@_ast
extension ConsumerStateDeclarationX on ClassDeclaration {
  ConsumerStateDeclaration? get consumerState {
    return upsert('ConsumerStateDeclaration', () {
      final type = extendsClause?.superclass.type;
      if (type == null || !consumerStateType.isExactlyType(type)) return null;

      return ConsumerStateDeclaration._(node: this);
    });
  }
}

final class ConsumerStateDeclaration extends ConsumerDeclaration {
  ConsumerStateDeclaration._({required this.node});

  @override
  final ClassDeclaration node;
}
