part of '../riverpod_ast.dart';

extension RawTypeX on DartType {
  /// Returns whether this type is a `Raw` typedef from `package:riverpod_annotation`.
  bool get isRaw {
    final alias = this.alias;
    if (alias == null) return false;
    return alias.element.name == 'Raw' &&
        isFromRiverpodAnnotation.isExactly(alias.element);
  }
}

extension on LibraryElement {
  static final _asyncValueCache = Expando<ClassElement>();

  Element? findElementWithNameFromPackage(
    String name, {
    required String packageName,
  }) {
    return library.importedLibraries
        .map((e) => e.exportNamespace.get(name))
        .firstWhereOrNull(
          // TODO find a way to test this
          (element) => element != null && isFromRiverpod.isExactly(element),
        );
  }

  ClassElement? findAsyncValue() {
    final cache = _asyncValueCache[this];
    if (cache != null) return cache;

    final result = findElementWithNameFromPackage(
      'AsyncValue',
      packageName: 'riverpod',
    );
    if (result == null) {
      errorReporter?.call(
        RiverpodAnalysisError(
          'No AsyncValue accessible in the library. '
          'Did you forget to import Riverpod?',
          targetElement: this,
        ),
      );
      return null;
    }

    return _asyncValueCache[this] = result as ClassElement?;
  }

  DartType? createdTypeToValueType(DartType? typeArg) {
    final asyncValue = findAsyncValue();

    return asyncValue?.instantiate(
      typeArguments: [if (typeArg != null) typeArg],
      nullabilitySuffix: NullabilitySuffix.none,
    );
  }
}

abstract class GeneratorProviderDeclaration extends ProviderDeclaration {
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

  final List<RefInvocation> refInvocations = [];

  String computeProviderHash() {
    // TODO improve hash function to inspect the body of the create fn
    // such that the hash changes if one of the element defined outside of the
    // fn changes.
    final bytes = utf8.encode(node.toSource());
    final digest = sha1.convert(bytes);
    return digest.toString();
  }

  @mustCallSuper
  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    for (final refInvocation in refInvocations) {
      refInvocation.accept(visitor);
    }
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

class ClassBasedProviderDeclaration extends GeneratorProviderDeclaration {
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

  static ClassBasedProviderDeclaration? _parse(
    ClassDeclaration node,
    _ParseRefInvocationMixin parent,
  ) {
    final element = node.declaredElement;
    if (element == null) return null;
    final riverpodAnnotation = RiverpodAnnotation._parse(node);
    if (riverpodAnnotation == null) return null;

    final buildMethod = node.members
        .whereType<MethodDeclaration>()
        .firstWhereOrNull((method) => method.name.lexeme == 'build');
    if (buildMethod == null) {
      errorReporter?.call(
        RiverpodAnalysisError(
          'No "build" method found. '
          'Classes annotated with @riverpod must define a method named "build".',
          targetNode: node,
        ),
      );
      return null;
    }

    final providerElement = ClassBasedProviderDeclarationElement.parse(
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
    riverpodAnnotation._parent = classBasedProviderDeclaration;
    node.accept(
      _GeneratorRefInvocationVisitor(classBasedProviderDeclaration, parent),
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

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitClassBasedProviderDeclaration(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    annotation.accept(visitor);
  }
}

class _GeneratorRefInvocationVisitor extends RecursiveAstVisitor<void>
    with _ParseRefInvocationMixin {
  _GeneratorRefInvocationVisitor(this.declaration, this.parent);

  final GeneratorProviderDeclaration declaration;
  final _ParseRefInvocationMixin parent;

  @override
  void visitRefInvocation(RefInvocation invocation) {
    declaration.refInvocations.add(invocation);
    invocation._parent = declaration;
  }

  @override
  void visitWidgetRefInvocation(WidgetRefInvocation invocation) {
    parent.visitWidgetRefInvocation(invocation);
  }

  @override
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression expression,
  ) {
    parent.visitProviderContainerInstanceCreationExpression(expression);
  }

  @override
  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression expression,
  ) {
    parent.visitProviderScopeInstanceCreationExpression(expression);
  }
}

class FunctionalProviderDeclaration extends GeneratorProviderDeclaration {
  FunctionalProviderDeclaration._({
    required this.name,
    required this.node,
    required this.providerElement,
    required this.annotation,
    required this.createdTypeNode,
    required this.exposedTypeNode,
    required this.valueTypeNode,
  });

  static FunctionalProviderDeclaration? _parse(
    FunctionDeclaration node,
    _ParseRefInvocationMixin parent,
  ) {
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

    final functionalProviderDeclaration = FunctionalProviderDeclaration._(
      name: node.name,
      node: node,
      providerElement: providerElement,
      annotation: riverpodAnnotation,
      createdTypeNode: createdTypeNode,
      exposedTypeNode: exposedTypeNode,
      valueTypeNode: _getValueType(createdTypeNode, element.library),
    );
    riverpodAnnotation._parent = functionalProviderDeclaration;
    node.accept(
      _GeneratorRefInvocationVisitor(functionalProviderDeclaration, parent),
    );
    return functionalProviderDeclaration;
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

  /// Whether the provider uses the syntax sugar for scoped providers:
  ///
  /// ```dart
  /// @riverpod
  /// external int count();
  /// ```
  bool get needsOverride => node.externalKeyword != null;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitFunctionalProviderDeclaration(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    annotation.accept(visitor);
  }
}
