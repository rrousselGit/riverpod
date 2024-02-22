part of '../../nodes.dart';

@_ast
extension ClassBasedProviderDeclarationX on ClassDeclaration {
  ClassBasedProviderDeclaration? get provider {
    return upsert('ClassBasedProviderDeclaration', () {
      final element = declaredElement;
      if (element == null) return null;

      final riverpod = this.riverpod;
      if (riverpod == null) return null;

      // TODO changelog report error if abstract
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
      // TODO changelog report error if default constructor is missing
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
  });

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
