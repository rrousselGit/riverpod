part of '../../nodes.dart';

@_ast
extension ProviderContainerInstanceCreationExpressionX
    on InstanceCreationExpression {
  static final _cache =
      Expando<Box<ProviderContainerInstanceCreationExpression?>>();

  ProviderContainerInstanceCreationExpression? get providerContainer {
    return _cache.upsert(this, () {
      final createdType = constructorName.type.type;
      if (createdType == null ||
          !providerContainerType.isExactlyType(createdType)) {
        return null;
      }

      final overrides = argumentList.namedArguments().firstWhereOrNull(
        (e) => e.name.lexeme == 'overrides',
      );

      return ProviderContainerInstanceCreationExpression._(
        node: this,
        overrides: overrides?.argumentExpression.overrides,
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

  late final NamedArgument? parent = node.argumentList.named('parent');
}
