part of '../../nodes.dart';

final class StatelessWidgetDeclaration extends WidgetDeclaration {
  StatelessWidgetDeclaration._({
    required this.element,
    required this.node,
  });

  static StatelessWidgetDeclaration? _parse(ClassDeclaration node) {
    final element = node.declaredElement.let(
      StatelessWidgetDeclarationElement._parse,
    );
    if (element == null) return null;

    return StatelessWidgetDeclaration._(
      element: element,
      node: node,
    );
  }

  @override
  final StatelessWidgetDeclarationElement element;

  @override
  final ClassDeclaration node;
}

final class StatelessWidgetDeclarationElement extends WidgetDeclarationElement {
  StatelessWidgetDeclarationElement._({required this.dependencies});

  static final _cache = _Cache<StatelessWidgetDeclarationElement>();

  static StatelessWidgetDeclarationElement? _parse(ClassElement node) {
    return _cache(node, () {
      final dependencies = DependenciesAnnotationElement._of(node);

      return StatelessWidgetDeclarationElement._(
        dependencies: dependencies,
      );
    });
  }

  @override
  final DependenciesAnnotationElement? dependencies;
}
