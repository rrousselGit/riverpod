part of '../riverpod_ast.dart';

class ProviderContainerInstanceCreationExpression extends RiverpodAst {
  ProviderContainerInstanceCreationExpression._({
    required this.node,
    required this.overrides,
    required this.unit,
  });

  static ProviderContainerInstanceCreationExpression? _parse(
    InstanceCreationExpression node, {
    required CompilationUnit unit,
  }) {
    final createdType = node.constructorName.type.type;
    if (createdType == null ||
        !providerContainerType.isExactlyType(createdType)) {
      return null;
    }

    final overrides = node.argumentList
        .namedArguments()
        .firstWhereOrNull((e) => e.name.label.name == 'overrides');

    return ProviderContainerInstanceCreationExpression._(
      node: node,
      overrides: ProviderOverrideList._parse(overrides, unit: unit),
      unit: unit,
    );
  }

  @override
  final CompilationUnit unit;
  final InstanceCreationExpression node;
  final ProviderOverrideList? overrides;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitProviderContainerInstanceCreationExpression(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    overrides?.accept(visitor);
  }
}
