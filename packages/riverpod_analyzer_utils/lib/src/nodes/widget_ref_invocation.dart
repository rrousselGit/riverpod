part of '../nodes.dart';

@_ast
extension WidgetRefInvocationX on MethodInvocation {
  static final _cache = Expando<Box<WidgetRefInvocation?>>();

  WidgetRefInvocation? get widgetRefInvocation {
    return _cache.upsert(this, () {
      final targetType = realTarget?.staticType;
      if (targetType == null) return null;

      // Since Ref is sealed, checking that the function is from the package:riverpod
      // before checking its type skips iterating over the superclasses of an element
      // if it's not from Riverpod.
      if (!isFromFlutterRiverpod.isExactlyType(targetType) |
          !widgetRefType.isAssignableFromType(targetType)) {
        return null;
      }
      final function = this.function;
      if (function is! SimpleIdentifier) return null;
      final functionOwner =
          function.element.cast<MethodElement>()?.enclosingElement;

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
          return WidgetRefWatchInvocation._parse(this, function);
        case 'read':
          return WidgetRefReadInvocation._parse(this, function);
        case 'listen':
          return WidgetRefListenInvocation._parse(this, function);
        case 'listenManual':
          return WidgetRefListenManualInvocation._parse(this, function);

        default:
          return null;
      }
    });
  }
}

sealed class WidgetRefInvocation {
  WidgetRefInvocation._({required this.node, required this.function});

  final MethodInvocation node;
  final SimpleIdentifier function;
}

/// A [RefInvocation] which interacts with a provider, inducing a dependency.
sealed class WidgetRefDependencyInvocation extends WidgetRefInvocation {
  WidgetRefDependencyInvocation._({
    required super.node,
    required super.function,
    required this.listenable,
  }) : super._();

  /// The provider that is being interacted with.
  final ProviderListenableExpression listenable;
}

final class WidgetRefWatchInvocation extends WidgetRefDependencyInvocation {
  WidgetRefWatchInvocation._({
    required super.node,
    required super.function,
    required super.listenable,
  }) : super._();

  static WidgetRefWatchInvocation? _parse(
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

    return WidgetRefWatchInvocation._(
      node: node,
      function: function,
      listenable: providerListenableExpression,
    );
  }
}

final class WidgetRefReadInvocation extends WidgetRefDependencyInvocation {
  WidgetRefReadInvocation._({
    required super.node,
    required super.function,
    required super.listenable,
  }) : super._();

  static WidgetRefReadInvocation? _parse(
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

    return WidgetRefReadInvocation._(
      node: node,
      function: function,
      listenable: providerListenableExpression,
    );
  }
}

final class WidgetRefListenInvocation extends WidgetRefDependencyInvocation {
  WidgetRefListenInvocation._({
    required super.node,
    required super.function,
    required super.listenable,
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

    final providerListenableExpression =
        positionalArgs.firstOrNull?.providerListenable;
    if (providerListenableExpression == null) return null;

    return WidgetRefListenInvocation._(
      node: node,
      function: function,
      listenable: providerListenableExpression,
      listener: listener,
    );
  }

  final Expression listener;
}

final class WidgetRefListenManualInvocation
    extends WidgetRefDependencyInvocation {
  WidgetRefListenManualInvocation._({
    required super.node,
    required super.function,
    required super.listenable,
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

    final providerListenableExpression =
        positionalArgs.firstOrNull?.providerListenable;
    if (providerListenableExpression == null) return null;

    return WidgetRefListenManualInvocation._(
      node: node,
      function: function,
      listenable: providerListenableExpression,
      listener: listener,
    );
  }

  final Expression listener;
}
