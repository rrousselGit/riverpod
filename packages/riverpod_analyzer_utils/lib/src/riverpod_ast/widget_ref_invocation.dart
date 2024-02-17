part of '../riverpod_ast.dart';

abstract base class WidgetRefInvocation extends RiverpodAst
    with _$WidgetRefInvocation
    implements ProviderListenableExpressionParent {
  WidgetRefInvocation._({
    required this.node,
    required this.function,
  });

  static WidgetRefInvocation? _parse(MethodInvocation node) {
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

    if (functionOwner == null ||
        // Since Ref is sealed, checking that the function is from the package:riverpod
        // before checking its type skips iterating over the superclasses of an element
        // if it's not from Riverpod.
        !isFromFlutterRiverpod.isExactly(functionOwner) ||
        !widgetRefType.isAssignableFrom(functionOwner)) {
      return null;
    }

    switch (function.name) {
      case 'watch':
        return WidgetRefWatchInvocation._parse(node, function);
      case 'read':
        return WidgetRefReadInvocation._parse(node, function);
      case 'listen':
        return WidgetRefListenInvocation._parse(node, function);
      case 'listenManual':
        return WidgetRefListenManualInvocation._parse(node, function);

      default:
        return null;
    }
  }

  final MethodInvocation node;
  final SimpleIdentifier function;
}

final class WidgetRefWatchInvocation extends WidgetRefInvocation
    with _$WidgetRefWatchInvocation {
  WidgetRefWatchInvocation._({
    required super.node,
    required super.function,
    required this.provider,
  }) : super._();

  static WidgetRefWatchInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function,
  ) {
    assert(
      function.name == 'watch',
      'Argument error, function is not a ref.watch function',
    );

    final providerListenableExpression = ProviderListenableExpression._parse(
      node.argumentList.positionalArguments().singleOrNull,
    );
    if (providerListenableExpression == null) return null;

    return WidgetRefWatchInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
    );
  }

  @override
  final ProviderListenableExpression provider;
}

final class WidgetRefReadInvocation extends WidgetRefInvocation
    with _$WidgetRefReadInvocation {
  WidgetRefReadInvocation._({
    required super.node,
    required super.function,
    required this.provider,
  }) : super._();

  static WidgetRefReadInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function,
  ) {
    assert(
      function.name == 'read',
      'Argument error, function is not a ref.read function',
    );

    final providerListenableExpression = ProviderListenableExpression._parse(
      node.argumentList.positionalArguments().singleOrNull,
    );
    if (providerListenableExpression == null) return null;

    return WidgetRefReadInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
    );
  }

  @override
  final ProviderListenableExpression provider;
}

final class WidgetRefListenInvocation extends WidgetRefInvocation
    with _$WidgetRefListenInvocation {
  WidgetRefListenInvocation._({
    required super.node,
    required super.function,
    required this.provider,
    required this.listener,
  }) : super._();

  static WidgetRefListenInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function,
  ) {
    assert(
      function.name == 'listen',
      'Argument error, function is not a ref.listen function',
    );

    final positionalArgs = node.argumentList.positionalArguments().toList();
    final listener = positionalArgs.elementAtOrNull(1);
    if (listener == null) return null;

    final providerListenableExpression = ProviderListenableExpression._parse(
      positionalArgs.firstOrNull,
    );
    if (providerListenableExpression == null) return null;

    return WidgetRefListenInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
      listener: listener,
    );
  }

  @override
  final ProviderListenableExpression provider;
  final Expression listener;
}

final class WidgetRefListenManualInvocation extends WidgetRefInvocation
    with _$WidgetRefListenManualInvocation {
  WidgetRefListenManualInvocation._({
    required super.node,
    required super.function,
    required this.provider,
    required this.listener,
  }) : super._();

  static WidgetRefListenManualInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function,
  ) {
    assert(
      function.name == 'listenManual',
      'Argument error, function is not a ref.listen function',
    );

    final positionalArgs = node.argumentList.positionalArguments().toList();
    final listener = positionalArgs.elementAtOrNull(1);
    if (listener == null) return null;

    final providerListenableExpression = ProviderListenableExpression._parse(
      positionalArgs.firstOrNull,
    );
    if (providerListenableExpression == null) return null;

    return WidgetRefListenManualInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
      listener: listener,
    );
  }

  @override
  final ProviderListenableExpression provider;
  final Expression listener;
}
