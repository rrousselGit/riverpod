part of '../../nodes.dart';

sealed class ProviderDeclaration {
  Token get name;
  Declaration get node;
  ProviderDeclarationElement get providerElement;
}

sealed class ProviderDeclarationElement {
  Element2 get element;
  String get name;
}

@_ast
extension GeneratorProviderDeclarationX on Declaration {
  GeneratorProviderDeclaration? get provider {
    final that = this;
    switch (that) {
      case ClassDeclaration():
        return ClassBasedProviderDeclarationX(that).provider;
      case FunctionDeclaration():
        return FunctionalProviderDeclarationX(that).provider;
      default:
        return null;
    }
  }
}

enum SupportedCreatedType {
  future,
  stream,
  value;

  static SupportedCreatedType from(DartType type) {
    final dartType = type;
    switch (dartType) {
      case != null
          when !dartType.isRaw &&
              (dartType.isDartAsyncFutureOr || dartType.isDartAsyncFuture):
        return SupportedCreatedType.future;
      case != null when !dartType.isRaw && dartType.isDartAsyncStream:
        return SupportedCreatedType.stream;
      case _:
        return SupportedCreatedType.value;
    }
  }
}

sealed class GeneratorProviderDeclaration extends ProviderDeclaration {
  @override
  GeneratorProviderDeclarationElement get providerElement;
  RiverpodAnnotation get annotation;

  String computeProviderHash() {
    final bytes = utf8.encode(node.toSource());
    final digest = sha1.convert(bytes);
    return digest.toString();
  }
}

sealed class GeneratorProviderDeclarationElement
    implements ProviderDeclarationElement {
  RiverpodAnnotationElement get annotation;

  DartType get valueTypeNode;
  DartType get exposedTypeNode;
  DartType get createdTypeNode;

  SupportedCreatedType get createdType =>
      SupportedCreatedType.from(createdTypeNode);

  /// Whether a provider has any form of parameter, be it function parameters
  /// or type parameters.
  bool get isFamily;

  bool get isScoped {
    if (annotation.dependencies != null) return true;

    final that = this;
    return that is ClassBasedProviderDeclarationElement &&
        that.buildMethod.isAbstract;
  }

  bool get isAutoDispose => !annotation.keepAlive;
}

({
  DartType createdType,
  DartType valueType,
  DartType exposedType,
})? _computeTypes(
  DartType buildReturnValue,
  CompilationUnit unit,
) {
  final valueType = _getValueType(
    buildReturnValue,
    typeProvider: unit.declaredFragment!.element.typeProvider,
  );

  final createdType = _computeCreatedType(
    buildReturnValue,
    unit,
    valueType: valueType,
  );
  if (createdType == null) return null;

  final exposedType = _computeExposedType(createdType.$1, unit);
  if (exposedType == null) return null;

  return (
    createdType: createdType.$1,
    valueType: valueType,
    exposedType: exposedType.$1,
  );
}

(DartType,)? _computeCreatedType(
  DartType createdType,
  CompilationUnit unit, {
  required DartType valueType,
}) {
  if (createdType.isRaw) return (createdType,);

  if (createdType.isDartAsyncFuture || createdType.isDartAsyncFutureOr) {
    createdType as InterfaceType;

    final futureOr = unit.findFutureOr();
    if (futureOr == null) return null;

    return (
      futureOr.instantiate(
        typeArguments: [valueType],
        nullabilitySuffix: NullabilitySuffix.none,
      ),
    );
  }

  return (createdType,);
}

(DartType,)? _computeExposedType(
  DartType createdType,
  CompilationUnit unit,
) {
  if (createdType.isRaw) return (createdType,);

  if (createdType.isDartAsyncFuture ||
      createdType.isDartAsyncFutureOr ||
      createdType.isDartAsyncStream) {
    createdType as InterfaceType;

    final exposedDartType = unit.createdTypeToValueType(
      createdType.typeArguments.first,
    );
    if (exposedDartType == null) return null;

    return (exposedDartType,);
  }

  return (createdType,);
}

DartType _getValueType(
  DartType createdType, {
  required TypeProvider typeProvider,
}) {
  switch (SupportedCreatedType.from(createdType)) {
    case SupportedCreatedType.future:
    case SupportedCreatedType.stream:
      return (createdType as InterfaceType).typeArguments.firstOrNull ??
          typeProvider.dynamicType;
    case SupportedCreatedType.value:
      return createdType;
  }
}
