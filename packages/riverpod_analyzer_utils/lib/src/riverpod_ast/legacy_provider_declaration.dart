part of '../riverpod_ast.dart';

final class LegacyProviderDependencies extends RiverpodAst
    with _$LegacyProviderDependencies {
  LegacyProviderDependencies._({
    required this.dependencies,
    required this.dependenciesNode,
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
      dependenciesNode: dependenciesNode,
      dependencies: dependencies,
    );
  }

  @override
  final List<LegacyProviderDependency>? dependencies;
  final NamedExpression dependenciesNode;
}

final class LegacyProviderDependency extends RiverpodAst
    with _$LegacyProviderDependency
    implements ProviderListenableExpressionParent {
  LegacyProviderDependency._({
    required this.node,
    required this.provider,
  });

  factory LegacyProviderDependency._parse(CollectionElement node) {
    final provider =
        node.cast<Expression>().let(ProviderListenableExpression._parse);

    return LegacyProviderDependency._(
      node: node,
      provider: provider,
    );
  }

  final CollectionElement node;
  @override
  final ProviderListenableExpression? provider;
}

final class LegacyProviderDeclaration extends RiverpodAst
    with _$LegacyProviderDeclaration
    implements ProviderDeclaration {
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

  static LegacyProviderDeclaration? _parse(VariableDeclaration node) {
    final element = node.declaredElement;
    if (element == null) return null;

    final providerElement = LegacyProviderDeclarationElement.parse(element);
    if (providerElement == null) return null;

    final initializer = node.initializer;
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
    final dependencies = LegacyProviderDependencies._parse(dependenciesElement);

    return LegacyProviderDeclaration._(
      name: node.name,
      node: node,
      build: build,
      providerElement: providerElement,
      argumentList: arguments,
      typeArguments: typeArguments,
      provider: provider,
      autoDisposeModifier: autoDisposeModifier,
      familyModifier: familyModifier,
      dependencies: dependencies,
    );
  }

  @override
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
