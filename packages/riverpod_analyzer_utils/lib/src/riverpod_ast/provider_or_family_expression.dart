part of '../riverpod_ast.dart';

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
