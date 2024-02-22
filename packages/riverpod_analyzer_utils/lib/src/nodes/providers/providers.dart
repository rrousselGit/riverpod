part of '../../nodes.dart';

sealed class ProviderDeclaration {
  Token get name;
  AnnotatedNode get node;
  ProviderDeclarationElement get providerElement;
}

sealed class ProviderDeclarationElement {
  // TODO changelog breaking: removed isAutoDispose from ProviderDeclarationElement
  Element get element;
  String get name;
}

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

// TODO changelog made sealed
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

  String computeProviderHash() {
    // TODO improve hash function to inspect the body of the create fn
    // such that the hash changes if one of the element defined outside of the
    // fn changes.
    final bytes = utf8.encode(node.toSource());
    final digest = sha1.convert(bytes);
    return digest.toString();
  }
}

// TODO changelog made sealed
sealed class GeneratorProviderDeclarationElement
    implements ProviderDeclarationElement {
  RiverpodAnnotationElement get annotation;

  /// Whether a provider has any form of parameter, be it function parameters
  /// or type parameters.
  bool get isFamily;

  bool get isScoped {
    if (annotation.dependencies != null) return true;

    // TODO changelog isScoped now supports abstract build methods
    // TODO test
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
  final library = unit.declaredElement!.library;

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

TypeAnnotation? _getValueType(
  TypeAnnotation? createdType,
  LibraryElement library,
) {
  if (createdType == null) return null;
  final dartType = createdType.type!;
  if (dartType.isRaw) return createdType;

  if (dartType.isDartAsyncFuture ||
      dartType.isDartAsyncFutureOr ||
      dartType.isDartAsyncStream) {
    createdType as NamedType;

    return createdType.typeArguments?.arguments.firstOrNull;
  }

  return createdType;
}
