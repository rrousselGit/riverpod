part of '../riverpod_ast.dart';

abstract class RefInvocation extends RiverpodAst
    implements ProviderListenableExpressionParent {
  RefInvocation._({
    required this.node,
    required this.function,
  });

  static RefInvocation? _parse(
    MethodInvocation node, {
    required void Function() superCall,
  }) {
    final targetType = node.realTarget?.staticType;
    if (targetType == null) return null;

    if (!isRiverpodRef(targetType)) return null;

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
        !isFromRiverpod.isExactly(functionOwner) ||
        !refType.isAssignableFrom(functionOwner)) {
      return null;
    }

    switch (function.name) {
      case 'watch':
        return RefWatchInvocation._parse(
          node,
          function,
          superCall: superCall,
        );
      case 'read':
        return RefReadInvocation._parse(
          node,
          function,
          superCall: superCall,
        );
      case 'listen':
        return RefListenInvocation._parse(
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

/// A [RefInvocation] which interacts with a provider, inducing a dependency.
abstract class RefDependencyInvocation extends RefInvocation {
  RefDependencyInvocation._({
    required super.node,
    required super.function,
    required this.provider,
  }) : super._();

  /// The provider that is being interacted with.
  final ProviderListenableExpression provider;
}

class RefWatchInvocation extends RefDependencyInvocation {
  RefWatchInvocation._({
    required super.node,
    required super.function,
    required super.provider,
  }) : super._();

  static RefWatchInvocation? _parse(
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

    final refWatchInvocation = RefWatchInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
    );
    providerListenableExpression._parent = refWatchInvocation;
    return refWatchInvocation;
  }

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRefWatchInvocation(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    provider.accept(visitor);
  }
}

class RefReadInvocation extends RefDependencyInvocation {
  RefReadInvocation._({
    required super.node,
    required super.function,
    required super.provider,
  }) : super._();

  static RefReadInvocation? _parse(
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

    final refReadInvocation = RefReadInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
    );
    providerListenableExpression._parent = refReadInvocation;
    return refReadInvocation;
  }

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRefReadInvocation(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    provider.accept(visitor);
  }
}

class RefListenInvocation extends RefDependencyInvocation {
  RefListenInvocation._({
    required super.node,
    required super.function,
    required this.listener,
    required super.provider,
  }) : super._();

  static RefListenInvocation? _parse(
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

    final refListenInvocation = RefListenInvocation._(
      node: node,
      function: function,
      listener: listener,
      provider: providerListenableExpression,
    );
    providerListenableExpression._parent = refListenInvocation;
    return refListenInvocation;
  }

  final Expression listener;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRefListenInvocation(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    provider.accept(visitor);
  }
}
