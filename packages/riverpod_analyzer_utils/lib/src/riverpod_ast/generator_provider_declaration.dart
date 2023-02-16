part of '../riverpod_ast.dart';

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

  ClassElement findAsyncValue() {
    final cache = _asyncValueCache[this];
    if (cache != null) return cache;

    final result = findElementWithNameFromPackage(
      'AsyncValue',
      packageName: 'riverpod',
    );
    if (result == null) {
      throw RiverpodAnalysisException(
        'No AsyncValue accessible in the library. Did you forget to import Riverpod?',
      );
    }

    return _asyncValueCache[this] = result as ClassElement;
  }

  DartType createdTypeToValueType(DartType? typeArg) {
    final asyncValue = findAsyncValue();

    return asyncValue.instantiate(
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

  String computeProviderHash() {
    // TODO improve hash function to inspect the body of the create fn
    // such that the hash changes if one of the element defined outside of the
    // fn changes.
    final bytes = utf8.encode(node.toSource());
    final digest = sha1.convert(bytes);
    return digest.toString();
  }
}

DartType _computeExposedType(
  DartType createdType,
  LibraryElement library,
) {
  if (createdType.isDartAsyncFuture || createdType.isDartAsyncFutureOr) {
    createdType as InterfaceType;
    return library.createdTypeToValueType(createdType.typeArguments.first);
  }

  return createdType;
}

DartType _getValueType(DartType createdType) {
  if (createdType.isDartAsyncFuture || createdType.isDartAsyncFutureOr) {
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

  @internal
  static StatefulProviderDeclaration? parse(
    ClassDeclaration node,
  ) {
    final element = node.declaredElement;
    Zone.root.print('here $element');
    if (element == null) return null;
    Zone.root.print('here $element');
    final riverpodAnnotation = RiverpodAnnotation.parse(node);
    if (riverpodAnnotation == null) return null;

    final buildMethod = node.members.whereType<MethodDeclaration>().firstWhere(
          (method) => method.name.lexeme == 'build',
          orElse: () => throw RiverpodAnalysisException(
            'No "build" method found. '
            'Classes annotated with @riverpod must define a method named "build".',
          ),
        );

    final providerElement = StatefulProviderDeclarationElement.parse(
      element,
      annotation: riverpodAnnotation.element,
    );
    if (providerElement == null) return null;

    final createdType = buildMethod.returnType?.type ??
        element.library.typeProvider.dynamicType;

    return StatefulProviderDeclaration._(
      name: node.name,
      node: node,
      buildMethod: buildMethod,
      providerElement: providerElement,
      annotation: riverpodAnnotation,
      createdType: createdType,
      exposedType: _computeExposedType(createdType, element.library),
      valueType: _getValueType(createdType),
    );
  }

  @override
  final Token name;
  @override
  final ClassDeclaration node;
  @override
  final GeneratorProviderDeclarationElement providerElement;
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

  @internal
  static StatelessProviderDeclaration? parse(
    FunctionDeclaration node,
  ) {
    final element = node.declaredElement;
    if (element == null) return null;
    final riverpodAnnotation = RiverpodAnnotation.parse(node);
    if (riverpodAnnotation == null) return null;

    final providerElement = StatelessProviderDeclarationElement.parse(
      element,
      annotation: riverpodAnnotation.element,
    );
    if (providerElement == null) return null;

    final createdType = element.returnType;
    return StatelessProviderDeclaration._(
      name: node.name,
      node: node,
      providerElement: providerElement,
      annotation: riverpodAnnotation,
      createdType: createdType,
      exposedType: _computeExposedType(createdType, element.library),
      valueType: _getValueType(createdType),
    );
  }

  @override
  final Token name;

  @override
  final FunctionDeclaration node;
  @override
  final GeneratorProviderDeclarationElement providerElement;
  @override
  final RiverpodAnnotation annotation;
  @override
  final DartType createdType;
  @override
  final DartType exposedType;
  @override
  final DartType valueType;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitStatelessProviderDeclaration(this);
  }
}
