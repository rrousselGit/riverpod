part of '../nodes.dart';

extension RiverpodAnnotatedAnnotatedNodeOfX on AnnotatedNode {
  RiverpodAnnotation? get riverpod {
    return upsert('RiverpodAnnotationAnnotatedNodeX', () {
      return metadata.map((e) => e.riverpod).whereNotNull().firstOrNull;
    });
  }
}

@_ast
extension RiverpodAnnotatedAnnotatedNodeX on Annotation {
  RiverpodAnnotation? get riverpod {
    return upsert('RiverpodAnnotation', () {
      final elementAnnotation = this.elementAnnotation;
      final element = this.element;
      if (element == null || elementAnnotation == null) return null;
      if (element is! ExecutableElement ||
          !riverpodType.isExactlyType(element.returnType)) {
        // The annotation is not an @Riverpod
        return null;
      }

      final riverpodAnnotationElement = RiverpodAnnotationElement._parse(
        elementAnnotation,
      );
      if (riverpodAnnotationElement == null) return null;

      final dependenciesNode = arguments?.named('dependencies');

      final dependencyList = dependenciesNode.let(
        (e) => e.expression.providerDependencyList,
      );

      final AstNode? retryNode = arguments?.named('retry')?.expression;
      if (retryNode is! SimpleIdentifier?) {
        errorReporter(
          RiverpodAnalysisError(
            'The "retry" argument must be a variable.',
            targetNode: retryNode,
            code: RiverpodAnalysisErrorCode.invalidRetryArgument,
          ),
        );
      }

      return RiverpodAnnotation._(
        node: this,
        element: riverpodAnnotationElement,
        keepAliveNode: arguments?.named('keepAlive'),
        dependenciesNode: dependenciesNode,
        dependencyList: dependencyList,
        retryNode: retryNode as SimpleIdentifier?,
      );
    });
  }
}

final class RiverpodAnnotation {
  RiverpodAnnotation._({
    required this.node,
    required this.element,
    required this.keepAliveNode,
    required this.dependenciesNode,
    required this.dependencyList,
    required this.retryNode,
  });

  final Annotation node;
  final RiverpodAnnotationElement element;
  final NamedExpression? keepAliveNode;
  final NamedExpression? dependenciesNode;
  final ProviderDependencyList? dependencyList;
  final SimpleIdentifier? retryNode;
}

final class RiverpodAnnotationElement {
  RiverpodAnnotationElement._({
    required this.keepAlive,
    required this.dependencies,
    required this.allTransitiveDependencies,
    required this.element,
  });

  static final _cache = _Cache<RiverpodAnnotationElement?>();

  static RiverpodAnnotationElement? _parse(ElementAnnotation element) {
    return _cache(element, () {
      final type = element.element.cast<ExecutableElement>()?.returnType;
      if (type == null || !riverpodType.isExactlyType(type)) return null;

      final constant = element.computeConstantValue();
      if (constant == null) return null;

      final keepAlive = constant.getField('keepAlive');
      if (keepAlive == null) return null;

      final dependencies = constant.getField('dependencies');
      if (dependencies == null) return null;

      final dependencyList = dependencies.toDependencyList(
        from: element.element,
      );
      final allTransitiveDependencies = dependencyList == null
          ? null
          : <GeneratorProviderDeclarationElement>{
              ...dependencyList,
              ...dependencyList.expand(
                (e) => e.annotation.allTransitiveDependencies ?? const {},
              ),
            };

      return RiverpodAnnotationElement._(
        keepAlive: keepAlive.toBoolValue()!,
        element: element,
        dependencies: dependencyList,
        allTransitiveDependencies: allTransitiveDependencies,
      );
    });
  }

  static RiverpodAnnotationElement? _of(Element element) {
    return element.metadata.map(_parse).whereNotNull().firstOrNull;
  }

  final bool keepAlive;
  final ElementAnnotation element;
  final List<GeneratorProviderDeclarationElement>? dependencies;
  final Set<GeneratorProviderDeclarationElement>? allTransitiveDependencies;
}
