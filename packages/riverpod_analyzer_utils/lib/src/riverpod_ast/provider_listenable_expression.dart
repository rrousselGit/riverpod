part of '../riverpod_ast.dart';

GeneratorProviderDeclarationElement? _parseGeneratedProviderFromAnnotation(
  DartObject annotation,
) {
  final generatedProviderDefinition = annotation.getField('value')!;

  final function = generatedProviderDefinition.toFunctionValue();
  if (function != null) {
    return FunctionalProviderDeclarationElement.parse(
      function,
      annotation: null,
    );
  }
  late final type = generatedProviderDefinition.toTypeValue()?.element;
  if (type != null && type is ClassElement) {
    return ClassBasedProviderDeclarationElement._parse(
      type,
      annotation: null,
    );
  } else {
    throw StateError('Unknown value $generatedProviderDefinition');
  }
}

final class ProviderListenableExpression {
  ProviderListenableExpression._({
    required this.node,
    required this.provider,
    required this.providerPrefix,
    required this.providerElement,
    required this.familyArguments,
  });

  static ProviderListenableExpression? _parse(Expression? expression) {
    if (expression == null) return null;

    final returnType = expression.staticType;
    if (returnType == null) return null;
    if (!providerListenableType.isAssignableFromType(returnType)) return null;

    final parseResult = _parsesProviderExpression(expression);
    if (parseResult == null) return null;
    final (
      :provider,
      :providerPrefix,
      :providerElement,
      :familyArguments,
    ) = parseResult;

    return ProviderListenableExpression._(
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
