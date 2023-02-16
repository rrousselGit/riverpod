part of '../riverpod_ast.dart';

class ProviderContainerInstanceCreationExpression {
  ProviderContainerInstanceCreationExpression._({
    required this.node,
  });

  @internal
  static ProviderContainerInstanceCreationExpression? parse(
    InstanceCreationExpression node,
  ) {
    final createdType = node.constructorName.type.type;
    if (createdType == null ||
        !providerContainerType.isExactlyType(createdType)) {
      return null;
    }

    return ProviderContainerInstanceCreationExpression._(
      node: node,
    );
  }

  final InstanceCreationExpression node;
}
