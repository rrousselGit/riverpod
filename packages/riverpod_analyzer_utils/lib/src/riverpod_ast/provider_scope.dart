part of '../riverpod_ast.dart';

class ProviderScopeInstanceCreationExpression extends RiverpodAst {
  ProviderScopeInstanceCreationExpression._({
    required this.node,
  });

  static ProviderScopeInstanceCreationExpression? _parse(
    InstanceCreationExpression node,
  ) {
    final createdType = node.constructorName.type.type;
    if (createdType == null || !providerScopeType.isExactlyType(createdType)) {
      return null;
    }

    return ProviderScopeInstanceCreationExpression._(node: node);
  }

  final InstanceCreationExpression node;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitProviderScopeInstanceCreationExpression(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}
