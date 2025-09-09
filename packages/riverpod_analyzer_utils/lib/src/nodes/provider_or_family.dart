part of '../nodes.dart';

({
  ProviderIdentifier? provider,
  SimpleIdentifier? providerPrefix,
  ArgumentList? familyArguments,
})?
_parsesProviderExpression(Expression? expression) {
  ProviderIdentifier? provider;
  SimpleIdentifier? providerPrefix;
  ArgumentList? familyArguments;

  void parseExpression(Expression? expression) {
    // Can be reached when the code contains syntax errors
    if (expression == null) return;
    if (expression is SimpleIdentifier) {
      // watch(expression)
      provider = expression.provider;
    } else if (expression is FunctionExpressionInvocation) {
      // watch(expression())
      familyArguments = expression.argumentList;
      parseExpression(expression.function);
    } else if (expression is MethodInvocation) {
      // watch(expression.method())
      parseExpression(expression.target);
    } else if (expression is PrefixedIdentifier) {
      // watch(expression.modifier)
      final element = expression.prefix.element;
      if (element is PrefixElement) {
        providerPrefix = expression.prefix;
        parseExpression(expression.identifier);
      } else {
        parseExpression(expression.prefix);
      }
    } else if (expression is IndexExpression) {
      // watch(expression[])
      parseExpression(expression.target);
    } else if (expression is PropertyAccess) {
      // watch(expression.property)
      parseExpression(expression.target);
    }
  }

  parseExpression(expression);

  return (
    provider: provider,
    providerPrefix: providerPrefix,
    familyArguments: provider != null ? familyArguments : null,
  );
}

final class ProviderOrFamilyExpression {
  ProviderOrFamilyExpression._({
    required this.node,
    required this.provider,
    required this.providerPrefix,
    required this.familyArguments,
  });

  static ProviderOrFamilyExpression? _parse(Expression? expression) {
    if (expression == null) return null;

    final returnType = expression.staticType;
    if (returnType == null) return null;
    if (!providerBaseType.isAssignableFromType(returnType) &&
        !familyType.isAssignableFromType(returnType)) {
      return null;
    }

    final parseResult = _parsesProviderExpression(expression);
    if (parseResult == null) return null;
    final (:provider, :providerPrefix, :familyArguments) = parseResult;

    return ProviderOrFamilyExpression._(
      node: expression,
      provider: provider,
      providerPrefix: providerPrefix,
      familyArguments: familyArguments,
    );
  }

  final Expression node;
  final SimpleIdentifier? providerPrefix;
  final ProviderIdentifier? provider;

  /// If [provider] is a provider with arguments (family), represents the arguments
  /// passed to the provider.
  final ArgumentList? familyArguments;
}
