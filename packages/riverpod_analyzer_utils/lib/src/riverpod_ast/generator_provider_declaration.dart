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
  DartType get valueType;
  DartType get exposedType;
  DartType get createdType;

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

DartType? _computeExposedType(
  DartType createdType,
  LibraryElement library,
) {
  if (createdType.isRaw) return createdType;

  if (createdType.isDartAsyncFuture ||
      createdType.isDartAsyncFutureOr ||
      createdType.isDartAsyncStream) {
    createdType as InterfaceType;
    return library.createdTypeToValueType(createdType.typeArguments.first);
  }

  return createdType;
}

DartType _getValueType(DartType createdType) {
  if (createdType.isRaw) return createdType;

  if (createdType.isDartAsyncFuture ||
      createdType.isDartAsyncFutureOr ||
      createdType.isDartAsyncStream) {
    createdType as InterfaceType;
    return createdType.typeArguments.first;
  }

  return createdType;
}

class StatefulProviderDeclaration extends GeneratorProviderDeclaration {
  StatefulProviderDeclaration._({
    required this.name,
    required this.node,
    required this.buildMethod,
    required this.providerElement,
    required this.annotation,
    required this.createdType,
    required this.exposedType,
    required this.valueType,
  });

  static StatefulProviderDeclaration? _parse(
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

    final providerElement = StatefulProviderDeclarationElement.parse(
      element,
      annotation: riverpodAnnotation.element,
    );
    if (providerElement == null) return null;

    final createdType = buildMethod.returnType?.type ??
        element.library.typeProvider.dynamicType;

    final exposedType = _computeExposedType(createdType, element.library);
    if (exposedType == null) {
      // Error already reported
      return null;
    }

    final statefulProviderDeclaration = StatefulProviderDeclaration._(
      name: node.name,
      node: node,
      buildMethod: buildMethod,
      providerElement: providerElement,
      annotation: riverpodAnnotation,
      createdType: createdType,
      exposedType: exposedType,
      valueType: _getValueType(createdType),
    );
    riverpodAnnotation._parent = statefulProviderDeclaration;
    node.accept(
      _GeneratorRefInvocationVisitor(statefulProviderDeclaration, parent),
    );

    return statefulProviderDeclaration;
  }

  @override
  final Token name;
  @override
  final ClassDeclaration node;
  @override
  final StatefulProviderDeclarationElement providerElement;
  @override
  final RiverpodAnnotation annotation;
  final MethodDeclaration buildMethod;
  @override
  final DartType createdType;
  @override
  final DartType exposedType;
  @override
  final DartType valueType;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitStatefulProviderDeclaration(this);
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

class StatelessProviderDeclaration extends GeneratorProviderDeclaration {
  StatelessProviderDeclaration._({
    required this.name,
    required this.node,
    required this.providerElement,
    required this.annotation,
    required this.createdType,
    required this.exposedType,
    required this.valueType,
  });

  static StatelessProviderDeclaration? _parse(
    FunctionDeclaration node,
    _ParseRefInvocationMixin parent,
  ) {
    final element = node.declaredElement;
    if (element == null) return null;
    final riverpodAnnotation = RiverpodAnnotation._parse(node);
    if (riverpodAnnotation == null) return null;

    final providerElement = StatelessProviderDeclarationElement.parse(
      element,
      annotation: riverpodAnnotation.element,
    );
    if (providerElement == null) return null;

    final createdType = element.returnType;
    final exposedType = _computeExposedType(createdType, element.library);
    if (exposedType == null) {
      // Error already reported
      return null;
    }

    final statelessProviderDeclaration = StatelessProviderDeclaration._(
      name: node.name,
      node: node,
      providerElement: providerElement,
      annotation: riverpodAnnotation,
      createdType: createdType,
      exposedType: exposedType,
      valueType: _getValueType(createdType),
    );
    riverpodAnnotation._parent = statelessProviderDeclaration;
    node.accept(
      _GeneratorRefInvocationVisitor(statelessProviderDeclaration, parent),
    );
    return statelessProviderDeclaration;
  }

  @override
  final Token name;

  @override
  final FunctionDeclaration node;
  @override
  final StatelessProviderDeclarationElement providerElement;
  @override
  final RiverpodAnnotation annotation;
  @override
  final DartType createdType;
  @override
  final DartType exposedType;
  @override
  final DartType valueType;

  /// Whether the provider uses the syntax sugar for scoped providers:
  ///
  /// ```dart
  /// @riverpod
  /// external int count();
  /// ```
  bool get needsOverride => node.externalKeyword != null;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitStatelessProviderDeclaration(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    annotation.accept(visitor);
  }
}
