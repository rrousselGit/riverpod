part of '../../nodes.dart';

@_ast
extension WidgetX on ClassDeclaration {
  static final _cache1 = Expando<Box<WidgetDeclaration?>>();

  WidgetDeclaration? get widget {
    return _cache1.upsert(this, () {
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

  static final _cache2 = Expando<Box<StateDeclaration?>>();

  StateDeclaration? get state {
    return _cache2.upsert(this, () {
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
