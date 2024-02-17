part of '../riverpod_ast.dart';

final class DependenciesAnnotationDependency extends RiverpodAst
    with _$DependenciesAnnotationDependency {
  DependenciesAnnotationDependency._({
    required this.node,
    required this.provider,
  });

  final Expression node;
  final GeneratorProviderDeclarationElement provider;
}

Iterable<
    ({
      ({
        GeneratorProviderDeclarationElement provider,
        Expression astNode,
      })? provider,
      ({String message, AstNode? node})? error,
    })> _parseProviderOrFamilyListLiteral(Expression? expression) sync* {
  if (expression is! ListLiteral) {
    yield (
      provider: null,
      error: (
        message: 'Only list literals (using []) as supported.',
        node: expression,
      ),
    );
    return;
  }

  for (final dependency in expression.elements) {
    if (dependency is! Expression) {
      yield (
        provider: null,
        error: (
          message: 'if/for/spread operators as not supported.',
          node: dependency,
        ),
      );
      continue;
    }

    if (dependency is! SimpleIdentifier) {
      yield (
        provider: null,
        error: (
          message: 'Only elements annotated with @riverpod are supported.',
          node: dependency,
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
      if (dependencyProvider != null) {
        yield (
          provider: (
            provider: dependencyProvider,
            astNode: dependency,
          ),
          error: null,
        );
        continue;
      }

      yield (
        provider: null,
        error: (
          message:
              'The dependency $dependency is not a function annotated with @riverpod',
          node: dependency,
        ),
      );
    } else if (dependencyElement is ClassElement) {
      final dependencyProvider = ClassBasedProviderDeclarationElement.parse(
        dependencyElement,
        annotation: null,
      );

      if (dependencyProvider != null) {
        yield (
          provider: (
            provider: dependencyProvider,
            astNode: dependency,
          ),
          error: null,
        );
        continue;
      }

      yield (
        provider: null,
        error: (
          message:
              'The dependency $dependency is not a class annotated with @riverpod',
          node: dependency,
        ),
      );
    } else {
      yield (
        provider: null,
        error: (
          message: 'Only elements annotated with @riverpod are supported.',
          node: dependency,
        ),
      );
    }
  }
}

final class DependenciesAnnotation extends RiverpodAst
    with _$DependenciesAnnotation {
  DependenciesAnnotation._({
    required this.declaration,
    required this.dependencies,
    required this.node,
  });

  static DependenciesAnnotation? parse(Declaration declaration) {
    const dependenciesType = TypeChecker.fromName(
      'Dependencies',
      packageName: 'riverpod_annotation',
    );

    final annotation = declaration.metadata
        .map((e) {
          final elementAnnotation = e.elementAnnotation;
          final annotationElement = e.element;

          if (elementAnnotation == null || annotationElement == null) {
            return null;
          }
          if (annotationElement is! ExecutableElement) return null;
          if (!dependenciesType.isExactlyType(annotationElement.returnType)) {
            return null;
          }

          return e;
        })
        .whereNotNull()
        .firstOrNull;

    if (annotation == null) return null;

    final listNode = annotation.arguments?.arguments.firstOrNull;

    final dependencies = _parseProviderOrFamilyListLiteral(listNode)
        .map((e) {
          if (e.error case final error?) {
            errorReporter?.call(
              RiverpodAnalysisError(
                error.message,
                targetNode: error.node,
                code: RiverpodAnalysisErrorCode.riverpodDependencyParseError,
              ),
            );
            return null;
          }

          final p = e.provider!;

          return DependenciesAnnotationDependency._(
            node: p.astNode,
            provider: p.provider,
          );
        })
        .whereNotNull()
        .toList();

    return DependenciesAnnotation._(
      dependencies: dependencies,
      declaration: declaration,
      node: annotation,
    );
  }

  final Declaration declaration;
  @override
  final List<DependenciesAnnotationDependency>? dependencies;
  final Annotation node;
}
