part of '../riverpod_ast.dart';

extension ProviderOverrideExpressionX on CollectionElement {
  ProviderOverrideExpression? get providerOverride {
    return upsert('ProviderOverrideExpression', () {
      return ProviderOverrideExpression._parse(this);
    });
  }
}

final class ProviderOverrideExpression {
  ProviderOverrideExpression._({
    required this.node,
    required this.providerElement,
    required this.provider,
    required this.familyArguments,
    required this.providerPrefix,
  });

  // ignore: prefer_constructors_over_static_methods
  static ProviderOverrideExpression? _parse(CollectionElement expression) {
    if (expression is! Expression) return null;

    final type = expression.staticType;
    if (type == null || !overrideType.isAssignableFromType(type)) return null;

    final result = _parsesProviderExpression(expression);

    return ProviderOverrideExpression._(
      node: expression,
      providerElement: result?.providerElement,
      familyArguments: result?.familyArguments,
      provider: result?.provider,
      providerPrefix: result?.providerPrefix,
    );
  }

  final CollectionElement node;
  final ProviderDeclarationElement? providerElement;
  final SimpleIdentifier? provider;
  final SimpleIdentifier? providerPrefix;

  /// If [provider] is a provider with arguments (family), represents the arguments
  /// passed to the provider.
  final ArgumentList? familyArguments;
}

extension ProviderOverrideListX on Expression {
  ProviderOverrideList? get overrides {
    return upsert(
      'ProviderOverrideList',
      () => ProviderOverrideList._parse(this),
    );
  }
}

final class ProviderOverrideList {
  ProviderOverrideList._({
    required this.node,
    required this.overrides,
  });

  static ProviderOverrideList? _parse(Expression expression) {
    final type = expression.staticType;
    if (type == null || !type.isDartCoreList) return null;

    type as InterfaceType;
    final valueType = type.typeArguments.single;
    if (!overrideType.isAssignableFromType(valueType)) return null;

    List<ProviderOverrideExpression>? overrides;
    if (expression is ListLiteral) {
      overrides = expression.elements
          .map((e) => e.providerOverride)
          .whereNotNull()
          .toList();
    }

    return ProviderOverrideList._(
      node: expression,
      overrides: overrides,
    );
  }

  final Expression node;
  final List<ProviderOverrideExpression>? overrides;
}
