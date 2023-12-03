part of '../riverpod_ast.dart';

/// A `WidgetRef` invocation.
///
/// This can be any method, including custom user-defined extension methods.
class WidgetRefInvocation extends RiverpodAst
    implements ProviderListenableExpressionParent {
  WidgetRefInvocation._({
    required this.node,
    required this.function,
    required this.providers,
    required this.unit,
  });

  static WidgetRefInvocation? _parse(
    MethodInvocation node, {
    required CompilationUnit unit,
  }) {
    final targetType = node.realTarget?.staticType;
    if (targetType == null) return null;

    // Since Ref is sealed, checking that the function is from the package:riverpod
    // before checking its type skips iterating over the superclasses of an element
    // if it's not from Riverpod.
    if (!isFromFlutterRiverpod.isExactlyType(targetType) |
        !widgetRefType.isAssignableFromType(targetType)) {
      return null;
    }
    final function = node.function;
    if (function is! SimpleIdentifier) return null;

    final functionOwner = function.staticElement
        .cast<MethodElement>()
        ?.declaration
        .enclosingElement;

    if (functionOwner == null) return null;

    final isRiverpodMethod = // Since WidgetRef is sealed, checking that the function is from the package:riverpod
        // before checking its type skips iterating over the superclasses of an element
        // if it's not from Riverpod.
        isFromFlutterRiverpod.isExactly(functionOwner) &&
            widgetRefType.isAssignableFrom(functionOwner);

    final isExtensionOnRef = functionOwner is ExtensionElement &&
        widgetRefType.isAssignableFromType(functionOwner.extendedType);

    if (!isRiverpodMethod && !isExtensionOnRef) return null;

    final providers = node.argumentList.arguments
        .map((e) => ProviderListenableExpression._parse(e, unit: unit))
        .whereNotNull()
        .toList();

    return WidgetRefInvocation._(
      node: node,
      function: function,
      providers: providers,
      unit: unit,
    );
  }

  @override
  final CompilationUnit unit;

  /// The method invoked. Can point to a custom extension method.
  final MethodInvocation node;

  /// The function being invoked.
  final SimpleIdentifier function;

  /// The providers that are listened to by this invocation.
  ///
  /// May be empty if the invocation does not receive providers as arguments
  final List<ProviderListenableExpression> providers;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitWidgetRefInvocation(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    for (final provider in providers) {
      provider.accept(visitor);
    }
  }
}
