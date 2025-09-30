part of '../nodes.dart';

@_ast
extension RefInvocationX on MethodInvocation {
  static final _cache = Expando<Box<RefInvocation?>>();

  RefInvocation? get refInvocation {
    return _cache.upsert(this, () {
      final targetType = realTarget?.staticType;
      if (targetType == null) return null;

      if (!isRiverpodRef(targetType)) return null;

      final function = this.function;
      if (function is! SimpleIdentifier) return null;
      final functionOwner =
          function.element.cast<MethodElement2>()?.enclosingElement2;

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
          return RefWatchInvocation._parse(this, function);
        case 'read':
          return RefReadInvocation._parse(this, function);
        case 'listen':
          return RefListenInvocation._parse(this, function);
        default:
          return null;
      }
    });
  }
}

sealed class RefInvocation {
  RefInvocation._({required this.node, required this.function});

  final MethodInvocation node;
  final SimpleIdentifier function;
}

/// A [RefInvocation] which interacts with a provider, inducing a dependency.
sealed class RefDependencyInvocation extends RefInvocation {
  RefDependencyInvocation._({
    required super.node,
    required super.function,
    required this.listenable,
  }) : super._();

  /// The provider that is being interacted with.
  final ProviderListenableExpression listenable;
}

final class RefWatchInvocation extends RefDependencyInvocation {
  RefWatchInvocation._({
    required super.node,
    required super.function,
    required super.listenable,
  }) : super._();

  static RefWatchInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function,
  ) {
    assert(
      function.name == 'watch',
      'Argument error, function is not a ref.watch function',
    );

    final providerListenableExpression =
        node.argumentList
            .positionalArguments()
            .singleOrNull
            ?.providerListenable;
    if (providerListenableExpression == null) return null;

    return RefWatchInvocation._(
      node: node,
      function: function,
      listenable: providerListenableExpression,
    );
  }
}

final class RefReadInvocation extends RefDependencyInvocation {
  RefReadInvocation._({
    required super.node,
    required super.function,
    required super.listenable,
  }) : super._();

  static RefReadInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function,
  ) {
    assert(
      function.name == 'read',
      'Argument error, function is not a ref.read function',
    );

    final providerListenableExpression =
        node.argumentList
            .positionalArguments()
            .singleOrNull
            ?.providerListenable;
    if (providerListenableExpression == null) return null;

    return RefReadInvocation._(
      node: node,
      function: function,
      listenable: providerListenableExpression,
    );
  }
}

final class RefListenInvocation extends RefDependencyInvocation {
  RefListenInvocation._({
    required super.node,
    required super.function,
    required this.listener,
    required super.listenable,
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

    final providerListenableExpression =
        positionalArgs.firstOrNull?.providerListenable;
    if (providerListenableExpression == null) return null;

    return RefListenInvocation._(
      node: node,
      function: function,
      listener: listener,
      listenable: providerListenableExpression,
    );
  }

  final Expression listener;
}
