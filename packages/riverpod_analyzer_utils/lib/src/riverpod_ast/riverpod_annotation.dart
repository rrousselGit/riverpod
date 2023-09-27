part of '../riverpod_ast.dart';

class RiverpodAnnotationDependency extends RiverpodAst {
  RiverpodAnnotationDependency._({
    required this.node,
    required this.provider,
  });

  final Expression node;
  final GeneratorProviderDeclarationElement provider;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRiverpodAnnotationDependency(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

class RiverpodAnnotationDependencies extends RiverpodAst {
  RiverpodAnnotationDependencies._({
    required this.node,
    required this.dependencies,
  });

  final NamedExpression node;
  final List<RiverpodAnnotationDependency>? dependencies;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRiverpodAnnotationDependencies(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    final dependencies = this.dependencies;
    if (dependencies != null) {
      for (final dependency in dependencies) {
        dependency.accept(visitor);
      }
    }
  }
}

class RiverpodAnnotation extends RiverpodAst {
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
    final dependenciesNodeValue = dependenciesNode.expression;
    // TODO handle Riverpod(dependencies:null)

    final dependencies = <RiverpodAnnotationDependency>[];

    if (dependenciesNodeValue is! ListLiteral) {
      errorReporter?.call(
        RiverpodAnalysisError(
          '@Riverpod(dependencies: <...>) only support list literals (using []).',
          targetNode: dependenciesNodeValue,
        ),
      );
    } else {
      for (final dependency in dependenciesNodeValue.elements) {
        if (dependency is! Expression) {
          errorReporter?.call(
            RiverpodAnalysisError(
              '@Riverpod(dependencies: [...]) does not support if/for/spread operators.',
              targetNode: dependency,
            ),
          );
          continue;
        }

        if (dependency is! SimpleIdentifier) {
          errorReporter?.call(
            RiverpodAnalysisError(
              'Only elements annotated with @riverpod are supported as "dependencies".',
              targetNode: dependency,
            ),
          );
          continue;
        }

        final dependencyElement = dependency.staticElement;
        if (dependencyElement is FunctionElement) {
          final dependencyProvider = FunctionalProviderDeclarationElement.parse(
            dependencyElement,
            annotation: null,
          );
          if (dependencyProvider == null) {
            errorReporter?.call(
              RiverpodAnalysisError(
                'The dependency $dependency is not a class annotated with @riverpod',
                targetNode: dependency,
              ),
            );
            continue;
          }

          dependencies.add(
            RiverpodAnnotationDependency._(
              node: dependency,
              provider: dependencyProvider,
            ),
          );
        } else if (dependencyElement is ClassElement) {
          final dependencyProvider = ClassBasedProviderDeclarationElement.parse(
            dependencyElement,
            annotation: null,
          );
          if (dependencyProvider == null) {
            errorReporter?.call(
              RiverpodAnalysisError(
                'The dependency $dependency is not a class annotated with @riverpod',
                targetNode: dependency,
              ),
            );
            continue;
          }

          dependencies.add(
            RiverpodAnnotationDependency._(
              node: dependency,
              provider: dependencyProvider,
            ),
          );
        } else {
          errorReporter?.call(
            RiverpodAnalysisError(
              '@Riverpod(dependencies: [...]) only supports elements annotated with @riverpod as values.',
              targetNode: dependency,
            ),
          );
        }
      }
    }

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
  final RiverpodAnnotationDependencies? dependencies;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRiverpodAnnotation(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    dependencies?.accept(visitor);
  }
}
