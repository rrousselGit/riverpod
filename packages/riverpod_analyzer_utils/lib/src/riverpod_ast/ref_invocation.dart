part of '../riverpod_ast.dart';

class RefInvocation extends RiverpodAst
    implements ProviderListenableExpressionParent {
  RefInvocation._({
    required this.node,
    required this.function,
    required this.providers,
    required this.unit,
  });

  static RefInvocation? _parse(
    MethodInvocation node, {
    required CompilationUnit unit,
  }) {
    final targetType = node.realTarget?.staticType;
    if (targetType == null) return null;

    if (!isRiverpodRef(targetType)) return null;

    final function = node.function;
    if (function is! SimpleIdentifier) return null;
    final functionOwner = function.staticElement
        .cast<MethodElement>()
        ?.declaration
        .enclosingElement;

    if (functionOwner == null) return null;

    final isRiverpodMethod = // Since Ref is sealed, checking that the function is from the package:riverpod
        // before checking its type skips iterating over the superclasses of an element
        // if it's not from Riverpod.
        isFromRiverpod.isExactly(functionOwner) &&
            refType.isAssignableFrom(functionOwner);

    final isExtensionOnRef = functionOwner is ExtensionElement &&
        refType.isAssignableFromType(functionOwner.extendedType);

    if (!isRiverpodMethod && !isExtensionOnRef) return null;

    final providers = node.argumentList.arguments
        .map((e) => ProviderListenableExpression._parse(e, unit: unit))
        .whereNotNull()
        .toList();

    return RefInvocation._(
      node: node,
      function: function,
      providers: providers,
      unit: unit,
    );
  }

  @override
  final CompilationUnit unit;
  final MethodInvocation node;
  final SimpleIdentifier function;

  /// The providers that are listened to by this invocation.
  ///
  /// May be empty if the invocation does not receive providers as arguments.
  final List<ProviderListenableExpression> providers;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRefInvocation(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    for (final provider in providers) {
      provider.accept(visitor);
    }
  }
}
