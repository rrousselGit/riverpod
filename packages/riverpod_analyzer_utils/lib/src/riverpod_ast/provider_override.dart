part of '../riverpod_ast.dart';

class ProviderOverrideExpression extends RiverpodAst {
  ProviderOverrideExpression._({
    required this.expression,
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
      final listenable = ProviderListenableExpression._parse(expression);
      provider = listenable?.provider;
      providerElement = listenable?.providerElement;
      familyArguments = listenable?.familyArguments;
    }

    return ProviderOverrideExpression._(
      expression: expression,
      providerElement: providerElement,
      familyArguments: familyArguments,
      provider: provider,
    );
  }

  final CollectionElement expression;
  final ProviderDeclarationElement? providerElement;
  final SimpleIdentifier? provider;

  /// If [provider] is a provider with arguments (family), represents the arguments
  /// passed to the provider.
  final ArgumentList? familyArguments;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitProviderOverrideExpression(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

class ProviderOverrideList extends RiverpodAst {
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

    final providerOverrideList = ProviderOverrideList._(
      node: expression,
      overrides: overrides,
    );

    overrides?.forEach((e) => e._parent = providerOverrideList);

    return providerOverrideList;
  }

  final NamedExpression node;
  final List<ProviderOverrideExpression>? overrides;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitProviderOverrideList(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    overrides?.forEach((e) => e.accept(visitor));
  }
}
