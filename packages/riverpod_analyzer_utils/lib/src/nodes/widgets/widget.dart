part of '../../nodes.dart';

@_ast
extension WidgetX on ClassDeclaration {
  WidgetDeclaration? get widget {
    return upsert('Widget', () {
      final type = extendsClause?.superclass.type;
      if (type == null) return null;

      if (isStatelessWidget(type)) {
        return StatelessWidgetDeclaration._parse(this);
      }

      if (isStatefulWidget(type)) {
        return StatefulWidgetDeclaration._parse(this);
      }

      return null;
    });
  }

  StateDeclaration? get state {
    return upsert('State', () {
      final type = extendsClause?.superclass.type;
      if (type == null) return null;

      if (isState(type)) return StateDeclaration._parse(this);

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
