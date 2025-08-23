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
  String get exposedTypeNode;
  String get createdTypeNode;

  SupportedCreatedType get createdType;

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

  String providerName(BuildYamlOptions options) {
    if (annotation.name case final name?) return name;

    final prefix = (isFamily
        ? options.providerFamilyNamePrefix
        : options.providerNamePrefix);
    final suffix = (isFamily
        ? options.providerFamilyNameSuffix
        : options.providerNameSuffix);

    var baseName = name;

    try {
      final regex = RegExp(options.providerNameStripPattern);
      baseName = name.replaceAll(regex, '');
    } on FormatException {
      throw ArgumentError.value(
        options.providerNameStripPattern,
        'providerNameStripPattern',
        r'Your providerNameStripPattern definition is not a valid regular expression: $options.providerNameStripPattern',
      );
    }

    return '$prefix${prefix.isEmpty ? baseName.lowerFirst : baseName.titled}$suffix';
  }
}

({
  String createdType,
  DartType valueType,
  String exposedType,
  SupportedCreatedType supportedCreatedType
})? _computeTypes(
  DartType buildReturnValue,
  CompilationUnit unit,
) {
  final valueType = _getValueType(
    buildReturnValue,
    typeProvider: unit.declaredFragment!.element.typeProvider,
  );

  final (createdType, supportedCreatedType) = _computeCreatedType(
    buildReturnValue,
    unit,
    valueType: valueType,
  );

  final exposedType = _computeExposedType(createdType);

  return (
    createdType: createdType.toCode(),
    valueType: valueType,
    exposedType: exposedType,
    supportedCreatedType: supportedCreatedType,
  );
}

(DartType, SupportedCreatedType) _computeCreatedType(
  DartType createdType,
  CompilationUnit unit, {
  required DartType valueType,
}) {
  if (createdType.isRaw) return (createdType, SupportedCreatedType.value);

  if (createdType.isDartAsyncFuture || createdType.isDartAsyncFutureOr) {
    createdType as InterfaceType;

    final typeProvider = unit.declaredFragment!.element.typeProvider;
    return (typeProvider.futureOrType(valueType), SupportedCreatedType.future);
  }

  if (createdType.isDartAsyncStream) {
    return (createdType, SupportedCreatedType.stream);
  }

  return (createdType, SupportedCreatedType.value);
}

String _computeExposedType(DartType createdType) {
  if (createdType.isRaw) return createdType.toCode();

  if (createdType.isDartAsyncFuture ||
      createdType.isDartAsyncFutureOr ||
      createdType.isDartAsyncStream) {
    createdType as InterfaceType;

    return _asyncValueTypeCode(createdType.typeArguments.first);
  }

  return createdType.toCode();
}

String _asyncValueTypeCode(DartType typeArg) =>
    '$asyncValueCode<${typeArg.toCode()}>';

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
