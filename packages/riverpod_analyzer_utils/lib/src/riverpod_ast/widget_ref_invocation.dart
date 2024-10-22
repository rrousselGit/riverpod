part of '../riverpod_ast.dart';

abstract class WidgetRefInvocation extends RiverpodAst
    implements ProviderListenableExpressionParent {
  WidgetRefInvocation._({
    required this.node,
    required this.function,
  });

  static WidgetRefInvocation? _parse(
    MethodInvocation node, {
    required void Function() superCall,
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
        // ignore: deprecated_member_use, necessary to support older versions of analyzer
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
        return WidgetRefWatchInvocation._parse(
          node,
          function,
          superCall: superCall,
        );
      case 'read':
        return WidgetRefReadInvocation._parse(
          node,
          function,
          superCall: superCall,
        );
      case 'listen':
        return WidgetRefListenInvocation._parse(
          node,
          function,
          superCall: superCall,
        );
      case 'listenManual':
        return WidgetRefListenManualInvocation._parse(
          node,
          function,
          superCall: superCall,
        );

      default:
        return null;
    }
  }

  final MethodInvocation node;
  final SimpleIdentifier function;
}

class WidgetRefWatchInvocation extends WidgetRefInvocation {
  WidgetRefWatchInvocation._({
    required super.node,
    required super.function,
    required this.provider,
  }) : super._();

  static WidgetRefWatchInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function, {
    required void Function() superCall,
  }) {
    assert(
      function.name == 'watch',
      'Argument error, function is not a ref.watch function',
    );

    final providerListenableExpression = ProviderListenableExpression._parse(
      node.argumentList.positionalArguments().singleOrNull,
    );
    if (providerListenableExpression == null) return null;

    final widgetRefWatchInvocation = WidgetRefWatchInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
    );
    providerListenableExpression._parent = widgetRefWatchInvocation;
    return widgetRefWatchInvocation;
  }

  final ProviderListenableExpression provider;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitWidgetRefWatchInvocation(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    provider.accept(visitor);
  }
}

class WidgetRefReadInvocation extends WidgetRefInvocation {
  WidgetRefReadInvocation._({
    required super.node,
    required super.function,
    required this.provider,
  }) : super._();

  static WidgetRefReadInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function, {
    required void Function() superCall,
  }) {
    assert(
      function.name == 'read',
      'Argument error, function is not a ref.read function',
    );

    final providerListenableExpression = ProviderListenableExpression._parse(
      node.argumentList.positionalArguments().singleOrNull,
    );
    if (providerListenableExpression == null) return null;

    final widgetRefReadInvocation = WidgetRefReadInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
    );
    providerListenableExpression._parent = widgetRefReadInvocation;
    return widgetRefReadInvocation;
  }

  final ProviderListenableExpression provider;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitWidgetRefReadInvocation(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    provider.accept(visitor);
  }
}

class WidgetRefListenInvocation extends WidgetRefInvocation {
  WidgetRefListenInvocation._({
    required super.node,
    required super.function,
    required this.provider,
    required this.listener,
  }) : super._();

  static WidgetRefListenInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function, {
    required void Function() superCall,
  }) {
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

    final widgetRefListenInvocation = WidgetRefListenInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
      listener: listener,
    );
    providerListenableExpression._parent = widgetRefListenInvocation;
    return widgetRefListenInvocation;
  }

  final ProviderListenableExpression provider;
  final Expression listener;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitWidgetRefListenInvocation(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    provider.accept(visitor);
  }
}

class WidgetRefListenManualInvocation extends WidgetRefInvocation {
  WidgetRefListenManualInvocation._({
    required super.node,
    required super.function,
    required this.provider,
    required this.listener,
  }) : super._();

  static WidgetRefListenManualInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function, {
    required void Function() superCall,
  }) {
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

    final widgetRefListenManualInvocation = WidgetRefListenManualInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
      listener: listener,
    );
    providerListenableExpression._parent = widgetRefListenManualInvocation;
    return widgetRefListenManualInvocation;
  }

  final ProviderListenableExpression provider;
  final Expression listener;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitWidgetRefListenManualInvocation(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    provider.accept(visitor);
  }
}
