part of '../riverpod_ast.dart';

final class RiverpodAnnotationDependency {
  RiverpodAnnotationDependency._({
    required this.node,
    required this.provider,
  });

  static RiverpodAnnotationDependency? _parse(CollectionElement dependency) {}

  final Expression node;
  final GeneratorProviderDeclarationElement provider;
}

final class RiverpodAnnotationDependencies {
  RiverpodAnnotationDependencies._({
    required this.node,
    required this.dependencies,
  });

  static RiverpodAnnotationDependencies? _parse(Expression dependencies) {}

  final Expression node;
  final List<RiverpodAnnotationDependency>? dependencies;
}

final class RiverpodAnnotation {
  RiverpodAnnotation._({
    required this.node,
    required this.element,
    required this.keepAliveNode,
    required this.dependencies,
  });

  static RiverpodAnnotation? _parse(Annotation node) {
    final elementAnnotation = node.elementAnnotation;
    final annotationElement = node.element;
    if (elementAnnotation == null || annotationElement == null) return null;
    if (annotationElement is! ExecutableElement ||
        !riverpodType.isExactlyType(annotationElement.returnType)) {
      // The annotation is not an @Riverpod
      return null;
    }

    final dartObject = elementAnnotation.computeConstantValue();
    if (dartObject == null) return null;

    NamedExpression? keepAliveNode;
    NamedExpression? dependenciesNode;
    final argumentList = node.arguments;
    if (argumentList != null) {
      for (final argument
          in argumentList.arguments.whereType<NamedExpression>()) {
        switch (argument.name.label.name) {
          case 'keepAlive':
            keepAliveNode = argument;
          case 'dependencies':
            dependenciesNode = argument;
        }
      }
    }

    final riverpodAnnotationElement =
        RiverpodAnnotationElement.parse(node.element);
    if (riverpodAnnotationElement == null) return null;

    final dependencies = _parseDependencies(dependenciesNode);

    return RiverpodAnnotation._(
      node: annotation,
      element: riverpodAnnotationElement,
      keepAliveNode: keepAliveNode,
      dependencies: dependencies,
    );
  }

  static RiverpodAnnotationDependencies? _parseDependencies(
    NamedExpression? dependenciesNode,
  ) {
    if (dependenciesNode == null) return null;
    // TODO handle Riverpod(dependencies:null)

    final dependencies =
        _parseProviderOrFamilyListLiteral(dependenciesNode.expression)
            .map((e) {
              if (e.error case final error?) {
                errorReporter?.call(
                  RiverpodAnalysisError(
                    error.message,
                    targetNode: error.node,
                    code:
                        RiverpodAnalysisErrorCode.riverpodDependencyParseError,
                  ),
                );
                return null;
              }

              final p = e.provider!;

              return RiverpodAnnotationDependency._(
                node: p.astNode,
                provider: p.provider,
              );
            })
            .whereNotNull()
            .toList();

    return RiverpodAnnotationDependencies._(
      node: dependenciesNode,
      dependencies: dependencies,
    );
  }

  final Annotation node;
  final RiverpodAnnotationElement element;
  final NamedExpression? keepAliveNode;
  final RiverpodAnnotationDependencies? dependencies;
}
