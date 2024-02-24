part of '../../nodes.dart';

@_ast
extension WidgetX on ClassDeclaration {
  WidgetDeclaration? get widget {
    return upsert('Widget', () {
      final type = extendsClause?.superclass.type;
      if (type == null) return null;

      if (statelessWidgetType.isExactlyType(type) ||
          consumerWidgetType.isExactlyType(type) ||
          hookConsumerWidgetType.isExactlyType(type) ||
          hookWidgetType.isExactlyType(type)) {
        return StatelessWidgetDeclaration._parse(this);
      }

      if (statefulWidgetType.isExactlyType(type) ||
          consumerStatefulWidgetType.isExactlyType(type) ||
          statefulHookConsumerType.isExactlyType(type) ||
          statefulHookType.isExactlyType(type)) {
        return StatefulWidgetDeclaration._parse(this);
      }

      return null;
    });
  }

  StateDeclaration? get state {
    return upsert('State', () {
      final type = extendsClause?.superclass.type;
      if (type == null) return null;

      if (stateType.isExactlyType(type) ||
          consumerStateType.isExactlyType(type)) {
        return StateDeclaration._parse(this);
      }

      return null;
    });
  }
}

abstract class WidgetDeclaration {
  ClassDeclaration get node;
  WidgetDeclarationElement get element;
}

abstract class WidgetDeclarationElement {
  DependenciesAnnotationElement? get dependencies;
}
