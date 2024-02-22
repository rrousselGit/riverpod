part of '../../nodes.dart';

@_ast
extension ConsumerWidgetDeclarationX on ClassDeclaration {
  ConsumerWidgetDeclaration? get consumerWidget {
    return upsert('ConsumerWidgetDeclaration', () {
      final type = extendsClause?.superclass.type;
      if (type == null || !consumerWidgetType.isExactlyType(type)) return null;

      final buildMethod = members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((e) => e.name.lexeme == 'build');

      return ConsumerWidgetDeclaration._(buildMethod: buildMethod, node: this);
    });
  }
}

final class ConsumerWidgetDeclaration extends ConsumerDeclaration {
  ConsumerWidgetDeclaration._({
    required this.buildMethod,
    required this.node,
  });

  final MethodDeclaration? buildMethod;

  @override
  final ClassDeclaration node;
}

@_ast
extension HookConsumerWidgetDeclarationX on ClassDeclaration {
  HookConsumerWidgetDeclaration? get hookConsumerWidget {
    return upsert('HookConsumerWidgetDeclaration', () {
      final type = extendsClause?.superclass.type;
      if (type == null || !hookConsumerWidgetType.isExactlyType(type)) {
        return null;
      }

      final buildMethod = members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((e) => e.name.lexeme == 'build');

      return HookConsumerWidgetDeclaration(
        buildMethod: buildMethod,
        node: this,
      );
    });
  }
}

final class HookConsumerWidgetDeclaration extends ConsumerDeclaration {
  HookConsumerWidgetDeclaration({
    required this.buildMethod,
    required this.node,
  });

  final MethodDeclaration? buildMethod;

  @override
  final ClassDeclaration node;
}
