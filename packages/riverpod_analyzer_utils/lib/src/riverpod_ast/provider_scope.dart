part of '../riverpod_ast.dart';

final class ProviderScopeInstanceCreationExpression extends RiverpodAst
    with _$ProviderScopeInstanceCreationExpression {
  ProviderScopeInstanceCreationExpression._({
    required this.node,
    required this.overrides,
  });

  static ProviderScopeInstanceCreationExpression? _parse(
    InstanceCreationExpression node,
  ) {
    final createdType = node.constructorName.type.type;
    if (createdType == null || !providerScopeType.isExactlyType(createdType)) {
      return null;
    }

    final overrides = node.argumentList
        .namedArguments()
        .firstWhereOrNull((e) => e.name.label.name == 'overrides');

    return ProviderScopeInstanceCreationExpression._(
      node: node,
      overrides: ProviderOverrideList._parse(overrides),
    );
  }

  final InstanceCreationExpression node;
  @override
  final ProviderOverrideList? overrides;
}
