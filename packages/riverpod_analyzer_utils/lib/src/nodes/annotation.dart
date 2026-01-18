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
        this,
      );
      if (riverpodAnnotationElement == null) return null;

      final dependenciesNode = arguments?.named('dependencies');

      final dependencyList = dependenciesNode.let(
        (e) => e.expression.providerDependencyList,
      );

      final retryNode = arguments?.named('retry')?.expression;
      final parsedRetryNode = retryNode.let(ConstantSymbol.tryParse);

      if (retryNode != null && parsedRetryNode == null) {
        errorReporter(
          RiverpodAnalysisError.ast(
            'The "retry" argument must be a variable. Got: ${retryNode.runtimeType}',
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
        retryNode: parsedRetryNode,
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
  final ConstantSymbol? retryNode;
}

sealed class ConstantSymbol {
  const ConstantSymbol();

  static ConstantSymbol? tryParse(AstNode node) {
    // Use a switch with type patterns instead of if-else chains
    switch (node) {
      case PrefixedIdentifier():
        return PrefixedIdentifierConstantSymbol(node);
      case SimpleIdentifier():
        return SimpleIdentifierConstantSymbol(node);
      case PropertyAccess():
        return PropertyAccessConstantSymbol(node);
      default:
        return null;
    }
  }

  AstNode get node;
}

/// prefix.Class.staticVariable
final class PropertyAccessConstantSymbol extends ConstantSymbol {
  PropertyAccessConstantSymbol(this.node);

  @override
  final PropertyAccess node;
}

/// Class.staticVariable
final class PrefixedIdentifierConstantSymbol extends ConstantSymbol {
  PrefixedIdentifierConstantSymbol(this.node);

  @override
  final PrefixedIdentifier node;
}

/// staticVariable
final class SimpleIdentifierConstantSymbol extends ConstantSymbol {
  SimpleIdentifierConstantSymbol(this.node);

  @override
  final SimpleIdentifier node;
}

final class RiverpodAnnotationElement {
  RiverpodAnnotationElement._({
    required this.keepAlive,
    required this.dependencies,
    required this.allTransitiveDependencies,
    required this.element,
    required this.name,
  });

  static final _cache = _Cache<RiverpodAnnotationElement?>();

  static RiverpodAnnotationElement? _parse(
    ElementAnnotation element,
    AstNode from,
  ) {
    return _cache(element, () {
      final type = element.element.cast<ExecutableElement>()?.returnType;
      if (type == null || !riverpodType.isExactlyType(type)) return null;

      final constant = element.computeConstantValue();
      if (constant == null) return null;

      final keepAlive = constant.getField('keepAlive');
      if (keepAlive == null) return null;

      final name = constant.getField('name');
      if (name == null) return null;

      final dependencies = constant.getField('dependencies');
      if (dependencies == null) return null;

      final dependencyList = dependencies.toDependencyList(from: from);
      final allTransitiveDependencies =
          dependencyList == null
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
        name: name.toStringValue(),
        dependencies: dependencyList,
        allTransitiveDependencies: allTransitiveDependencies,
      );
    });
  }

  static RiverpodAnnotationElement? _of(Element element, AstNode from) {
    return element.metadata.annotations
        .map((e) => _parse(e, from))
        .nonNulls
        .firstOrNull;
  }

  final bool keepAlive;
  final String? name;
  final ElementAnnotation element;
  final List<GeneratorProviderDeclarationElement>? dependencies;
  final Set<GeneratorProviderDeclarationElement>? allTransitiveDependencies;
}
