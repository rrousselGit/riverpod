part of '../../nodes.dart';

@_ast
extension ClassBasedProviderDeclarationX on ClassDeclaration {
  static final _cache = Expando<Box<ClassBasedProviderDeclaration?>>();

  ClassBasedProviderDeclaration? get provider {
    return _cache.upsert(this, () {
      final element = declaredElement;
      if (element == null) return null;

      final riverpod = this.riverpod;
      if (riverpod == null) return null;

      if (abstractKeyword != null) {
        errorReporter(
          RiverpodAnalysisError(
            'Classes annotated with @riverpod cannot be abstract.',
            targetNode: this,
            targetElement: declaredElement,
            code: RiverpodAnalysisErrorCode.abstractNotifier,
          ),
        );
      }

      final constructors = members.whereType<ConstructorDeclaration>().toList();
      final defaultConstructor = constructors
          .firstWhereOrNull((constructor) => constructor.name == null);
      if (defaultConstructor == null && constructors.isNotEmpty) {
        errorReporter(
          RiverpodAnalysisError(
            'Classes annotated with @riverpod must have a default constructor.',
            targetNode: this,
            targetElement: declaredElement,
            code: RiverpodAnalysisErrorCode.missingNotifierDefaultConstructor,
          ),
        );
      }
      if (defaultConstructor != null &&
          defaultConstructor.parameters.parameters.any((e) => e.isRequired)) {
        errorReporter(
          RiverpodAnalysisError(
            'The default constructor of classes annotated with @riverpod '
            'cannot have required parameters.',
            targetNode: this,
            targetElement: declaredElement,
            code: RiverpodAnalysisErrorCode
                .notifierDefaultConstructorHasRequiredParameters,
          ),
        );
      }

      final buildMethod = members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((method) => method.name.lexeme == 'build');
      if (buildMethod == null) {
        errorReporter(
          RiverpodAnalysisError(
            'No "build" method found. '
            'Classes annotated with @riverpod must define a method named "build".',
            targetNode: this,
            code: RiverpodAnalysisErrorCode.missingNotifierBuild,
          ),
        );
        return null;
      }

      final providerElement = ClassBasedProviderDeclarationElement._parse(
        element,
      );
      if (providerElement == null) return null;

      final createdTypeNode = buildMethod.returnType;

      final exposedTypeNode = _computeExposedType(
        createdTypeNode,
        root.cast<CompilationUnit>()!,
      );
      if (exposedTypeNode == null) {
        // Error already reported
        return null;
      }

      final hasPersistAnnotation = metadata.any((e) {
        return e.annotationOfType(riverpodPersistType, exact: false) != null;
      });

      final valueTypeNode = _getValueType(createdTypeNode, element.library);
      final classBasedProviderDeclaration = ClassBasedProviderDeclaration._(
        name: name,
        node: this,
        buildMethod: buildMethod,
        providerElement: providerElement,
        annotation: riverpod,
        createdTypeNode: createdTypeNode,
        exposedTypeNode: exposedTypeNode,
        valueTypeNode: valueTypeNode,
        isPersisted: hasPersistAnnotation,
      );

      return classBasedProviderDeclaration;
    });
  }
}

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
    required this.isPersisted,
  }) : mutations = node.members
            .whereType<MethodDeclaration>()
            .map((e) => e.mutation)
            .nonNulls
            .toList();

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
  final List<Mutation> mutations;
  final bool isPersisted;
}

extension MutationMethodDeclarationX on MethodDeclaration {
  static final _cache = _Cache<Mutation?>();

  Mutation? get mutation {
    return _cache(this, () {
      final element = declaredElement;
      if (element == null) return null;

      final mutationElement = MutationElement._parse(element);
      if (mutationElement == null) return null;

      if (isStatic) {
        errorReporter(
          RiverpodAnalysisError(
            'Mutations cannot be static.',
            targetNode: this,
            targetElement: element,
            code: RiverpodAnalysisErrorCode.mutationIsStatic,
          ),
        );
        return null;
      }
      if (isAbstract) {
        errorReporter(
          RiverpodAnalysisError(
            'Mutations cannot be abstract.',
            targetNode: this,
            targetElement: element,
            code: RiverpodAnalysisErrorCode.mutationIsAbstract,
          ),
        );
        return null;
      }

      final expectedReturnType = thisOrAncestorOfType<ClassDeclaration>()!
          .members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((e) => e.name.lexeme == 'build')
          ?.returnType;
      if (expectedReturnType == null) return null;

      final expectedValueType = _getValueType(
        expectedReturnType,
        element.library,
      );
      if (expectedValueType == null) return null;

      final expectedType =
          element.library.typeProvider.futureOrElement.instantiate(
        typeArguments: [expectedValueType.type!],
        nullabilitySuffix: NullabilitySuffix.none,
      );

      final actualType = element.returnType;

      final isAssignable = element.library.typeSystem.isAssignableTo(
        actualType,
        expectedType,
        strictCasts: true,
      );
      if (!isAssignable) {
        errorReporter(
          RiverpodAnalysisError(
            'The return type of mutations must match the type returned by the "build" method.',
            targetNode: this,
            targetElement: element,
            code: RiverpodAnalysisErrorCode.mutationReturnTypeMismatch,
          ),
        );
        return null;
      }

      final mutation = Mutation._(
        node: this,
        element: mutationElement,
      );

      return mutation;
    });
  }
}

final class Mutation {
  Mutation._({
    required this.node,
    required this.element,
  });

  String get name => node.name.lexeme;
  final MethodDeclaration node;
  final MutationElement element;
}

class ClassBasedProviderDeclarationElement
    extends GeneratorProviderDeclarationElement {
  ClassBasedProviderDeclarationElement._({
    required this.name,
    required this.annotation,
    required this.buildMethod,
    required this.element,
  });

  static final _cache = _Cache<ClassBasedProviderDeclarationElement?>();

  static ClassBasedProviderDeclarationElement? _parse(ClassElement element) {
    return _cache(element, () {
      final riverpodAnnotation = RiverpodAnnotationElement._of(element);
      if (riverpodAnnotation == null) return null;

      final buildMethod =
          element.methods.firstWhereOrNull((method) => method.name == 'build');

      if (buildMethod == null) {
        errorReporter(
          RiverpodAnalysisError(
            'No "build" method found. '
            'Classes annotated with @riverpod must define a method named "build".',
            targetElement: element,
            code: RiverpodAnalysisErrorCode.missingNotifierBuild,
          ),
        );

        return null;
      }

      return ClassBasedProviderDeclarationElement._(
        name: element.name,
        buildMethod: buildMethod,
        element: element,
        annotation: riverpodAnnotation,
      );
    });
  }

  @override
  bool get isFamily {
    return buildMethod.parameters.isNotEmpty ||
        element.typeParameters.isNotEmpty;
  }

  @override
  final ClassElement element;

  @override
  final String name;

  @override
  final RiverpodAnnotationElement annotation;

  final ExecutableElement buildMethod;
}

class MutationElement {
  MutationElement._({
    required this.name,
    required this.method,
  });

  static final _cache = _Cache<MutationElement?>();

  static MutationElement? _parse(ExecutableElement element) {
    return _cache(element, () {
      final annotation = MutationAnnotationElement._of(element);
      if (annotation == null) return null;

      return MutationElement._(
        name: element.name,
        method: element,
      );
    });
  }

  final String name;
  final ExecutableElement method;
}
