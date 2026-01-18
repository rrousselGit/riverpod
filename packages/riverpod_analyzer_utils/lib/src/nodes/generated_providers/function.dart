part of '../../nodes.dart';

@_ast
extension FunctionalProviderDeclarationX on FunctionDeclaration {
  static final _cache = Expando<Box<FunctionalProviderDeclaration?>>();

  FunctionalProviderDeclaration? get provider {
    return _cache.upsert(this, () {
      final element = declaredFragment?.element;
      if (element == null) return null;

      final riverpod = this.riverpod;
      if (riverpod == null) return null;

      final providerElement = FunctionalProviderDeclarationElement._parse(
        element,
        this,
      );
      if (providerElement == null) return null;

      return FunctionalProviderDeclaration._(
        name: name,
        node: this,
        providerElement: providerElement,
        annotation: riverpod,
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
  });

  @override
  final Token name;

  @override
  final FunctionDeclaration node;
  @override
  final FunctionalProviderDeclarationElement providerElement;
  @override
  final RiverpodAnnotation annotation;
}

class FunctionalProviderDeclarationElement
    extends GeneratorProviderDeclarationElement {
  FunctionalProviderDeclarationElement._({
    required this.name,
    required this.annotation,
    required this.element,
    required this.createdTypeNode,
    required this.exposedTypeNode,
    required this.valueTypeNode,
    required this.createdType,
  });

  static final _cache = _Cache<FunctionalProviderDeclarationElement?>();

  static FunctionalProviderDeclarationElement? _parse(
    ExecutableElement element,
    AstNode from,
  ) {
    return _cache(element, () {
      final riverpodAnnotation = RiverpodAnnotationElement._of(element, from);
      if (riverpodAnnotation == null) return null;

      final rootUnit = from.root as CompilationUnit;
      final types = _computeTypes(element.returnType, rootUnit);
      if (types == null) {
        // Error already reported
        return null;
      }

      return FunctionalProviderDeclarationElement._(
        name: element.name!,
        annotation: riverpodAnnotation,
        element: element,
        createdTypeNode: types.createdType,
        exposedTypeNode: types.exposedType,
        valueTypeNode: types.valueType,
        createdType: types.supportedCreatedType,
      );
    });
  }

  @override
  bool get isScoped => super.isScoped || element.isExternal;

  @override
  bool get isFamily {
    return element.formalParameters.length > 1 ||
        element.typeParameters.isNotEmpty;
  }

  @override
  final RiverpodAnnotationElement annotation;
  @override
  final String name;
  @override
  final ExecutableElement element;
  @override
  final String createdTypeNode;
  @override
  final String exposedTypeNode;
  @override
  final DartType valueTypeNode;
  @override
  final SupportedCreatedType createdType;
}
