part of '../../nodes.dart';

ClassElement? _findState(ClassElement node) {
  final type =
      node.methods.firstWhereOrNull((e) => e.name == 'createState')?.returnType;

  if (type == null) return null;

  // May be typed as `MyState createState()` or `State<MyWidget> createState()`.
  // The latter prevents from finding the state class.
  if (isFromFlutter.isExactlyType(type) ||
      isFromFlutterRiverpod.isExactlyType(type) ||
      isFromRiverpod.isExactlyType(type) ||
      isFromHooksRiverpod.isExactlyType(type)) {
    return null;
  }

  return type.element.cast<ClassElement>();
}

final class StatefulWidgetDeclaration extends WidgetDeclaration {
  StatefulWidgetDeclaration({
    required this.node,
    required this.state,
    required this.element,
  });

  static StatefulWidgetDeclaration? _parse(ClassDeclaration node) {
    final stateClass = node.declaredElement.let(_findState);
    final element = node.declaredElement.let(
      StatefulWidgetDeclarationElement._parse,
    );
    if (element == null) return null;

    return StatefulWidgetDeclaration(
      node: node,
      element: element,
      state: stateClass.let(StateDeclarationElement._parse),
    );
  }

  final StateDeclarationElement? state;
  @override
  final StatefulWidgetDeclarationElement element;
  @override
  final ClassDeclaration node;

  StateDeclaration? findStateAst() {
    final stateName = state?.element.name;
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
    required this.node,
    required this.dependencies,
  });

  static final _cache = _Cache<StatefulWidgetDeclarationElement>();

  static StatefulWidgetDeclarationElement? _parse(ClassElement node) {
    return _cache(node, () {
      final dependencies = DependenciesAnnotationElement._of(node);

      return StatefulWidgetDeclarationElement(
        node: node,
        dependencies: dependencies,
      );
    });
  }

  final ClassElement node;
  @override
  final DependenciesAnnotationElement? dependencies;
}
