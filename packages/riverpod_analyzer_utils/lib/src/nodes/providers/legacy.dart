part of '../../nodes.dart';

final class LegacyProviderDependencies {
  LegacyProviderDependencies._({
    required this.dependencies,
    required this.node,
  });

  static LegacyProviderDependencies? _parse(NamedExpression? dependenciesNode) {
    if (dependenciesNode == null) return null;

    final value = dependenciesNode.expression;

    List<LegacyProviderDependency>? dependencies;
    if (value is ListLiteral) {
      dependencies =
          value.elements.map(LegacyProviderDependency._parse).toList();
    }

    return LegacyProviderDependencies._(
      node: dependenciesNode,
      dependencies: dependencies,
    );
  }

  final List<LegacyProviderDependency>? dependencies;
  final NamedExpression node;
}

final class LegacyProviderDependency {
  LegacyProviderDependency._({
    required this.node,
    required this.provider,
  });

  factory LegacyProviderDependency._parse(CollectionElement node) {
    final provider =
        node.cast<Expression>().let(ProviderOrFamilyExpression._parse);

    return LegacyProviderDependency._(
      node: node,
      provider: provider,
    );
  }

  final CollectionElement node;
  final ProviderOrFamilyExpression? provider;
}

@_ast
extension LegacyProviderDeclarationX on VariableDeclaration {
  static final _cache = Expando<Box<LegacyProviderDeclaration?>>();

  LegacyProviderDeclaration? get provider {
    return _cache.upsert(this, () {
      final element = declaredFragment?.element;
      if (element == null) return null;

      final providerElement = LegacyProviderDeclarationElement._parse(element);
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
        provider = initializer.constructorName.type.name2;
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

      final dependenciesElement = arguments
          .namedArguments()
          .firstWhereOrNull((e) => e.name.label.name == 'dependencies');
      final dependencies =
          LegacyProviderDependencies._parse(dependenciesElement);

      return LegacyProviderDeclaration._(
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

final class LegacyProviderDeclaration implements ProviderDeclaration {
  LegacyProviderDeclaration._({
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

  final LegacyProviderDependencies? dependencies;

  final FunctionExpression build;
  final ArgumentList argumentList;
  final SyntacticEntity provider;
  final SimpleIdentifier? autoDisposeModifier;
  final SimpleIdentifier? familyModifier;
  final TypeArgumentList? typeArguments;

  @override
  final LegacyProviderDeclarationElement providerElement;

  @override
  final Token name;

  @override
  final VariableDeclaration node;
}

/// The class name for explicitly typed provider.
///
/// Such as `FutureProvider` for `final provider = FutureProvider(...)`.
/// This is only about the type, and does not include autoDispose/family/...
enum LegacyProviderType {
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
  notifierProvider;
}

@internal
LegacyProviderType? parseLegacyProviderType(DartType type) {
  if (!isFromRiverpod.isExactlyType(type) &&
      !isFromFlutterRiverpod.isExactlyType(type)) {
    return null;
  }

  final name = type.element3?.name3;
  if (name == 'FutureProvider' || name == 'FutureProviderFamily') {
    return LegacyProviderType.futureProvider;
  }
  if (name == 'StreamProvider' || name == 'StreamProviderFamily') {
    return LegacyProviderType.streamProvider;
  }
  if (name == 'StreamNotifierProvider' ||
      name == 'StreamNotifierProviderFamily') {
    return LegacyProviderType.streamNotifier;
  }
  if (name == 'StateProvider' || name == 'StateProviderFamily') {
    return LegacyProviderType.stateProvider;
  }
  if (name == 'StateNotifierProvider' ||
      name == 'StateNotifierProviderFamily') {
    return LegacyProviderType.stateNotifierProvider;
  }
  if (name == 'Provider' || name == 'ProviderFamily') {
    return LegacyProviderType.provider;
  }
  if (name == 'NotifierProvider' || name == 'NotifierProviderFamily') {
    return LegacyProviderType.notifierProvider;
  }
  if (name == 'AsyncNotifierProvider' ||
      name == 'AsyncNotifierProviderFamily') {
    return LegacyProviderType.asyncNotifierProvider;
  }
  if (name == 'ChangeNotifierProvider' ||
      name == 'ChangeNotifierProviderFamily') {
    return LegacyProviderType.changeNotifierProvider;
  }

  return null;
}

class LegacyProviderDeclarationElement implements ProviderDeclarationElement {
  LegacyProviderDeclarationElement._({
    required this.name,
    required this.element,
    required this.familyElement,
    required this.providerType,
  });

  static LegacyProviderDeclarationElement? _parse(VariableElement2 element) {
    return _cache(element, () {
      final type = element.type;
      final providerType = parseLegacyProviderType(type);
      // Not a legacy provider
      if (providerType == null) return null;

      LegacyFamilyInvocationElement? familyElement;
      if (familyType.isAssignableFromType(element.type)) {
        final callFn = (element.type as InterfaceType).lookUpMethod3(
          'call',
          element.library2!,
        )!;
        final parameter = callFn.formalParameters.single;

        familyElement = LegacyFamilyInvocationElement._(parameter.type);
      }

      return LegacyProviderDeclarationElement._(
        name: element.name3!,
        element: element,
        familyElement: familyElement,
        providerType: providerType,
      );
    });
  }

  static final _cache = _Cache<LegacyProviderDeclarationElement?>();

  @override
  final VariableElement2 element;

  @override
  final String name;

  final LegacyFamilyInvocationElement? familyElement;

  final LegacyProviderType providerType;
}

class LegacyFamilyInvocationElement {
  LegacyFamilyInvocationElement._(this.parameterType);
  final DartType parameterType;
}
