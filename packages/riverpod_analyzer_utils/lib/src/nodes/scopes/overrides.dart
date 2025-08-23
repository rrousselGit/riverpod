part of '../../nodes.dart';

@_ast
extension ProviderOverrideExpressionX on CollectionElement {
  static final _cache = Expando<Box<ProviderOverrideExpression?>>();

  ProviderOverrideExpression? get providerOverride {
    return _cache.upsert(this, () {
      final expression = this;
      if (expression is! Expression) return null;

      final type = expression.staticType;
      if (type == null || !overrideType.isAssignableFromType(type)) return null;

      final result = _parsesProviderExpression(expression);

      return ProviderOverrideExpression._(
        node: expression,
        familyArguments: result?.familyArguments,
        provider: result?.provider,
        providerPrefix: result?.providerPrefix,
      );
    });
  }
}

final class ProviderOverrideExpression {
  ProviderOverrideExpression._({
    required this.node,
    required this.provider,
    required this.familyArguments,
    required this.providerPrefix,
  });

  final CollectionElement node;
  final ProviderIdentifier? provider;
  final SimpleIdentifier? providerPrefix;

  /// If [provider] is a provider with arguments (family), represents the arguments
  /// passed to the provider.
  final ArgumentList? familyArguments;
}

@_ast
extension ProviderOverrideListX on Expression {
  static final _cache = Expando<Box<ProviderOverrideList?>>();

  ProviderOverrideList? get overrides {
    return _cache.upsert(this, () {
      final expression = this;
      final type = staticType;
      if (type == null || !type.isDartCoreList) return null;

      type as InterfaceType;
      final valueType = type.typeArguments.single;
      if (!overrideType.isAssignableFromType(valueType)) return null;

      List<ProviderOverrideExpression>? overrides;
      if (expression is ListLiteral) {
        overrides = expression.elements
            .map((e) => e.providerOverride)
            .nonNulls
            .toList();
      }

      return ProviderOverrideList._(node: expression, overrides: overrides);
    });
  }
}

final class ProviderOverrideList {
  ProviderOverrideList._({required this.node, required this.overrides});

  final Expression node;
  final List<ProviderOverrideExpression>? overrides;
}
