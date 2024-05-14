part of '../riverpod_ast.dart';

abstract class ProviderListenableExpressionParent implements RiverpodAst {}

class ProviderListenableExpression extends RiverpodAst {
  ProviderListenableExpression._({
    required this.node,
    required this.provider,
    required this.providerPrefix,
    required this.providerElement,
    required this.familyArguments,
  });

  static ProviderListenableExpression? _parse(Expression? expression) {
    if (expression == null) return null;

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
            annotation =
                providerForType.firstAnnotationOfExact(element.variable2!);
          } catch (_) {
            return;
          }

          if (annotation == null) {
            providerElement =
                LegacyProviderDeclarationElement.parse(element.variable2!);
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

    return ProviderListenableExpression._(
      node: expression,
      provider: provider,
      providerPrefix: providerPrefix,
      providerElement: providerElement,
      // Make sure `(){}()` doesn't report an argument list even though it's not a provider
      familyArguments: provider == null ? null : familyArguments,
    );
  }

  static GeneratorProviderDeclarationElement?
      _parseGeneratedProviderFromAnnotation(
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

  final Expression node;
  final SimpleIdentifier? providerPrefix;
  final SimpleIdentifier? provider;
  final ProviderDeclarationElement? providerElement;

  /// If [provider] is a provider with arguments (family), represents the arguments
  /// passed to the provider.
  final ArgumentList? familyArguments;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitProviderListenableExpression(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}
