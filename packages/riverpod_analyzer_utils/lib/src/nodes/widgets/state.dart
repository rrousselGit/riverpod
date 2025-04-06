part of '../../nodes.dart';

ClassElement? _findStateWidget(ClassElement node) {
  final type = node.supertype?.typeArguments.firstOrNull;
  if (type == null) return null;

  // May be typed as `State<MyWidget>` or `State<StatefulWidget>`.
  // The latter prevents from finding the widget class.
  if (isFromFlutter.isExactlyType(type) ||
      isFromFlutterRiverpod.isExactlyType(type) ||
      isFromRiverpod.isExactlyType(type) ||
      isFromHooksRiverpod.isExactlyType(type)) {
    return null;
  }

  return type.element.cast<ClassElement>();
}

final class StateDeclaration {
  StateDeclaration._({
    required this.widget,
    required this.element,
    required this.node,
  });

  static StateDeclaration? _parse(ClassDeclaration node) {
    final widget = node.declaredElement.let(_findStateWidget);
    final element = node.declaredElement.let(StateDeclarationElement._parse);

    if (element == null) return null;

    return StateDeclaration._(
      widget: widget.let(StatefulWidgetDeclarationElement._parse),
      element: element,
      node: node,
    );
  }

  final ClassDeclaration node;
  final StatefulWidgetDeclarationElement? widget;
  final StateDeclarationElement element;

  WidgetDeclaration? findWidgetAst() {
    final widgetName = widget?.element.name;
    if (widgetName == null) return null;

    final unit = node.thisOrAncestorOfType<CompilationUnit>()!;

    final widgetClass = unit.declarations
        .whereType<ClassDeclaration>()
        .firstWhereOrNull((e) => e.name.lexeme == widgetName);

    return widgetClass?.widget;
  }
}

final class StateDeclarationElement {
  StateDeclarationElement._({
    required this.widget,
    required this.element,
  });

  static final _cache = _Cache<StateDeclarationElement>();

  static StateDeclarationElement? _parse(ClassElement element) {
    return _cache(element, () {
      final widget = _findStateWidget(element);

      return StateDeclarationElement._(
        element: element,
        widget: widget.let(StatefulWidgetDeclarationElement._parse),
      );
    });
  }

  final ClassElement element;
  final StatefulWidgetDeclarationElement? widget;
}
