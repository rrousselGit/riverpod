part of '../riverpod_ast.dart';

abstract class ProviderListenableExpressionParent implements RiverpodAst {}

class ProviderListenableExpression extends RiverpodAst {
  ProviderListenableExpression._({
    required this.node,
    required this.provider,
    required this.providerElement,
    required this.familyArguments,
  });

  static ProviderListenableExpression? _parse(Expression? expression) {
    if (expression == null) return null;

    // print('oy $expression // ${expression.runtimeType}');
    SimpleIdentifier? provider;
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
          DartObject? annotation;
          try {
            annotation =
                providerForType.firstAnnotationOfExact(element.variable);
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
        parseExpression(expression.prefix);
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
      return StatelessProviderDeclarationElement.parse(
        function,
        annotation: null,
      );
    }
    late final type = generatedProviderDefinition.toTypeValue()?.element;
    if (type != null && type is ClassElement) {
      return StatefulProviderDeclarationElement.parse(
        type,
        annotation: null,
      );
    } else {
      throw StateError('Unknown value $generatedProviderDefinition');
    }
  }

  final Expression node;
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
