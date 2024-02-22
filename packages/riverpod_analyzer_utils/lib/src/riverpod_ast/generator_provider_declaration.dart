part of '../riverpod_ast.dart';

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

SourcedType? _computeExposedType(
  TypeAnnotation? createdType,
  LibraryElement library,
) {
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

    final exposedDartType =
        library.createdTypeToValueType(createdDartType.typeArguments.first);
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

typedef SourcedType = ({String? source, DartType dartType});

final class ClassBasedProviderDeclaration extends GeneratorProviderDeclaration {
  ClassBasedProviderDeclaration._({
    required this.name,
    required this.node,
    required this.buildMethod,
    required this.providerElement,
    required this.annotation,
    required this.createdTypeNode,
    required this.exposedTypeNode,
    required this.valueTypeNode,
  });

  static ClassBasedProviderDeclaration? _parse(ClassDeclaration node) {
    final element = node.declaredElement;
    if (element == null) return null;
    final riverpodAnnotation = RiverpodAnnotation._parse(node);
    if (riverpodAnnotation == null) return null;

    // TODO changelog report error if abstract
    if (node.abstractKeyword != null) {
      errorReporter?.call(
        RiverpodAnalysisError(
          'Classes annotated with @riverpod cannot be abstract.',
          targetNode: node,
          targetElement: node.declaredElement,
          code: RiverpodAnalysisErrorCode.abstractNotifier,
        ),
      );
    }

    final constructors =
        node.members.whereType<ConstructorDeclaration>().toList();
    final defaultConstructor = constructors
        .firstWhereOrNull((constructor) => constructor.name == null);
    if (defaultConstructor == null && constructors.isNotEmpty) {
      errorReporter?.call(
        RiverpodAnalysisError(
          'Classes annotated with @riverpod must have a default constructor.',
          targetNode: node,
          targetElement: node.declaredElement,
          code: RiverpodAnalysisErrorCode.missingNotifierDefaultConstructor,
        ),
      );
    }
    // TODO changelog report error if default constructor is missing
    if (defaultConstructor != null &&
        defaultConstructor.parameters.parameters.any((e) => e.isRequired)) {
      errorReporter?.call(
        RiverpodAnalysisError(
          'The default constructor of classes annotated with @riverpod '
          'cannot have required parameters.',
          targetNode: node,
          targetElement: node.declaredElement,
          code: RiverpodAnalysisErrorCode
              .notifierDefaultConstructorHasRequiredParameters,
        ),
      );
    }

    final buildMethod = node.members
        .whereType<MethodDeclaration>()
        .firstWhereOrNull((method) => method.name.lexeme == 'build');
    if (buildMethod == null) {
      errorReporter?.call(
        RiverpodAnalysisError(
          'No "build" method found. '
          'Classes annotated with @riverpod must define a method named "build".',
          targetNode: node,
          code: RiverpodAnalysisErrorCode.missingNotifierBuild,
        ),
      );
      return null;
    }

    final providerElement = ClassBasedProviderDeclarationElement._parse(
      element,
      annotation: riverpodAnnotation.element,
    );
    if (providerElement == null) return null;

    final createdTypeNode = buildMethod.returnType;

    final exposedTypeNode =
        _computeExposedType(createdTypeNode, element.library);
    if (exposedTypeNode == null) {
      // Error already reported
      return null;
    }

    final valueTypeNode = _getValueType(createdTypeNode, element.library);
    final classBasedProviderDeclaration = ClassBasedProviderDeclaration._(
      name: node.name,
      node: node,
      buildMethod: buildMethod,
      providerElement: providerElement,
      annotation: riverpodAnnotation,
      createdTypeNode: createdTypeNode,
      exposedTypeNode: exposedTypeNode,
      valueTypeNode: valueTypeNode,
    );

    return classBasedProviderDeclaration;
  }

  @override
  final Token name;
  @override
  final ClassDeclaration node;
  @override
  final ClassBasedProviderDeclarationElement providerElement;
  @override
  final RiverpodAnnotation annotation;
  final MethodDeclaration buildMethod;
  @override
  final TypeAnnotation? createdTypeNode;
  @override
  final TypeAnnotation? valueTypeNode;
  @override
  final SourcedType exposedTypeNode;
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

  static FunctionalProviderDeclaration? _parse(FunctionDeclaration node) {
    final element = node.declaredElement;
    if (element == null) return null;
    final riverpodAnnotation = RiverpodAnnotation._parse(node);
    if (riverpodAnnotation == null) return null;

    final providerElement = FunctionalProviderDeclarationElement.parse(
      element,
      annotation: riverpodAnnotation.element,
    );
    if (providerElement == null) return null;

    final createdTypeNode = node.returnType;
    final exposedTypeNode =
        _computeExposedType(createdTypeNode, element.library);
    if (exposedTypeNode == null) {
      // Error already reported
      return null;
    }

    return FunctionalProviderDeclaration._(
      name: node.name,
      node: node,
      providerElement: providerElement,
      annotation: riverpodAnnotation,
      createdTypeNode: createdTypeNode,
      exposedTypeNode: exposedTypeNode,
      valueTypeNode: _getValueType(createdTypeNode, element.library),
    );
  }

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
