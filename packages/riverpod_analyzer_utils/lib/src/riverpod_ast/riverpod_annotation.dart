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
}

class RiverpodAnnotation extends RiverpodAst {
  RiverpodAnnotation._({
    required this.annotation,
    required this.element,
    required this.keepAliveNode,
    required this.dependenciesNode,
    required this.dependencies,
  });

  @internal
  static RiverpodAnnotation? parse(
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
              break;
            case 'dependencies':
              dependenciesNode = argument;
              break;
          }
        }
      }

      final dependenciesNodeValue = dependenciesNode?.expression;

      if (dependenciesNodeValue != null &&
          dependenciesNodeValue is! ListLiteral) {
        throw RiverpodAnalysisException(
          '@Riverpod(dependencies: <...>) only support list literals (using []).',
          targetNode: dependenciesNodeValue,
        );
      }

      final riverpodAnnotationElement =
          RiverpodAnnotationElement.parse(annotatedElement);
      if (riverpodAnnotationElement == null) return null;

      final dependencies = dependenciesNodeValue == null
          ? null
          : _parseDependencies(dependenciesNodeValue as ListLiteral).toList();

      final riverpodAnnotation = RiverpodAnnotation._(
        annotation: annotation,
        element: riverpodAnnotationElement,
        keepAliveNode: keepAliveNode,
        dependenciesNode: dependenciesNode,
        dependencies: dependencies,
      );
      dependencies?.forEach(riverpodAnnotation.addChild);

      return riverpodAnnotation;
    }

    return null;
  }

  static Iterable<RiverpodAnnotationDependency> _parseDependencies(
    ListLiteral dependenciesNodeValue,
  ) sync* {
    for (final dependency in dependenciesNodeValue.elements) {
      if (dependency is! Expression) {
        throw RiverpodAnalysisException(
          '@Riverpod(dependencies: [...]) does not support if/for/spread operators.',
          targetNode: dependency,
        );
      } else if (dependency is SimpleIdentifier) {
        final dependencyElement = dependency.staticElement;
        if (dependencyElement is FunctionElement) {
          final dependencyProvider = StatelessProviderDeclarationElement.parse(
            dependencyElement,
            annotation: null,
          );
          if (dependencyProvider == null) {
            throw RiverpodAnalysisException(
              'The dependency $dependency is not a class annotated with @riverpod',
              targetNode: dependency,
            );
          }

          yield RiverpodAnnotationDependency._(
            node: dependency,
            provider: dependencyProvider,
          );
        } else if (dependencyElement is ClassElement) {
          final dependencyProvider = StatefulProviderDeclarationElement.parse(
            dependencyElement,
            annotation: null,
          );
          if (dependencyProvider == null) {
            throw RiverpodAnalysisException(
              'The dependency $dependency is not a class annotated with @riverpod',
              targetNode: dependency,
            );
          }

          yield RiverpodAnnotationDependency._(
            node: dependency,
            provider: dependencyProvider,
          );
        } else {
          throw RiverpodAnalysisException(
            '@Riverpod(dependencies: [...]) only supports elements annotated with @riverpod as values.',
            targetNode: dependency,
          );
        }
      } else {
        throw RiverpodAnalysisException(
          'Only elements annotated with @riverpod are supported as "dependencies".',
          targetNode: dependency,
        );
      }
    }
  }

  final Annotation annotation;
  final RiverpodAnnotationElement element;
  final NamedExpression? keepAliveNode;
  final NamedExpression? dependenciesNode;

  final List<RiverpodAnnotationDependency>? dependencies;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRiverpodAnnotation(this);
  }
}
