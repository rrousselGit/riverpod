part of '../riverpod_ast.dart';

final class ProviderOverrideExpression {
  ProviderOverrideExpression._({
    required this.node,
    required this.providerElement,
    required this.provider,
    required this.familyArguments,
  });

  // ignore: prefer_constructors_over_static_methods
  static ProviderOverrideExpression _parse(CollectionElement expression) {
    SimpleIdentifier? provider;
    ProviderDeclarationElement? providerElement;
    ArgumentList? familyArguments;
    if (expression is Expression) {
      final parseResult = _parsesProviderExpression(expression);
      provider = parseResult?.provider;
      providerElement = parseResult?.providerElement;
      familyArguments = parseResult?.familyArguments;
    }

    return ProviderOverrideExpression._(
      node: expression,
      providerElement: providerElement,
      familyArguments: familyArguments,
      provider: provider,
    );
  }

  final CollectionElement node;
  final ProviderDeclarationElement? providerElement;
  final SimpleIdentifier? provider;

  /// If [provider] is a provider with arguments (family), represents the arguments
  /// passed to the provider.
  final ArgumentList? familyArguments;
}

final class ProviderOverrideList {
  ProviderOverrideList._({
    required this.node,
    required this.overrides,
  });

  static ProviderOverrideList? _parse(NamedExpression? expression) {
    if (expression == null) return null;
    final expressionValue = expression.expression;

    List<ProviderOverrideExpression>? overrides;
    if (expressionValue is ListLiteral) {
      overrides = expressionValue.elements
          .map(ProviderOverrideExpression._parse)
          .toList();
    }

    return ProviderOverrideList._(
      node: expression,
      overrides: overrides,
    );
  }

  final NamedExpression node;
  final List<ProviderOverrideExpression>? overrides;
}
