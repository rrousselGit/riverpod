part of '../../nodes.dart';

@_ast
extension FunctionalProviderDeclarationX on FunctionDeclaration {
  static final _cache = Expando<Box<FunctionalProviderDeclaration?>>();

  FunctionalProviderDeclaration? get provider {
    return _cache.upsert(this, () {
      final element = declaredElement;
      if (element == null) return null;

      final riverpod = this.riverpod;
      if (riverpod == null) return null;

      final providerElement = FunctionalProviderDeclarationElement._parse(
        element,
      );
      if (providerElement == null) return null;

      final createdTypeNode = returnType;
      final exposedTypeNode = _computeExposedType(
        createdTypeNode,
        root.cast<CompilationUnit>()!,
      );
      if (exposedTypeNode == null) {
        // Error already reported
        return null;
      }

      return FunctionalProviderDeclaration._(
        name: name,
        node: this,
        providerElement: providerElement,
        annotation: riverpod,
        createdTypeNode: createdTypeNode,
        exposedTypeNode: exposedTypeNode,
        valueTypeNode: _getValueType(createdTypeNode),
      );
    });
  }
}

final class FunctionalProviderDeclaration extends GeneratorProviderDeclaration {
  FunctionalProviderDeclaration._({
    required this.name,
    required this.node,
    required this.providerElement,
    required this.annotation,
    required this.createdTypeNode,
    required this.exposedTypeNode,
    required this.valueTypeNode,
  });

  @override
  final Token name;

  @override
  final FunctionDeclaration node;
  @override
  final FunctionalProviderDeclarationElement providerElement;
  @override
  final RiverpodAnnotation annotation;
  @override
  final TypeAnnotation? createdTypeNode;
  @override
  final TypeAnnotation? valueTypeNode;
  @override
  final SourcedType exposedTypeNode;
}

class FunctionalProviderDeclarationElement
    extends GeneratorProviderDeclarationElement {
  FunctionalProviderDeclarationElement._({
    required this.name,
    required this.annotation,
    required this.element,
  });

  static final _cache = _Cache<FunctionalProviderDeclarationElement?>();

  static FunctionalProviderDeclarationElement? _parse(
    ExecutableElement element,
  ) {
    return _cache(element, () {
      final riverpodAnnotation = RiverpodAnnotationElement._of(element);
      if (riverpodAnnotation == null) return null;

      return FunctionalProviderDeclarationElement._(
        name: element.name,
        annotation: riverpodAnnotation,
        element: element,
      );
    });
  }

  @override
  bool get isScoped => super.isScoped || element.isExternal;

  @override
  bool get isFamily {
    return element.parameters.length > 1 || element.typeParameters.isNotEmpty;
  }

  @override
  final RiverpodAnnotationElement annotation;
  @override
  final String name;
  @override
  final ExecutableElement element;
}
