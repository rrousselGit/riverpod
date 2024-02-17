library riverpod_ast;

import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:custom_lint_core/custom_lint_core.dart';
import 'package:meta/meta.dart';

import '../riverpod_analyzer_utils.dart';
import 'argument_list_utils.dart';
import 'errors.dart';

part 'riverpod_ast.g.dart';
part 'riverpod_ast/dependencies.dart';
part 'riverpod_ast/consumer.dart';
part 'riverpod_ast/generator_provider_declaration.dart';
part 'riverpod_ast/legacy_provider_declaration.dart';
part 'riverpod_ast/provider_container_instance_creation_expression.dart';
part 'riverpod_ast/provider_declaration.dart';
part 'riverpod_ast/provider_listenable_expression.dart';
part 'riverpod_ast/provider_override.dart';
part 'riverpod_ast/provider_scope.dart';
part 'riverpod_ast/ref_invocation.dart';
part 'riverpod_ast/resolve_riverpod.dart';
part 'riverpod_ast/riverpod_annotation.dart';
part 'riverpod_ast/widget_ref_invocation.dart';

abstract base class RiverpodAst {
  RiverpodAst() {
    visitChildren(_SetParentVisitor(this));
  }

  RiverpodAst? _parent;
  RiverpodAst? get parent => _parent;

  AstNode get node;

  void accept(RiverpodAstVisitor visitor);

  @mustCallSuper
  void visitChildren(RiverpodAstVisitor visitor) {}
}

extension AstNodeX on AstNode {
  List<ProviderListenableExpression> get providerListenables {
    return upsert('ProviderListenableExpressions', () {
      final visitor = _ProviderListenableExpressionVisitor();
      accept(visitor);
      return visitor.expressions;
    });
  }

  List<WidgetRefInvocation> get widgetRefInvocations {
    return upsert('WidgetRefInvocations', () {
      final visitor = _WidgetRefInvocationVisitor();
      accept(visitor);
      return visitor.invocations;
    });
  }

  List<RefInvocation> get refInvocations {
    return upsert('RefInvocations', () {
      final visitor = _RefInvocationVisitor();
      accept(visitor);
      return visitor.invocations;
    });
  }

  List<ProviderContainerInstanceCreationExpression>
      get providerContainerInstanceCreations {
    return upsert('ProviderContainerInstanceCreations', () {
      final visitor = _ProviderContainerInstanceCreationVisitor();
      accept(visitor);
      return visitor.instances;
    });
  }

  List<ProviderScopeInstanceCreationExpression>
      get providerScopeInstanceCreations {
    return upsert('ProviderScopeInstanceCreations', () {
      final visitor = _ProviderScopeInstanceCreationVisitor();
      accept(visitor);
      return visitor.instances;
    });
  }
}

class _ProviderListenableExpressionVisitor
    extends GeneralizingAstVisitor<void> {
  final expressions = <ProviderListenableExpression>[];

  @override
  void visitExpression(Expression node) {
    final listenable = node.providerListenable;
    if (listenable != null) {
      expressions.add(listenable);
    }
    super.visitExpression(node);
  }
}

class _WidgetRefInvocationVisitor extends GeneralizingAstVisitor<void> {
  final invocations = <WidgetRefInvocation>[];

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final refInvocation = node.widgetRefInvocation;
    if (refInvocation != null) {
      invocations.add(refInvocation);
    }
    super.visitMethodInvocation(node);
  }
}

class _RefInvocationVisitor extends GeneralizingAstVisitor<void> {
  final invocations = <RefInvocation>[];

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final refInvocation = node.refInvocation;
    if (refInvocation != null) {
      invocations.add(refInvocation);
    }
    super.visitMethodInvocation(node);
  }
}

class _ProviderContainerInstanceCreationVisitor
    extends GeneralizingAstVisitor<void> {
  final instances = <ProviderContainerInstanceCreationExpression>[];

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final instance = node.providerContainerInstanceCreation;
    if (instance != null) {
      instances.add(instance);
    }
    super.visitInstanceCreationExpression(node);
  }
}

class _ProviderScopeInstanceCreationVisitor
    extends GeneralizingAstVisitor<void> {
  final instances = <ProviderScopeInstanceCreationExpression>[];

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final instance = node.providerScopeInstanceCreation;
    if (instance != null) {
      instances.add(instance);
    }
    super.visitInstanceCreationExpression(node);
  }
}

extension ExpressionX on Expression {
  ProviderListenableExpression? get providerListenable {
    return upsert('ProviderListenableExpression', () {
      return ProviderListenableExpression._parse(this);
    });
  }
}

extension MethodInvocationX on MethodInvocation {
  RefInvocation? get refInvocation {
    return upsert('RefInvocation', () => RefInvocation._parse(this));
  }

  WidgetRefInvocation? get widgetRefInvocation {
    return upsert(
      'WidgetRefInvocation',
      () => WidgetRefInvocation._parse(this),
    );
  }
}

extension InstanceCreationX on InstanceCreationExpression {
  ProviderScopeInstanceCreationExpression? get providerScopeInstanceCreation {
    return upsert(
      'ProviderScopeInstanceCreationExpression',
      () => ProviderScopeInstanceCreationExpression._parse(this),
    );
  }

  ProviderContainerInstanceCreationExpression?
      get providerContainerInstanceCreation {
    return upsert(
      'ProviderContainerInstanceCreationExpression',
      () => ProviderContainerInstanceCreationExpression._parse(this),
    );
  }
}

class _SetParentVisitor extends GeneralizingRiverpodAstVisitor {
  _SetParentVisitor(this.parent);

  final RiverpodAst parent;

  @override
  void visitRiverpodAst(RiverpodAst node) {
    node._parent = parent;
    super.visitRiverpodAst(node);
  }
}

extension on AstNode {
  R upsert<R>(
    String key,
    R Function() create,
  ) {
    // Using a record to differentiate "null value" from "no value".
    final existing = getProperty<(R value,)>('riverpod.$key');
    if (existing != null) return existing.$1;

    final created = create();
    setProperty(key, (created,));
    return created;
  }
}

extension<T> on T? {
  R? cast<R>() {
    final that = this;
    if (that is R) return that;
    return null;
  }

  R? let<R>(R? Function(T value)? cb) {
    if (cb == null) return null;
    final that = this;
    if (that != null) return cb(that);
    return null;
  }
}
