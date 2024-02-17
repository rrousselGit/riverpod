part of '../riverpod_ast.dart';

abstract base class RefInvocation extends RiverpodAst
    with _$RefInvocation
    implements ProviderListenableExpressionParent {
  RefInvocation._({
    required this.node,
    required this.function,
  });

  static RefInvocation? _parse(MethodInvocation node) {
    final targetType = node.realTarget?.staticType;
    if (targetType == null) return null;

    if (!isRiverpodRef(targetType)) return null;

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
        !isFromRiverpod.isExactly(functionOwner) ||
        !refType.isAssignableFrom(functionOwner)) {
      return null;
    }

    switch (function.name) {
      case 'watch':
        return RefWatchInvocation._parse(node, function);
      case 'read':
        return RefReadInvocation._parse(node, function);
      case 'listen':
        return RefListenInvocation._parse(node, function);
      default:
        return null;
    }
  }

  final MethodInvocation node;
  final SimpleIdentifier function;
}

/// A [RefInvocation] which interacts with a provider, inducing a dependency.
abstract base class RefDependencyInvocation extends RefInvocation
    with _$RefDependencyInvocation {
  RefDependencyInvocation._({
    required super.node,
    required super.function,
    required this.provider,
  }) : super._();

  /// The provider that is being interacted with.
  @override
  final ProviderListenableExpression provider;
}

final class RefWatchInvocation extends RefDependencyInvocation
    with _$RefWatchInvocation {
  RefWatchInvocation._({
    required super.node,
    required super.function,
    required super.provider,
  }) : super._();

  static RefWatchInvocation? _parse(
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

    return RefWatchInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
    );
  }
}

final class RefReadInvocation extends RefDependencyInvocation
    with _$RefReadInvocation {
  RefReadInvocation._({
    required super.node,
    required super.function,
    required super.provider,
  }) : super._();

  static RefReadInvocation? _parse(
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

    return RefReadInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
    );
  }
}

final class RefListenInvocation extends RefDependencyInvocation
    with _$RefListenInvocation {
  RefListenInvocation._({
    required super.node,
    required super.function,
    required this.listener,
    required super.provider,
  }) : super._();

  static RefListenInvocation? _parse(
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

    return RefListenInvocation._(
      node: node,
      function: function,
      listener: listener,
      provider: providerListenableExpression,
    );
  }

  final Expression listener;
}
