part of '../riverpod_ast.dart';

final class RiverpodAnnotationDependency extends RiverpodAst
    with _$RiverpodAnnotationDependency {
  RiverpodAnnotationDependency._({
    required this.node,
    required this.provider,
  });

  final Expression node;
  final GeneratorProviderDeclarationElement provider;
}

final class RiverpodAnnotationDependencies extends RiverpodAst
    with _$RiverpodAnnotationDependencies {
  RiverpodAnnotationDependencies._({
    required this.node,
    required this.dependencies,
  });

  final NamedExpression node;
  @override
  final List<RiverpodAnnotationDependency>? dependencies;
}

final class RiverpodAnnotation extends RiverpodAst with _$RiverpodAnnotation {
  RiverpodAnnotation._({
    required this.annotation,
    required this.element,
    required this.keepAliveNode,
    required this.dependencies,
  });

  static RiverpodAnnotation? _parse(
    Declaration node,
  ) {
    final annotatedElement = node.declaredElement;
    if (annotatedElement == null) return null;

    for (final annotation in node.metadata) {
      final elementAnnotation = annotation.elementAnnotation;
      final annotationElement = annotation.element;
      if (elementAnnotation == null || annotationElement == null) continue;
      if (annotationElement is! ExecutableElement ||
          !riverpodType.isExactlyType(annotationElement.returnType)) {
        // The annotation is not an @Riverpod
        continue;
      }

      final dartObject = elementAnnotation.computeConstantValue();
      if (dartObject == null) return null;

      NamedExpression? keepAliveNode;
      NamedExpression? dependenciesNode;
      final argumentList = annotation.arguments;
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
          RiverpodAnnotationElement.parse(annotatedElement);
      if (riverpodAnnotationElement == null) return null;

      final dependencies = _parseDependencies(dependenciesNode);

      final riverpodAnnotation = RiverpodAnnotation._(
        annotation: annotation,
        element: riverpodAnnotationElement,
        keepAliveNode: keepAliveNode,
        dependencies: dependencies,
      );
      dependencies?._parent = riverpodAnnotation;

      return riverpodAnnotation;
    }

    return null;
  }

  static RiverpodAnnotationDependencies? _parseDependencies(
    NamedExpression? dependenciesNode,
  ) {
    if (dependenciesNode == null) return null;
    // TODO handle Riverpod(dependencies:null)

    final dependencies =
        parseProviderOrFamilyListLiteral(dependenciesNode.expression)
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

    final riverpodAnnotationDependencies = RiverpodAnnotationDependencies._(
      node: dependenciesNode,
      dependencies: dependencies,
    );

    for (final dependency in dependencies) {
      dependency._parent = riverpodAnnotationDependencies;
    }

    return riverpodAnnotationDependencies;
  }

  final Annotation annotation;
  final RiverpodAnnotationElement element;
  final NamedExpression? keepAliveNode;
  @override
  final RiverpodAnnotationDependencies? dependencies;
}
