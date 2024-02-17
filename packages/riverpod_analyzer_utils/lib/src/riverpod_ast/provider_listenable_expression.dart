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
    return ClassBasedProviderDeclarationElement.parse(
      type,
      annotation: null,
    );
  } else {
    throw StateError('Unknown value $generatedProviderDefinition');
  }
}

({
  SimpleIdentifier? provider,
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
        DartObject? annotation;
        try {
          annotation = providerForType.firstAnnotationOfExact(element.variable);
        } catch (_) {
          return;
        }

        if (annotation == null) {
          providerElement =
              LegacyProviderDeclarationElement.parse(element.variable);
        } else {
          providerElement = _parseGeneratedProviderFromAnnotation(annotation);
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

  return (
    provider: provider,
    providerPrefix: providerPrefix,
    providerElement: providerElement,
    familyArguments: familyArguments,
  );
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

    if (provider == null) return null;
    final providerType = provider.staticType;

    if (providerType == null) return null;
    if (!providerBaseType.isAssignableFromType(providerType) &&
        !familyType.isAssignableFromType(providerType)) {
      return null;
    }

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
