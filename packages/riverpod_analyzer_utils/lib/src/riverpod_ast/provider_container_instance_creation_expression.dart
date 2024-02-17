part of '../riverpod_ast.dart';

final class ProviderContainerInstanceCreationExpression {
  ProviderContainerInstanceCreationExpression._({
    required this.node,
    required this.overrides,
  });

  static ProviderContainerInstanceCreationExpression? _parse(
    InstanceCreationExpression node,
  ) {
    final createdType = node.constructorName.type.type;
    if (createdType == null ||
        !providerContainerType.isExactlyType(createdType)) {
      return null;
    }

    final overrides = node.argumentList
        .namedArguments()
        .firstWhereOrNull((e) => e.name.label.name == 'overrides');

    print('ProviderContainerInstanceCreationExpression._parse // $overrides');

    return ProviderContainerInstanceCreationExpression._(
      node: node,
      overrides: ProviderOverrideList._parse(overrides),
    );
  }

  final InstanceCreationExpression node;
  final ProviderOverrideList? overrides;
}
