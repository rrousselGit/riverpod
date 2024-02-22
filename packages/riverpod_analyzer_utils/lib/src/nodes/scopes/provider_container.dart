part of '../../nodes.dart';

@_ast
extension ProviderContainerInstanceCreationExpressionX
    on InstanceCreationExpression {
  ProviderContainerInstanceCreationExpression? get providerContainer {
    return upsert('ProviderContainerInstanceCreationExpression', () {
      final createdType = constructorName.type.type;
      if (createdType == null ||
          !providerContainerType.isExactlyType(createdType)) {
        return null;
      }

      final overrides = argumentList
          .namedArguments()
          .firstWhereOrNull((e) => e.name.label.name == 'overrides');

      return ProviderContainerInstanceCreationExpression._(
        node: this,
        overrides: overrides?.expression.let(ProviderOverrideList._parse),
      );
    });
  }
}

final class ProviderContainerInstanceCreationExpression {
  ProviderContainerInstanceCreationExpression._({
    required this.node,
    required this.overrides,
  });

  final InstanceCreationExpression node;
  final ProviderOverrideList? overrides;
}
