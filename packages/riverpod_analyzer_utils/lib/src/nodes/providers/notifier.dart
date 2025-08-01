part of '../../nodes.dart';

@_ast
extension ClassBasedProviderDeclarationX on ClassDeclaration {
  static final _cache = Expando<Box<ClassBasedProviderDeclaration?>>();

  ClassBasedProviderDeclaration? get provider {
    return _cache.upsert(this, () {
      final element = declaredFragment?.element;
      if (element == null) return null;

      final riverpod = this.riverpod;
      if (riverpod == null) return null;

      if (abstractKeyword != null) {
        errorReporter(
          RiverpodAnalysisError.ast(
            'Classes annotated with @riverpod cannot be abstract.',
            targetNode: this,
            code: RiverpodAnalysisErrorCode.abstractNotifier,
          ),
        );
      }

      final constructors = members.whereType<ConstructorDeclaration>().toList();
      final defaultConstructor = constructors
          .firstWhereOrNull((constructor) => constructor.name == null);
      if (defaultConstructor == null && constructors.isNotEmpty) {
        errorReporter(
          RiverpodAnalysisError.ast(
            'Classes annotated with @riverpod must have a default constructor.',
            targetNode: this,
            code: RiverpodAnalysisErrorCode.missingNotifierDefaultConstructor,
          ),
        );
      }
      if (defaultConstructor != null &&
          defaultConstructor.parameters.parameters.any((e) => e.isRequired)) {
        errorReporter(
          RiverpodAnalysisError.ast(
            'The default constructor of classes annotated with @riverpod '
            'cannot have required parameters.',
            targetNode: this,
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
          RiverpodAnalysisError.ast(
            'No "build" method found. '
            'Classes annotated with @riverpod must define a method named "build".',
            targetNode: this,
            code: RiverpodAnalysisErrorCode.missingNotifierBuild,
          ),
        );
        return null;
      }

      final providerElement =
          ClassBasedProviderDeclarationElement._parse(element, this);
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

      final valueTypeNode = _getValueType(createdTypeNode);
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
  final bool isPersisted;
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

  static ClassBasedProviderDeclarationElement? _parse(
    ClassElement2 element,
    AstNode from,
  ) {
    return _cache(element, () {
      final riverpodAnnotation = RiverpodAnnotationElement._of(element, from);
      if (riverpodAnnotation == null) return null;

      final buildMethod = element.methods2
          .firstWhereOrNull((method) => method.name3 == 'build');

      if (buildMethod == null) {
        errorReporter(
          RiverpodAnalysisError.ast(
            'No "build" method found. '
            'Classes annotated with @riverpod must define a method named "build".',
            targetNode: from,
            code: RiverpodAnalysisErrorCode.missingNotifierBuild,
          ),
        );

        return null;
      }

      return ClassBasedProviderDeclarationElement._(
        name: element.name3!,
        buildMethod: buildMethod,
        element: element,
        annotation: riverpodAnnotation,
      );
    });
  }

  @override
  bool get isFamily {
    return buildMethod.formalParameters.isNotEmpty ||
        element.typeParameters2.isNotEmpty;
  }

  @override
  final ClassElement2 element;

  @override
  final String name;

  @override
  final RiverpodAnnotationElement annotation;

  final ExecutableElement2 buildMethod;
}
