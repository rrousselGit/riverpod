part of '../../nodes.dart';

bool _isCoreType(DartType type) {
  return isFromFlutter.isExactlyType(type) ||
      isFromFlutterRiverpod.isExactlyType(type) ||
      isFromRiverpod.isExactlyType(type) ||
      isFromHooksRiverpod.isExactlyType(type);
}

ClassElement2? _findStateFromReturnType(ClassElement2 node) {
  final type = node.methods2
      .firstWhereOrNull((e) => e.name3 == 'createState')
      ?.returnType;

  if (type == null) return null;

  // May be typed as `MyState createState()` or `State<MyWidget> createState()`.
  // The latter prevents from finding the state class.
  if (_isCoreType(type)) return null;

  return type.element3.cast<ClassElement2>();
}

ClassElement2? _findStateWithMatchingGeneric(ClassElement2 node) {
  for (final clazz in node.library2.classes) {
    final type = clazz.supertype;
    if (type != null && isState(type) && _findStateWidget(clazz) == node) {
      return clazz;
    }
  }

  return null;
}

ClassElement2? _findState(ClassElement2 node) {
  return _findStateFromReturnType(node) ?? _findStateWithMatchingGeneric(node);
}

final class StatefulWidgetDeclaration extends WidgetDeclaration {
  StatefulWidgetDeclaration({
    required this.node,
    required this.state,
    required this.element,
  });

  static StatefulWidgetDeclaration? _parse(ClassDeclaration node) {
    final stateClass = node.declaredFragment?.element.let(_findState);
    final element = node.declaredFragment?.element.let(
      (e) => StatefulWidgetDeclarationElement._parse(e, node),
    );
    if (element == null) return null;

    return StatefulWidgetDeclaration(
      node: node,
      element: element,
      state: stateClass.let((e) => StateDeclarationElement._parse(e, node)),
    );
  }

  final StateDeclarationElement? state;
  @override
  final StatefulWidgetDeclarationElement element;
  @override
  final ClassDeclaration node;

  StateDeclaration? findStateAst() {
    final stateName = state?.element.name3;
    if (stateName == null) return null;

    final unit = node.thisOrAncestorOfType<CompilationUnit>()!;

    final stateClass = unit.declarations
        .whereType<ClassDeclaration>()
        .firstWhereOrNull((e) => e.name.lexeme == stateName);

    return stateClass?.state;
  }
}

final class StatefulWidgetDeclarationElement extends WidgetDeclarationElement {
  StatefulWidgetDeclarationElement({
    required this.element,
    required this.dependencies,
  });

  static final _cache = _Cache<StatefulWidgetDeclarationElement>();

  static StatefulWidgetDeclarationElement? _parse(
    ClassElement2 node,
    AstNode from,
  ) {
    return _cache(node, () {
      final dependencies = DependenciesAnnotationElement._of(node, from);

      return StatefulWidgetDeclarationElement(
        element: node,
        dependencies: dependencies,
      );
    });
  }

  final ClassElement2 element;
  @override
  final DependenciesAnnotationElement? dependencies;
}
