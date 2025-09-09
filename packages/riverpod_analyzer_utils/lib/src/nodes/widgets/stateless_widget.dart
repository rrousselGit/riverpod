part of '../../nodes.dart';

final class StatelessWidgetDeclaration extends WidgetDeclaration {
  StatelessWidgetDeclaration._({required this.element, required this.node});

  static StatelessWidgetDeclaration? _parse(ClassDeclaration node) {
    final element = node.declaredFragment?.element.let(
      (e) => StatelessWidgetDeclarationElement._parse(e, node),
    );
    if (element == null) return null;

    return StatelessWidgetDeclaration._(element: element, node: node);
  }

  @override
  final StatelessWidgetDeclarationElement element;

  @override
  final ClassDeclaration node;
}

final class StatelessWidgetDeclarationElement extends WidgetDeclarationElement {
  StatelessWidgetDeclarationElement._({required this.dependencies});

  static final _cache = _Cache<StatelessWidgetDeclarationElement>();

  static StatelessWidgetDeclarationElement? _parse(
    ClassElement node,
    AstNode from,
  ) {
    return _cache(node, () {
      final dependencies = DependenciesAnnotationElement._of(node, from);

      return StatelessWidgetDeclarationElement._(dependencies: dependencies);
    });
  }

  @override
  final DependenciesAnnotationElement? dependencies;
}
