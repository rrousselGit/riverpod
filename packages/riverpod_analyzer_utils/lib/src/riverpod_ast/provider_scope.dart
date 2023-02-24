part of '../riverpod_ast.dart';

class ProviderScopeInstanceCreationExpression extends RiverpodAst {
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
  final ProviderOverrideList? overrides;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitProviderScopeInstanceCreationExpression(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    overrides?.accept(visitor);
  }
}
