part of '../nodes.dart';

@_ast
extension WidgetRefInvocationX on MethodInvocation {
  WidgetRefInvocation? get widgetRefInvocation {
    return upsert('WidgetRefInvocation', () {
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

  WidgetRefWatchInvocation? get widgetRefWatchInvocation =>
      widgetRefInvocation.cast<WidgetRefWatchInvocation>();

  WidgetRefReadInvocation? get widgetRefReadInvocation =>
      widgetRefInvocation.cast<WidgetRefReadInvocation>();

  WidgetRefListenInvocation? get widgetRefListenInvocation =>
      widgetRefInvocation.cast<WidgetRefListenInvocation>();

  WidgetRefListenManualInvocation? get widgetRefListenManualInvocation =>
      widgetRefInvocation.cast<WidgetRefListenManualInvocation>();
}

sealed class WidgetRefInvocation {
  WidgetRefInvocation._({
    required this.node,
    required this.function,
  });

  final MethodInvocation node;
  final SimpleIdentifier function;
}

final class WidgetRefWatchInvocation extends WidgetRefInvocation {
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

    final providerListenableExpression = node.argumentList
        .positionalArguments()
        .singleOrNull
        ?.providerListenable;
    if (providerListenableExpression == null) return null;

    return WidgetRefWatchInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
    );
  }

  final ProviderListenableExpression provider;
}

final class WidgetRefReadInvocation extends WidgetRefInvocation {
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

    final providerListenableExpression = node.argumentList
        .positionalArguments()
        .singleOrNull
        ?.providerListenable;
    if (providerListenableExpression == null) return null;

    return WidgetRefReadInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
    );
  }

  final ProviderListenableExpression provider;
}

final class WidgetRefListenInvocation extends WidgetRefInvocation {
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

    final providerListenableExpression =
        positionalArgs.firstOrNull?.providerListenable;
    if (providerListenableExpression == null) return null;

    return WidgetRefListenInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
      listener: listener,
    );
  }

  final ProviderListenableExpression provider;
  final Expression listener;
}

final class WidgetRefListenManualInvocation extends WidgetRefInvocation {
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

    final providerListenableExpression =
        positionalArgs.firstOrNull?.providerListenable;
    if (providerListenableExpression == null) return null;

    return WidgetRefListenManualInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
      listener: listener,
    );
  }

  final ProviderListenableExpression provider;
  final Expression listener;
}
