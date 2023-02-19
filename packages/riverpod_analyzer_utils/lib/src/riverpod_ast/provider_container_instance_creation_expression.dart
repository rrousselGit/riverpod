part of '../riverpod_ast.dart';

class ProviderContainerInstanceCreationExpression extends RiverpodAst {
  ProviderContainerInstanceCreationExpression._({
    required this.node,
  });

  static ProviderContainerInstanceCreationExpression? _parse(
    InstanceCreationExpression node,
  ) {
    final createdType = node.constructorName.type.type;
    if (createdType == null ||
        !providerContainerType.isExactlyType(createdType)) {
      return null;
    }

    return ProviderContainerInstanceCreationExpression._(node: node);
  }

  final InstanceCreationExpression node;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitProviderContainerInstanceCreationExpression(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}
