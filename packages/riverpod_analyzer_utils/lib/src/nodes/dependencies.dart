part of '../nodes.dart';

extension on CollectionElement {
  static final _cache = Expando<Box<ProviderDependency?>>();

  ProviderDependency? get providerDependency {
    return _cache.upsert(this, () {
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
  static final _cache = Expando<Box<ProviderDependencyList?>>();

  ProviderDependencyList? get providerDependencyList {
    return _cache.upsert(this, () {
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
        list.map((e) => e.toDependency(from: from)).nonNulls.toList();

    // If any dependency failed to parse, return null.
    // Errors should already have been reported
    if (values.length != list.length) return null;

    return values;
  }
}

final class AccumulatedDependency {
  AccumulatedDependency._({required this.node, required this.provider});

  final AstNode? node;
  final GeneratorProviderDeclarationElement provider;
}

sealed class AccumulatedDependencyNode {}

final class AccumulatedDependencyList {
  AccumulatedDependencyList._({
    required this.node,
    required this.riverpod,
    required this.dependencies,
    required this.widgetDependencies,
    required this.overrides,
  }) : parent = node.ancestors
            .map((e) => e.accumulatedDependencies)
            .nonNulls
            .firstOrNull;

  final AstNode node;
  final AccumulatedDependencyList? parent;
  final GeneratorProviderDeclaration? riverpod;
  final DependenciesAnnotation? dependencies;
  final List<GeneratorProviderDeclarationElement>? widgetDependencies;
  final ProviderScopeInstanceCreationExpression? overrides;

  Iterable<AccumulatedDependency>? get allDependencies {
    final dependencies = this.dependencies?.dependencies;
    final riverpod = this.riverpod?.annotation.dependencyList;
    final widgetDependencies = this.widgetDependencies;

    if (dependencies == null &&
        riverpod == null &&
        widgetDependencies == null) {
      return null;
    }

    final dependenciesValues = dependencies?.values?.map(
      (e) => AccumulatedDependency._(
        node: e.node,
        provider: e.provider,
      ),
    );
    final riverpodValues = riverpod?.values?.map(
      (e) => AccumulatedDependency._(
        node: e.node,
        provider: e.provider,
      ),
    );
    final dependenciesElementValues = widgetDependencies?.map(
      (provider) => AccumulatedDependency._(
        node: null,
        provider: provider,
      ),
    );

    return (dependenciesValues ?? const [])
        .followedBy(riverpodValues ?? const [])
        .followedBy(dependenciesElementValues ?? const []);
  }

  Iterable<ProviderOverrideExpression> get _overridesIncludingParents sync* {
    if (overrides?.overrides?.overrides case final overrides?) {
      yield* overrides;
    }

    if (parent case final parent?) yield* parent._overridesIncludingParents;
  }

  late final Set<ProviderDeclarationElement> _allOverrides =
      _overridesIncludingParents
          // If we are overriding only one part of a family,
          // we can't guarantee that later reads will point to the override.
          // So we ignore those overrides when considering if a provider is
          // safe to use.
          .where((e) => e.familyArguments == null)
          .map((e) => e.provider?.providerElement)
          .nonNulls
          .toSet();

  bool isSafelyAccessibleAfterOverrides(
    GeneratorProviderDeclarationElement provider,
  ) {
    final dependencies = provider.annotation.dependencies;
    if (dependencies == null) return true;

    if (_allOverrides.contains(provider)) return true;

    // If the provider has an empty list of dependencies, and it is not overridden,
    // then it is not safe to use.
    if (dependencies.isEmpty) return false;

    return dependencies.every(isSafelyAccessibleAfterOverrides);
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
  static final _cache = Expando<Box<AccumulatedDependencyList?>>();

  AccumulatedDependencyList? get accumulatedDependencies {
    return _cache.upsert(this, () {
      final providerScope = this.providerScope;
      if (providerScope == null) return null;

      return AccumulatedDependencyList._(
        node: this,
        overrides: providerScope,
        dependencies: null,
        riverpod: null,
        widgetDependencies: null,
      );
    });
  }
}

extension on AnnotatedNode {
  static final _cache = Expando<Box<AccumulatedDependencyList?>>();

  AccumulatedDependencyList? get accumulatedDependencies {
    return _cache.upsert(this, () {
      final provider = cast<Declaration>()?.provider;
      // Have State inherit dependencies from its widget
      final state = cast<ClassDeclaration>()?.state;

      if (provider == null &&
          dependencies == null &&
          state == null &&
          // Always initialize root declarations,
          // to handle cases where a method in a class has @Dependencies
          // but the class itself does not.
          this is! CompilationUnitMember) {
        return null;
      }

      return AccumulatedDependencyList._(
        node: this,
        overrides: null,
        dependencies: dependencies,
        riverpod: provider,
        widgetDependencies: state?.widget?.dependencies?.dependencies,
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
  static final _cache = Expando<Box<IdentifierDependencies?>>();

  IdentifierDependencies? get identifierDependencies {
    return _cache.upsert(this, () {
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
  static final _cache = Expando<Box<NamedTypeDependencies?>>();

  NamedTypeDependencies? get typeAnnotationDependencies {
    return _cache.upsert(this, () {
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
  static final _cache = Expando<Box<DependenciesAnnotation?>>();

  DependenciesAnnotation? get dependencies {
    return _cache.upsert(this, () {
      return metadata.map((e) => e.dependencies).nonNulls.firstOrNull;
    });
  }
}

@_ast
extension DependenciesAnnotatedAnnotatedNodeX on Annotation {
  static final _cache = Expando<Box<DependenciesAnnotation?>>();

  DependenciesAnnotation? get dependencies {
    return _cache.upsert(this, () {
      final elementAnnotation = annotationOfType(dependenciesType, exact: true);
      if (elementAnnotation == null) return null;

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
    return element.metadata.map(_parse).nonNulls.firstOrNull;
  }

  final ElementAnnotation element;
  final List<GeneratorProviderDeclarationElement>? dependencies;
}
