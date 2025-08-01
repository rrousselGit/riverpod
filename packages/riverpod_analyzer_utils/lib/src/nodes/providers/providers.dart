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

  static SupportedCreatedType from(TypeAnnotation? type) {
    final dartType = type?.type;
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

  String get valueTypeDisplayString => valueTypeNode?.toSource() ?? 'Object?';
  String get exposedTypeDisplayString => exposedTypeNode?.source ?? 'Object?';
  String get createdTypeDisplayString {
    final type = createdTypeNode?.type;

    if (type != null &&
        !type.isRaw &&
        (type.isDartAsyncFuture || type.isDartAsyncFutureOr)) {
      return 'FutureOr<$valueTypeDisplayString>';
    }

    return createdTypeNode?.toSource() ?? 'Object?';
  }

  TypeAnnotation? get valueTypeNode;
  SourcedType? get exposedTypeNode;
  TypeAnnotation? get createdTypeNode;

  SupportedCreatedType get createdType =>
      SupportedCreatedType.from(createdTypeNode);

  String computeProviderHash() {
    final bytes = utf8.encode(node.toSource());
    final digest = sha1.convert(bytes);
    return digest.toString();
  }
}

sealed class GeneratorProviderDeclarationElement
    implements ProviderDeclarationElement {
  RiverpodAnnotationElement get annotation;

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

typedef SourcedType = ({String? source, DartType dartType});

SourcedType? _computeExposedType(
  TypeAnnotation? createdType,
  CompilationUnit unit,
) {
  final library = unit.declaredFragment!.element;

  if (createdType == null) {
    return (
      source: null,
      dartType: library.typeProvider.dynamicType,
    );
  }

  final createdDartType = createdType.type!;
  if (createdDartType.isRaw) {
    return (
      source: createdType.toSource(),
      dartType: createdType.type!,
    );
  }

  if (createdDartType.isDartAsyncFuture ||
      createdDartType.isDartAsyncFutureOr ||
      createdDartType.isDartAsyncStream) {
    createdType as NamedType;
    createdDartType as InterfaceType;

    final typeSource = createdType.toSource();
    if (typeSource != 'Future' &&
        typeSource != 'FutureOr' &&
        typeSource != 'Stream' &&
        !typeSource.startsWith('Future<') &&
        !typeSource.startsWith('FutureOr<') &&
        !typeSource.startsWith('Stream<')) {
      throw UnsupportedError(
        'Returning a typedef of type Future/FutureOr/Stream is not supported\n'
        'The code that triggered this error is: $typeSource',
      );
    }

    final valueTypeArg = createdType.typeArguments?.arguments.firstOrNull;

    final exposedDartType = unit.createdTypeToValueType(
      createdDartType.typeArguments.first,
    );
    if (exposedDartType == null) return null;

    return (
      source: valueTypeArg == null ? 'AsyncValue' : 'AsyncValue<$valueTypeArg>',
      dartType: exposedDartType,
    );
  }

  return (
    source: createdType.toSource(),
    dartType: createdType.type!,
  );
}

TypeAnnotation? _getValueType(TypeAnnotation? createdType) {
  switch (SupportedCreatedType.from(createdType)) {
    case SupportedCreatedType.future:
    case SupportedCreatedType.stream:
      return (createdType! as NamedType).typeArguments?.arguments.firstOrNull;
    case SupportedCreatedType.value:
      return createdType;
  }
}
