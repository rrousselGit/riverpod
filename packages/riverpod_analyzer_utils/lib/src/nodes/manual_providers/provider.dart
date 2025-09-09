part of '../../nodes.dart';

final class ManualProviderDependencies {
  ManualProviderDependencies._({
    required this.dependencies,
    required this.node,
  });

  static ManualProviderDependencies? _parse(NamedExpression? dependenciesNode) {
    if (dependenciesNode == null) return null;

    final value = dependenciesNode.expression;

    List<ManualProviderDependency>? dependencies;
    if (value is ListLiteral) {
      dependencies = value.elements
          .map(ManualProviderDependency._parse)
          .toList();
    }

    return ManualProviderDependencies._(
      node: dependenciesNode,
      dependencies: dependencies,
    );
  }

  final List<ManualProviderDependency>? dependencies;
  final NamedExpression node;
}

final class ManualProviderDependency {
  ManualProviderDependency._({required this.node, required this.provider});

  factory ManualProviderDependency._parse(CollectionElement node) {
    final provider = node.cast<Expression>().let(
      ProviderOrFamilyExpression._parse,
    );

    return ManualProviderDependency._(node: node, provider: provider);
  }

  final CollectionElement node;
  final ProviderOrFamilyExpression? provider;
}

@_ast
extension LegacyProviderDeclarationX on VariableDeclaration {
  static final _cache = Expando<Box<ManualProviderDeclaration?>>();

  ManualProviderDeclaration? get provider {
    return _cache.upsert(this, () {
      final element = declaredFragment?.element;
      if (element == null) return null;

      final providerElement = ManualProviderDeclarationElement._parse(element);
      if (providerElement == null) return null;

      final initializer = this.initializer;
      ArgumentList? arguments;
      late SyntacticEntity provider;
      SimpleIdentifier? autoDisposeModifier;
      SimpleIdentifier? familyModifier;
      TypeArgumentList? typeArguments;
      if (initializer is InstanceCreationExpression) {
        // Provider((ref) => ...)

        arguments = initializer.argumentList;
        provider = initializer.constructorName.type.name;
        typeArguments = initializer.constructorName.type.typeArguments;
      } else if (initializer is FunctionExpressionInvocation) {
        // Provider.modifier()

        void decodeIdentifier(SimpleIdentifier identifier) {
          switch (identifier.name) {
            case 'autoDispose':
              autoDisposeModifier = identifier;
            case 'family':
              familyModifier = identifier;
            default:
              provider = identifier;
          }
        }

        void decodeTarget(Expression? expression) {
          if (expression is SimpleIdentifier) {
            decodeIdentifier(expression);
          } else if (expression is PrefixedIdentifier) {
            decodeIdentifier(expression.identifier);
            decodeIdentifier(expression.prefix);
          } else {
            throw UnsupportedError(
              'unknown expression "$expression" (${expression.runtimeType})',
            );
          }
        }

        final modifier = initializer.function;
        if (modifier is! PropertyAccess) return null;

        decodeIdentifier(modifier.propertyName);
        decodeTarget(modifier.target);
        arguments = initializer.argumentList;
        typeArguments = initializer.typeArguments;
      } else {
        // Invalid provider expression.
        // Such as "final provider = variable;"
        return null;
      }

      final build = arguments.positionalArguments().firstOrNull;
      if (build is! FunctionExpression) return null;

      final dependenciesElement = arguments.namedArguments().firstWhereOrNull(
        (e) => e.name.label.name == 'dependencies',
      );
      final dependencies = ManualProviderDependencies._parse(
        dependenciesElement,
      );

      return ManualProviderDeclaration._(
        name: name,
        node: this,
        build: build,
        providerElement: providerElement,
        argumentList: arguments,
        typeArguments: typeArguments,
        provider: provider,
        autoDisposeModifier: autoDisposeModifier,
        familyModifier: familyModifier,
        dependencies: dependencies,
      );
    });
  }
}

final class ManualProviderDeclaration implements ProviderDeclaration {
  ManualProviderDeclaration._({
    required this.name,
    required this.node,
    required this.build,
    required this.typeArguments,
    required this.providerElement,
    required this.argumentList,
    required this.provider,
    required this.autoDisposeModifier,
    required this.familyModifier,
    required this.dependencies,
  });

  final ManualProviderDependencies? dependencies;

  final FunctionExpression build;
  final ArgumentList argumentList;
  final SyntacticEntity provider;
  final SimpleIdentifier? autoDisposeModifier;
  final SimpleIdentifier? familyModifier;
  final TypeArgumentList? typeArguments;

  @override
  final ManualProviderDeclarationElement providerElement;

  @override
  final Token name;

  @override
  final VariableDeclaration node;
}

/// The class name for explicitly typed provider.
///
/// Such as `FutureProvider` for `final provider = FutureProvider(...)`.
/// This is only about the type, and does not include autoDispose/family/...
enum ManualProviderType {
  /// Type for `ChangeNotifierProvider`
  changeNotifierProvider,

  /// Type for `FutureProvider`
  futureProvider,

  /// Type for `AsyncNotifierProvider`
  asyncNotifierProvider,

  /// Type for `StreamProvider`
  streamProvider,

  /// Type for `StreamNotifier`
  streamNotifier,

  /// Type for `StateNotifierProvider`
  stateNotifierProvider,

  /// Type for `StateProvider`
  stateProvider,

  /// Type for `Provider`
  provider,

  /// Type for `NotifierProvider`
  notifierProvider,
}

@internal
ManualProviderType? parseLegacyProviderType(DartType type) {
  if (!isFromRiverpod.isExactlyType(type) &&
      !isFromFlutterRiverpod.isExactlyType(type)) {
    return null;
  }

  final name = type.element?.name;
  if (name == 'FutureProvider' || name == 'FutureProviderFamily') {
    return ManualProviderType.futureProvider;
  }
  if (name == 'StreamProvider' || name == 'StreamProviderFamily') {
    return ManualProviderType.streamProvider;
  }
  if (name == 'StreamNotifierProvider' ||
      name == 'StreamNotifierProviderFamily') {
    return ManualProviderType.streamNotifier;
  }
  if (name == 'StateProvider' || name == 'StateProviderFamily') {
    return ManualProviderType.stateProvider;
  }
  if (name == 'StateNotifierProvider' ||
      name == 'StateNotifierProviderFamily') {
    return ManualProviderType.stateNotifierProvider;
  }
  if (name == 'Provider' || name == 'ProviderFamily') {
    return ManualProviderType.provider;
  }
  if (name == 'NotifierProvider' || name == 'NotifierProviderFamily') {
    return ManualProviderType.notifierProvider;
  }
  if (name == 'AsyncNotifierProvider' ||
      name == 'AsyncNotifierProviderFamily') {
    return ManualProviderType.asyncNotifierProvider;
  }
  if (name == 'ChangeNotifierProvider' ||
      name == 'ChangeNotifierProviderFamily') {
    return ManualProviderType.changeNotifierProvider;
  }

  return null;
}

class ManualProviderDeclarationElement implements ProviderDeclarationElement {
  ManualProviderDeclarationElement._({
    required this.name,
    required this.element,
    required this.familyElement,
    required this.providerType,
  });

  static ManualProviderDeclarationElement? _parse(VariableElement element) {
    return _cache(element, () {
      final type = element.type;
      final providerType = parseLegacyProviderType(type);
      // Not a legacy provider
      if (providerType == null) return null;

      ManualFamilyInvocationElement? familyElement;
      if (familyType.isAssignableFromType(element.type)) {
        final callFn = (element.type as InterfaceType).lookUpMethod(
          'call',
          element.library!,
        )!;
        final parameter = callFn.formalParameters.single;

        familyElement = ManualFamilyInvocationElement._(parameter.type);
      }

      return ManualProviderDeclarationElement._(
        name: element.name!,
        element: element,
        familyElement: familyElement,
        providerType: providerType,
      );
    });
  }

  static final _cache = _Cache<ManualProviderDeclarationElement?>();

  @override
  final VariableElement element;

  @override
  final String name;

  final ManualFamilyInvocationElement? familyElement;

  final ManualProviderType providerType;
}

class ManualFamilyInvocationElement {
  ManualFamilyInvocationElement._(this.parameterType);
  final DartType parameterType;
}
