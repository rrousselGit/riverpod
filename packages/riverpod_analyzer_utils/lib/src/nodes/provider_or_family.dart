part of '../nodes.dart';

({
  SimpleIdentifier provider,
  SimpleIdentifier? providerPrefix,
  ProviderDeclarationElement? providerElement,
  ArgumentList? familyArguments,
})? _parsesProviderExpression(Expression? expression) {
  SimpleIdentifier? provider;
  SimpleIdentifier? providerPrefix;
  ProviderDeclarationElement? providerElement;
  ArgumentList? familyArguments;

  void parseExpression(Expression? expression) {
    // Can be reached when the code contains syntax errors
    if (expression == null) return;
    if (expression is SimpleIdentifier) {
      // watch(expression)
      provider = expression;
      final element = expression.staticElement;
      if (element is PropertyAccessorElement) {
        // watch(provider)
        final providerFor = parseFirstProviderFor(element.variable);

        if (providerFor != null) {
          providerElement = providerFor.$1;
        } else {
          providerElement =
              LegacyProviderDeclarationElement._parse(element.variable);
        }
      }
    } else if (expression is FunctionExpressionInvocation) {
      // watch(expression())
      familyArguments = expression.argumentList;
      parseExpression(expression.function);
    } else if (expression is MethodInvocation) {
      // watch(expression.method())
      parseExpression(expression.target);
    } else if (expression is PrefixedIdentifier) {
      // watch(expression.modifier)
      final element = expression.prefix.staticElement;
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

  final p = provider;

  if (p == null) return null;
  final providerType = p.staticType;

  if (providerType == null) return null;
  if (!providerBaseType.isAssignableFromType(providerType) &&
      !familyType.isAssignableFromType(providerType)) {
    return null;
  }

  return (
    provider: p,
    providerPrefix: providerPrefix,
    providerElement: providerElement,
    familyArguments: familyArguments,
  );
}

final class ProviderOrFamilyExpression {
  ProviderOrFamilyExpression._({
    required this.node,
    required this.provider,
    required this.providerPrefix,
    required this.providerElement,
    required this.familyArguments,
  });

  static ProviderOrFamilyExpression? _parse(Expression? expression) {
    if (expression == null) return null;

    final returnType = expression.staticType;
    if (returnType == null) return null;
    if (!providerBaseType.isAssignableFromType(returnType) &&
        !familyType.isAssignableFromType(returnType)) return null;

    final parseResult = _parsesProviderExpression(expression);
    if (parseResult == null) return null;
    final (
      :provider,
      :providerPrefix,
      :providerElement,
      :familyArguments,
    ) = parseResult;

    return ProviderOrFamilyExpression._(
      node: expression,
      provider: provider,
      providerPrefix: providerPrefix,
      providerElement: providerElement,
      familyArguments: familyArguments,
    );
  }

  final Expression node;
  final SimpleIdentifier? providerPrefix;
  final SimpleIdentifier provider;
  final ProviderDeclarationElement? providerElement;

  /// If [provider] is a provider with arguments (family), represents the arguments
  /// passed to the provider.
  final ArgumentList? familyArguments;
}
