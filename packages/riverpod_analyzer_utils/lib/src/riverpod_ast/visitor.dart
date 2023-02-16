part of '../riverpod_ast.dart';

abstract class RiverpodAstVisitor {
  void visitResolvedRiverpodUnit(ResolvedRiverpodLibraryResult result);

  void visitRiverpodAnnotation(
    RiverpodAnnotation annotation,
  );
  void visitRiverpodAnnotationDependency(
    RiverpodAnnotationDependency dependency,
  );

  void visitLegacyProviderDeclaration(
    LegacyProviderDeclaration declaration,
  );
  void visitLegacyProviderDependencies(
    LegacyProviderDependencies dependencies,
  );
  void visitLegacyProviderDependency(
    LegacyProviderDependency dependency,
  );

  void visitStatefulProviderDeclaration(
    StatefulProviderDeclaration declaration,
  );
  void visitStatelessProviderDeclaration(
    StatelessProviderDeclaration declaration,
  );

  void visitProviderListenableExpression(
    ProviderListenableExpression expression,
  );

  void visitRefWatchInvocation(RefWatchInvocation invocation);
  void visitRefListenInvocation(RefListenInvocation invocation);
  void visitRefReadInvocation(RefReadInvocation invocation);

  void visitWidgetRefReadInvocation(WidgetRefReadInvocation invocation);
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation invocation);
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation invocation);
  void visitWidgetRefListenManualInvocation(
    WidgetRefListenManualInvocation invocation,
  );

  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration declaration);
  void visitStatefulConsumerWidgetDeclaration(
    StatefulConsumerWidgetDeclaration declaration,
  );
  void visitConsumerStateDeclaration(ConsumerStateDeclaration declaration);
}

abstract class RecursiveRiverpodAstVisitor extends RiverpodAstVisitor {
  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration declaration) {
    declaration.visitChildren(this);
  }

  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration declaration) {
    declaration.visitChildren(this);
  }

  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration declaration) {
    declaration.visitChildren(this);
  }

  @override
  void visitLegacyProviderDependencies(
    LegacyProviderDependencies dependencies,
  ) {
    dependencies.visitChildren(this);
  }

  @override
  void visitLegacyProviderDependency(LegacyProviderDependency dependency) {
    dependency.visitChildren(this);
  }

  @override
  void visitProviderListenableExpression(
    ProviderListenableExpression expression,
  ) {
    expression.visitChildren(this);
  }

  @override
  void visitRefListenInvocation(RefListenInvocation invocation) {
    invocation.visitChildren(this);
  }

  @override
  void visitRefReadInvocation(RefReadInvocation invocation) {
    invocation.visitChildren(this);
  }

  @override
  void visitRefWatchInvocation(RefWatchInvocation invocation) {
    invocation.visitChildren(this);
  }

  @override
  void visitResolvedRiverpodUnit(ResolvedRiverpodLibraryResult result) {
    result.visitChildren(this);
  }

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation annotation) {
    annotation.visitChildren(this);
  }

  @override
  void visitRiverpodAnnotationDependency(
    RiverpodAnnotationDependency dependency,
  ) {
    dependency.visitChildren(this);
  }

  @override
  void visitStatefulConsumerWidgetDeclaration(
    StatefulConsumerWidgetDeclaration declaration,
  ) {
    declaration.visitChildren(this);
  }

  @override
  void visitStatefulProviderDeclaration(
    StatefulProviderDeclaration declaration,
  ) {
    declaration.visitChildren(this);
  }

  @override
  void visitStatelessProviderDeclaration(
    StatelessProviderDeclaration declaration,
  ) {
    declaration.visitChildren(this);
  }

  @override
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation invocation) {
    invocation.visitChildren(this);
  }

  @override
  void visitWidgetRefListenManualInvocation(
    WidgetRefListenManualInvocation invocation,
  ) {
    invocation.visitChildren(this);
  }

  @override
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation invocation) {
    invocation.visitChildren(this);
  }

  @override
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation invocation) {
    invocation.visitChildren(this);
  }
}

class RiverpodAstRegistry {
  void run(RiverpodAst node) {
    node.accept(_RiverpodRegistryVisitor(this));
  }

  // misc
  final _onResolvedRiverpodUnit =
      <void Function(ResolvedRiverpodLibraryResult)>[];
  void addRiverpodUnit(void Function(ResolvedRiverpodLibraryResult) cb) {
    _onResolvedRiverpodUnit.add(cb);
  }

  // Both generator and legacy visitors
  void addProviderDeclaration(void Function(ProviderDeclaration) cb) {
    addGeneratorProviderDeclaration(cb);
    addLegacyProviderDeclaration(cb);
  }

  // Generator-specific visitors

  void addGeneratorProviderDeclaration(
    void Function(GeneratorProviderDeclaration) cb,
  ) {
    addStatefulProviderDeclaration(cb);
    addStatelessProviderDeclaration(cb);
  }

  final _onStatefulProviderDeclaration =
      <void Function(StatefulProviderDeclaration)>[];
  void addStatefulProviderDeclaration(
    void Function(StatefulProviderDeclaration) cb,
  ) {
    _onStatefulProviderDeclaration.add(cb);
  }

  final _onStatelessProviderDeclaration =
      <void Function(StatelessProviderDeclaration)>[];
  void addStatelessProviderDeclaration(
    void Function(StatelessProviderDeclaration) cb,
  ) {
    _onStatelessProviderDeclaration.add(cb);
  }

  final _onRiverpodAnnotation = <void Function(RiverpodAnnotation)>[];
  void addRiverpodAnnotation(
    void Function(RiverpodAnnotation) cb,
  ) {
    _onRiverpodAnnotation.add(cb);
  }

  final _onRiverpodAnnotationDependency =
      <void Function(RiverpodAnnotationDependency)>[];
  void addRiverpodAnnotationDependency(
    void Function(RiverpodAnnotationDependency) cb,
  ) {
    _onRiverpodAnnotationDependency.add(cb);
  }

  // Legacy-specific visitors

  final _onLegacyProviderDeclaration =
      <void Function(LegacyProviderDeclaration)>[];
  void addLegacyProviderDeclaration(
    void Function(LegacyProviderDeclaration) cb,
  ) {
    _onLegacyProviderDeclaration.add(cb);
  }

  final _onLegacyProviderDependencies =
      <void Function(LegacyProviderDependencies)>[];
  void addLegacyProviderDependencies(
    void Function(LegacyProviderDependencies) cb,
  ) {
    _onLegacyProviderDependencies.add(cb);
  }

  final _onLegacyProviderDependency =
      <void Function(LegacyProviderDependency)>[];
  void addLegacyProviderDependency(
    void Function(LegacyProviderDependency) cb,
  ) {
    _onLegacyProviderDependency.add(cb);
  }

  // Ref life-cycle visitors

  final _onRefInvocation = <void Function(RefInvocation)>[];
  void addRefInvocation(
    void Function(RefInvocation) cb,
  ) {
    _onRefInvocation.add(cb);
  }

  final _onRefWatchInvocation = <void Function(RefWatchInvocation)>[];
  void addRefWatchInvocation(
    void Function(RefWatchInvocation) cb,
  ) {
    _onRefWatchInvocation.add(cb);
  }

  final _onRefListenInvocation = <void Function(RefListenInvocation)>[];
  void addRefListenInvocation(
    void Function(RefListenInvocation) cb,
  ) {
    _onRefListenInvocation.add(cb);
  }

  final _onRefReadInvocation = <void Function(RefReadInvocation)>[];
  void addRefReadInvocation(
    void Function(RefReadInvocation) cb,
  ) {
    _onRefReadInvocation.add(cb);
  }

  // WidgetRef life-cycle visitors

  final _onWidgetRefInvocation = <void Function(WidgetRefInvocation)>[];
  void addWidgetRefInvocation(
    void Function(WidgetRefInvocation) cb,
  ) {
    _onWidgetRefInvocation.add(cb);
  }

  final _onWidgetRefWatchInvocation =
      <void Function(WidgetRefWatchInvocation)>[];
  void addWidgetRefWatchInvocation(
    void Function(WidgetRefWatchInvocation) cb,
  ) {
    _onWidgetRefWatchInvocation.add(cb);
  }

  final _onWidgetRefReadInvocation = <void Function(WidgetRefReadInvocation)>[];
  void addWidgetRefReadInvocation(
    void Function(WidgetRefReadInvocation) cb,
  ) {
    _onWidgetRefReadInvocation.add(cb);
  }

  final _onWidgetRefListenInvocation =
      <void Function(WidgetRefListenInvocation)>[];
  void addWidgetRefListenInvocation(
    void Function(WidgetRefListenInvocation) cb,
  ) {
    _onWidgetRefListenInvocation.add(cb);
  }

  final _onWidgetRefListenManualInvocation =
      <void Function(WidgetRefListenManualInvocation)>[];
  void addWidgetRefListenManualInvocation(
    void Function(WidgetRefListenManualInvocation) cb,
  ) {
    _onWidgetRefListenManualInvocation.add(cb);
  }

  // Ref misc

  final _onProviderListenableExpression =
      <void Function(ProviderListenableExpression)>[];
  void addProviderListenableExpression(
    void Function(ProviderListenableExpression) cb,
  ) {
    _onProviderListenableExpression.add(cb);
  }

  // Consumers

  final _onConsumerWidgetDeclaration =
      <void Function(ConsumerWidgetDeclaration)>[];
  void addConsumerWidgetDeclaration(
    void Function(ConsumerWidgetDeclaration) cb,
  ) {
    _onConsumerWidgetDeclaration.add(cb);
  }

  final _onStatefulConsumerWidgetDeclaration =
      <void Function(StatefulConsumerWidgetDeclaration)>[];
  void addStatefulConsumerWidgetDeclaration(
    void Function(StatefulConsumerWidgetDeclaration) cb,
  ) {
    _onStatefulConsumerWidgetDeclaration.add(cb);
  }

  final _onConsumerStateDeclaration =
      <void Function(ConsumerStateDeclaration)>[];
  void addConsumerStateDeclaration(
    void Function(ConsumerStateDeclaration) cb,
  ) {
    _onConsumerStateDeclaration.add(cb);
  }
}

// Voluntarily not extenting RiverpodAstVisitor to trigger a compilation error
// when new nodes are added.
class _RiverpodRegistryVisitor extends RiverpodAstVisitor {
  _RiverpodRegistryVisitor(this._registry);

  final RiverpodAstRegistry _registry;

  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration declaration) {
    declaration.visitChildren(this);
    _runSubscriptions(declaration, _registry._onConsumerStateDeclaration);
  }

  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration declaration) {
    declaration.visitChildren(this);
    _runSubscriptions(declaration, _registry._onConsumerWidgetDeclaration);
  }

  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration declaration) {
    declaration.visitChildren(this);
    _runSubscriptions(declaration, _registry._onLegacyProviderDeclaration);
  }

  @override
  void visitLegacyProviderDependencies(
    LegacyProviderDependencies dependencies,
  ) {
    dependencies.visitChildren(this);
    _runSubscriptions(dependencies, _registry._onLegacyProviderDependencies);
  }

  @override
  void visitLegacyProviderDependency(LegacyProviderDependency dependency) {
    dependency.visitChildren(this);
    _runSubscriptions(dependency, _registry._onLegacyProviderDependency);
  }

  @override
  void visitProviderListenableExpression(
    ProviderListenableExpression expression,
  ) {
    expression.visitChildren(this);
    _runSubscriptions(expression, _registry._onProviderListenableExpression);
  }

  @override
  void visitRefListenInvocation(RefListenInvocation invocation) {
    invocation.visitChildren(this);
    _runSubscriptions(invocation, _registry._onRefListenInvocation);
  }

  @override
  void visitRefReadInvocation(RefReadInvocation invocation) {
    invocation.visitChildren(this);
    _runSubscriptions(invocation, _registry._onRefReadInvocation);
  }

  @override
  void visitRefWatchInvocation(RefWatchInvocation invocation) {
    invocation.visitChildren(this);
    _runSubscriptions(invocation, _registry._onRefWatchInvocation);
  }

  @override
  void visitResolvedRiverpodUnit(ResolvedRiverpodLibraryResult result) {
    result.visitChildren(this);
    _runSubscriptions(result, _registry._onResolvedRiverpodUnit);
  }

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation annotation) {
    annotation.visitChildren(this);
    _runSubscriptions(annotation, _registry._onRiverpodAnnotation);
  }

  @override
  void visitRiverpodAnnotationDependency(
    RiverpodAnnotationDependency dependency,
  ) {
    dependency.visitChildren(this);
    _runSubscriptions(dependency, _registry._onRiverpodAnnotationDependency);
  }

  @override
  void visitStatefulConsumerWidgetDeclaration(
    StatefulConsumerWidgetDeclaration declaration,
  ) {
    declaration.visitChildren(this);
    _runSubscriptions(
      declaration,
      _registry._onStatefulConsumerWidgetDeclaration,
    );
  }

  @override
  void visitStatefulProviderDeclaration(
    StatefulProviderDeclaration declaration,
  ) {
    declaration.visitChildren(this);
    _runSubscriptions(declaration, _registry._onStatefulProviderDeclaration);
  }

  @override
  void visitStatelessProviderDeclaration(
    StatelessProviderDeclaration declaration,
  ) {
    declaration.visitChildren(this);
    _runSubscriptions(declaration, _registry._onStatelessProviderDeclaration);
  }

  @override
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation invocation) {
    invocation.visitChildren(this);
    _runSubscriptions(invocation, _registry._onWidgetRefListenInvocation);
  }

  @override
  void visitWidgetRefListenManualInvocation(
    WidgetRefListenManualInvocation invocation,
  ) {
    invocation.visitChildren(this);
    _runSubscriptions(invocation, _registry._onWidgetRefListenManualInvocation);
  }

  @override
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation invocation) {
    invocation.visitChildren(this);
    _runSubscriptions(invocation, _registry._onWidgetRefReadInvocation);
  }

  @override
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation invocation) {
    invocation.visitChildren(this);
    _runSubscriptions(invocation, _registry._onWidgetRefWatchInvocation);
  }

  void _runSubscriptions<R>(
    R value,
    List<void Function(R)> subscriptions,
  ) {
    for (final sub in subscriptions) {
      try {
        sub(value);
      } catch (e, stack) {
        Zone.current.handleUncaughtError(e, stack);
      }
    }
  }
}
