part of '../../nodes.dart';

@_ast
extension ProviderScopeInstanceCreationExpressionX
    on InstanceCreationExpression {
  static final _cache =
      Expando<Box<ProviderScopeInstanceCreationExpression?>>();

  ProviderScopeInstanceCreationExpression? get providerScope {
    return _cache.upsert(this, () {
      final createdType = constructorName.type.type;
      if (createdType == null ||
          !providerScopeType.isExactlyType(createdType)) {
        return null;
      }

      final overrides = argumentList
          .namedArguments()
          .firstWhereOrNull((e) => e.name.label.name == 'overrides');

      return ProviderScopeInstanceCreationExpression._(
        node: this,
        overrides: overrides?.expression.overrides,
      );
    });
  }
}

final class ProviderScopeInstanceCreationExpression {
  ProviderScopeInstanceCreationExpression._({
    required this.node,
    required this.overrides,
  });

  final InstanceCreationExpression node;
  final ProviderOverrideList? overrides;
}
