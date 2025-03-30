part of '../nodes.dart';

extension RiverpodAnnotatedAnnotatedNodeOfX on AnnotatedNode {
  static final _cache = Expando<Box<RiverpodAnnotation?>>();

  RiverpodAnnotation? get riverpod {
    return _cache.upsert(this, () {
      return metadata.map((e) => e.riverpod).nonNulls.firstOrNull;
    });
  }
}

extension AnnotationOf on Annotation {
  ElementAnnotation? annotationOfType(TypeChecker type, {required bool exact}) {
    final elementAnnotation = this.elementAnnotation;
    final element = this.element;
    if (element == null || elementAnnotation == null) return null;
    if (element is! ExecutableElement) return null;

    if ((exact && !type.isExactlyType(element.returnType)) ||
        (!exact && !type.isAssignableFromType(element.returnType))) {
      return null;
    }

    return elementAnnotation;
  }
}

@_ast
extension RiverpodAnnotatedAnnotatedNodeX on Annotation {
  static final _cache = Expando<Box<RiverpodAnnotation?>>();

  RiverpodAnnotation? get riverpod {
    return _cache.upsert(this, () {
      final elementAnnotation = annotationOfType(riverpodType, exact: true);
      if (elementAnnotation == null) return null;

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
    return element.metadata.map(_parse).nonNulls.firstOrNull;
  }

  final bool keepAlive;
  final ElementAnnotation element;
  final List<GeneratorProviderDeclarationElement>? dependencies;
  final Set<GeneratorProviderDeclarationElement>? allTransitiveDependencies;
}

extension MutationAnnotatedNodeOfX on AnnotatedNode {
  static final _cache = Expando<Box<MutationAnnotation?>>();

  MutationAnnotation? get mutation {
    return _cache.upsert(this, () {
      return metadata.map((e) => e.mutation).nonNulls.firstOrNull;
    });
  }
}

extension MutationAnnotationX on Annotation {
  static final _cache = Expando<Box<MutationAnnotation?>>();

  MutationAnnotation? get mutation {
    return _cache.upsert(this, () {
      final elementAnnotation = annotationOfType(mutationType, exact: true);
      if (elementAnnotation == null) return null;

      final mutationAnnotationElement = MutationAnnotationElement._parse(
        elementAnnotation,
      );
      if (mutationAnnotationElement == null) return null;

      return MutationAnnotation._(
        node: this,
        element: mutationAnnotationElement,
      );
    });
  }
}

final class MutationAnnotation {
  MutationAnnotation._({required this.node, required this.element});

  final Annotation node;
  final MutationAnnotationElement element;
}

final class MutationAnnotationElement {
  MutationAnnotationElement._({
    required this.element,
  });

  static final _cache = _Cache<MutationAnnotationElement?>();

  static MutationAnnotationElement? _parse(ElementAnnotation element) {
    return _cache(element, () {
      final type = element.element.cast<ExecutableElement>()?.returnType;
      if (type == null || !mutationType.isExactlyType(type)) return null;

      return MutationAnnotationElement._(
        element: element,
      );
    });
  }

  static MutationAnnotationElement? _of(Element element) {
    return element.metadata.map(_parse).nonNulls.firstOrNull;
  }

  final ElementAnnotation element;
}
