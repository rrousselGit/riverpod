part of '../nodes.dart';

extension on CollectionElement {
  ProviderDependency? get providerDependency {
    return upsert('ProviderDependency', () {
      final that = this;
      if (that is! Expression) {
        errorReporter(
          RiverpodAnalysisError(
            'if/for/spread operators as not supported.',
            targetNode: that,
            code: RiverpodAnalysisErrorCode.providerDependencyListParseError,
          ),
        );
        return null;
      }

      if (that is! SimpleIdentifier) {
        errorReporter(
          RiverpodAnalysisError(
            'Only elements annotated with @riverpod are supported.',
            targetNode: that,
            code: RiverpodAnalysisErrorCode.providerDependencyListParseError,
          ),
        );
        return null;
      }

      final dependencyElement = that.staticElement;
      if (dependencyElement is FunctionElement) {
        final dependencyProvider = FunctionalProviderDeclarationElement._parse(
          dependencyElement,
        );

        if (dependencyProvider != null) {
          return ProviderDependency._(provider: dependencyProvider, node: that);
        }

        errorReporter(
          RiverpodAnalysisError(
            'The dependency $that is not a function annotated with @riverpod',
            targetNode: that,
            code: RiverpodAnalysisErrorCode.providerDependencyListParseError,
          ),
        );
        return null;
      }

      if (dependencyElement is ClassElement) {
        final dependencyProvider = ClassBasedProviderDeclarationElement._parse(
          dependencyElement,
        );

        if (dependencyProvider != null) {
          return ProviderDependency._(provider: dependencyProvider, node: that);
        }

        errorReporter(
          RiverpodAnalysisError(
            'The dependency $that is not a class annotated with @riverpod',
            targetNode: that,
            code: RiverpodAnalysisErrorCode.providerDependencyListParseError,
          ),
        );
        return null;
      }

      errorReporter(
        RiverpodAnalysisError(
          'Only elements annotated with @riverpod are supported.',
          targetNode: that,
          code: RiverpodAnalysisErrorCode.providerDependencyListParseError,
        ),
      );
      return null;
    });
  }
}

final class ProviderDependency {
  ProviderDependency._({
    required this.node,
    required this.provider,
  });

  final CollectionElement node;
  final GeneratorProviderDeclarationElement provider;
}

extension on Expression {
  ProviderDependencyList? get providerDependencyList {
    return upsert('ProviderDependencyList', () {
      final that = this;
      // explicit null, count as valid value (no dependencies)
      if (that is NullLiteral) {
        return ProviderDependencyList._(node: null, values: null);
      }

      if (that is! ListLiteral) {
        errorReporter(
          RiverpodAnalysisError(
            'Only list literals (using []) as supported.',
            targetNode: that,
            code: RiverpodAnalysisErrorCode.providerDependencyListParseError,
          ),
        );
        return null;
      }

      return ProviderDependencyList._(
        node: that,
        values: that.elements
            .map((e) => e.providerDependency)
            .whereType<ProviderDependency>()
            .toList(),
      );
    });
  }
}

final class ProviderDependencyList {
  ProviderDependencyList._({
    required this.node,
    required this.values,
  });

  final ListLiteral? node;
  final List<ProviderDependency>? values;
}

extension on DartObject {
  /// An element in `@Riverpod(dependencies: [a, b])` or equivalent.
  GeneratorProviderDeclarationElement? toDependency({
    required Element? from,
  }) {
    final functionType = toFunctionValue();
    if (functionType != null) {
      final provider = FunctionalProviderDeclarationElement._parse(
        functionType,
      );

      if (provider != null) return provider;
    }

    final type = toTypeValue();
    if (type != null) {
      final provider = ClassBasedProviderDeclarationElement._parse(
        type.element! as ClassElement,
      );

      if (provider != null) return provider;
    }

    errorReporter(
      RiverpodAnalysisError(
        'Unsupported dependency "${functionType ?? type ?? this}". '
        'Only functions and classes annotated by @riverpod are supported.',
        targetElement: from,
        code: RiverpodAnalysisErrorCode.providerDependencyListParseError,
      ),
    );
    return null;
  }

  /// The list passed to `@Riverpod(dependencies: [a, b])` or equivalent.
  List<GeneratorProviderDeclarationElement>? toDependencyList({
    required Element? from,
  }) {
    final list = toListValue();
    if (list == null) {
      return null;
    }

    final values =
        list.map((e) => e.toDependency(from: from)).whereNotNull().toList();

    // If any dependency failed to parse, return null.
    // Errors should already have been reported
    if (values.length != list.length) return null;

    return values;
  }
}

sealed class Location {}

class LocationNode implements Location {
  LocationNode(this.node);
  final AstNode node;
}

class LocationElement implements Location {
  LocationElement(this.element);
  final Element element;
}

final class AccumulatedDependency {
  AccumulatedDependency._({required this.location, required this.provider});

  final Location location;
  final GeneratorProviderDeclarationElement provider;
}

sealed class AccumulatedDependencyNode {}

final class AccumulatedDependencyList {
  AccumulatedDependencyList._({
    required this.node,
    required this.riverpod,
    required this.dependencies,
    required this.dependenciesElement,
    required this.overrides,
  }) : parent = node.ancestors
            .map((e) => e.accumulatedDependencies)
            .whereNotNull()
            .firstOrNull;

  final AstNode node;
  final AccumulatedDependencyList? parent;
  final GeneratorProviderDeclaration? riverpod;
  final DependenciesAnnotation? dependencies;
  final DependenciesAnnotationElement? dependenciesElement;
  final ProviderScopeInstanceCreationExpression? overrides;

  Iterable<AccumulatedDependency>? get allDependencies {
    final dependencies = this.dependencies?.dependencies;
    final riverpod = this.riverpod?.annotation.dependencyList;
    final dependenciesElement = this.dependenciesElement?.dependencies;

    if (dependencies == null &&
        riverpod == null &&
        dependenciesElement == null) {
      return null;
    }

    final dependenciesValues = dependencies?.values?.map(
      (e) => AccumulatedDependency._(
        location: LocationNode(e.node),
        provider: e.provider,
      ),
    );
    final riverpodValues = riverpod?.values?.map(
      (e) => AccumulatedDependency._(
        location: LocationNode(e.node),
        provider: e.provider,
      ),
    );
    final dependenciesElementValues = dependenciesElement?.map(
      (provider) => AccumulatedDependency._(
        location: LocationElement(this.dependenciesElement!.element.element!),
        provider: provider,
      ),
    );

    return (dependenciesValues ?? const [])
        .followedBy(riverpodValues ?? const [])
        .followedBy(dependenciesElementValues ?? const []);
  }

  Iterable<ProviderOverrideExpression> get overridesIncludingParents sync* {
    if (overrides?.overrides?.overrides case final overrides?) {
      yield* overrides;
    }

    if (parent case final parent?) yield* parent.overridesIncludingParents;
  }
}

@_ast
extension AccumulatedDependenciesX on AstNode {
  AccumulatedDependencyList? get accumulatedDependencies {
    final that = this;
    switch (that) {
      case InstanceCreationExpression():
        return that.accumulatedDependencies;
      case AnnotatedNode():
        return that.accumulatedDependencies;
      default:
        return null;
    }
  }
}

extension on InstanceCreationExpression {
  AccumulatedDependencyList? get accumulatedDependencies {
    return upsert('InstanceCreationExpression#accumulatedDependencies', () {
      final providerScope = this.providerScope;
      if (providerScope == null) return null;

      return AccumulatedDependencyList._(
        node: this,
        overrides: providerScope,
        dependencies: null,
        riverpod: null,
        dependenciesElement: null,
      );
    });
  }
}

extension on AnnotatedNode {
  AccumulatedDependencyList? get accumulatedDependencies {
    return upsert('#AnnotatedNodeAccumulatedDependencies', () {
      final provider = cast<Declaration>()?.provider;
      // Have State inherit dependencies from its widget
      final state = cast<ClassDeclaration>()?.state;

      if (provider == null &&
          dependencies == null &&
          state == null &&
          // Always initialize root declarations,
          // to handle cases where a method in a class has @Dependencies
          // but the class itself does not.
          this is! CompilationUnitMember) return null;

      return AccumulatedDependencyList._(
        node: this,
        overrides: null,
        dependencies: dependencies,
        riverpod: provider,
        dependenciesElement: state?.widget?.dependencies,
      );
    });
  }
}

class IdentifierDependencies {
  IdentifierDependencies._({required this.node, required this.dependencies});

  final Identifier node;
  final DependenciesAnnotationElement dependencies;
}

@_ast
extension IdentifierDependenciesX on Identifier {
  IdentifierDependencies? get identifierDependencies {
    return upsert('Identifier#identifierDependencies', () {
      final staticElement = this.staticElement;
      if (staticElement == null) return null;

      final dependencies = DependenciesAnnotationElement._of(staticElement);
      if (dependencies == null) return null;

      return IdentifierDependencies._(node: this, dependencies: dependencies);
    });
  }
}

class NamedTypeDependencies {
  NamedTypeDependencies._({
    required this.node,
    required this.dependencies,
  });

  final NamedType node;
  final DependenciesAnnotationElement dependencies;
}

@_ast
extension NamedTypeDependenciesX on NamedType {
  NamedTypeDependencies? get typeAnnotationDependencies {
    return upsert('NamedType#typeAnnotationDependencies', () {
      final staticElement = type?.element;
      if (staticElement == null) return null;

      final dependencies = DependenciesAnnotationElement._of(staticElement);
      if (dependencies == null) return null;

      return NamedTypeDependencies._(
        node: this,
        dependencies: dependencies,
      );
    });
  }
}

extension DependenciesAnnotatedAnnotatedNodeOfX on AnnotatedNode {
  DependenciesAnnotation? get dependencies {
    return upsert('DependenciesAnnotationAnnotatedNodeX', () {
      return metadata.map((e) => e.dependencies).whereNotNull().firstOrNull;
    });
  }
}

@_ast
extension DependenciesAnnotatedAnnotatedNodeX on Annotation {
  DependenciesAnnotation? get dependencies {
    return upsert('DependenciesAnnotation', () {
      final elementAnnotation = this.elementAnnotation;
      final element = this.element;
      if (element == null || elementAnnotation == null) return null;
      if (element is! ExecutableElement ||
          !dependenciesType.isExactlyType(element.returnType)) {
        // The annotation is not an @Dependencies
        return null;
      }

      final dependenciesElement = DependenciesAnnotationElement._parse(
        elementAnnotation,
      );
      if (dependenciesElement == null) return null;

      final dependenciesNode = arguments?.positional(0);
      // Required argument missing. There should be a compilation error already.
      if (dependenciesNode == null) return null;

      final dependencyList = dependenciesNode.providerDependencyList;
      // No valid dependencies arg found. There should already be an error reported.
      if (dependencyList == null) return null;

      return DependenciesAnnotation._(
        node: this,
        dependencies: dependencyList,
        dependenciesNode: dependenciesNode,
        element: dependenciesElement,
      );
    });
  }
}

final class DependenciesAnnotation {
  DependenciesAnnotation._({
    required this.dependencies,
    required this.node,
    required this.dependenciesNode,
    required this.element,
  });

  final Annotation node;
  final ProviderDependencyList dependencies;
  final Expression dependenciesNode;
  final DependenciesAnnotationElement element;
}

final class DependenciesAnnotationElement {
  DependenciesAnnotationElement._({
    required this.dependencies,
    required this.element,
  });

  static final _cache = _Cache<DependenciesAnnotationElement?>();

  static DependenciesAnnotationElement? _parse(ElementAnnotation element) {
    return _cache(element, () {
      final type = element.element.cast<ExecutableElement>()?.returnType;
      if (type == null || !dependenciesType.isExactlyType(type)) return null;

      final dependencies =
          element.computeConstantValue()?.getField('dependencies');
      if (dependencies == null) return null;

      final dependencyList = dependencies.toDependencyList(
        from: element.element,
      );

      return DependenciesAnnotationElement._(
        element: element,
        dependencies: dependencyList,
      );
    });
  }

  static DependenciesAnnotationElement? _of(Element element) {
    return element.metadata.map(_parse).whereNotNull().firstOrNull;
  }

  final ElementAnnotation element;
  final List<GeneratorProviderDeclarationElement>? dependencies;
}
