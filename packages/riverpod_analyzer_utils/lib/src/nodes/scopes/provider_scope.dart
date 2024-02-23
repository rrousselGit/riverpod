part of '../../nodes.dart';

@_ast
extension ProviderScopeInstanceCreationExpressionX
    on InstanceCreationExpression {
  ProviderScopeInstanceCreationExpression? get providerScope {
    return upsert('ProviderScopeInstanceCreationExpression', () {
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
