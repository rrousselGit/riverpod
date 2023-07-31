part of '../riverpod_ast.dart';

abstract class RiverpodAstVisitor {
  void visitProviderOverrideList(
    ProviderOverrideList overrideList,
  );
  void visitProviderOverrideExpression(
    ProviderOverrideExpression expression,
  );

  void visitResolvedRiverpodUnit(ResolvedRiverpodLibraryResult result);

  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression container,
  );
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression expression,
  );

  void visitRiverpodAnnotation(
    RiverpodAnnotation annotation,
  );
  void visitRiverpodAnnotationDependency(
    RiverpodAnnotationDependency dependency,
  );
  void visitRiverpodAnnotationDependencies(
    RiverpodAnnotationDependencies dependencies,
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

  void visitClassBasedProviderDeclaration(
    ClassBasedProviderDeclaration declaration,
  );
  void visitFunctionalProviderDeclaration(
    FunctionalProviderDeclaration declaration,
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
  void visitHookConsumerWidgetDeclaration(
    HookConsumerWidgetDeclaration declaration,
  );
  void visitConsumerStatefulWidgetDeclaration(
    ConsumerStatefulWidgetDeclaration declaration,
  );
  void visitStatefulHookConsumerWidgetDeclaration(
    StatefulHookConsumerWidgetDeclaration declaration,
  );
  void visitConsumerStateDeclaration(ConsumerStateDeclaration declaration);
}

class RecursiveRiverpodAstVisitor extends RiverpodAstVisitor {
  @override
  void visitProviderOverrideList(
    ProviderOverrideList overrideList,
  ) {
    overrideList.visitChildren(this);
  }

  @override
  void visitProviderOverrideExpression(
    ProviderOverrideExpression expression,
  ) {
    expression.visitChildren(this);
  }

  @override
  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression container,
  ) {
    container.visitChildren(this);
  }

  @override
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression expression,
  ) {
    expression.visitChildren(this);
  }

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
  void visitRiverpodAnnotationDependencies(
    RiverpodAnnotationDependencies dependencies,
  ) {
    dependencies.visitChildren(this);
  }

  @override
  void visitConsumerStatefulWidgetDeclaration(
    ConsumerStatefulWidgetDeclaration declaration,
  ) {
    declaration.visitChildren(this);
  }

  @override
  void visitClassBasedProviderDeclaration(
    ClassBasedProviderDeclaration declaration,
  ) {
    declaration.visitChildren(this);
  }

  @override
  void visitFunctionalProviderDeclaration(
    FunctionalProviderDeclaration declaration,
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

  @override
  void visitHookConsumerWidgetDeclaration(
    HookConsumerWidgetDeclaration declaration,
  ) {
    declaration.visitChildren(this);
  }

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
    StatefulHookConsumerWidgetDeclaration declaration,
  ) {
    declaration.visitChildren(this);
  }
}

class SimpleRiverpodAstVisitor extends RiverpodAstVisitor {
  @override
  void visitProviderOverrideList(
    ProviderOverrideList overrideList,
  ) {}

  @override
  void visitProviderOverrideExpression(
    ProviderOverrideExpression expression,
  ) {}

  @override
  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression container,
  ) {}

  @override
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression expression,
  ) {}

  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration declaration) {}

  @override
  void visitConsumerStatefulWidgetDeclaration(
    ConsumerStatefulWidgetDeclaration declaration,
  ) {}

  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration declaration) {}

  @override
  void visitHookConsumerWidgetDeclaration(
    HookConsumerWidgetDeclaration declaration,
  ) {}

  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration declaration) {}

  @override
  void visitLegacyProviderDependencies(
    LegacyProviderDependencies dependencies,
  ) {}

  @override
  void visitLegacyProviderDependency(LegacyProviderDependency dependency) {}

  @override
  void visitProviderListenableExpression(
    ProviderListenableExpression expression,
  ) {}

  @override
  void visitRefListenInvocation(RefListenInvocation invocation) {}

  @override
  void visitRefReadInvocation(RefReadInvocation invocation) {}

  @override
  void visitRefWatchInvocation(RefWatchInvocation invocation) {}

  @override
  void visitResolvedRiverpodUnit(ResolvedRiverpodLibraryResult result) {}

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation annotation) {}

  @override
  void visitRiverpodAnnotationDependency(
    RiverpodAnnotationDependency dependency,
  ) {}

  @override
  void visitRiverpodAnnotationDependencies(
    RiverpodAnnotationDependencies dependencies,
  ) {}

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
    StatefulHookConsumerWidgetDeclaration declaration,
  ) {}

  @override
  void visitClassBasedProviderDeclaration(
    ClassBasedProviderDeclaration declaration,
  ) {}

  @override
  void visitFunctionalProviderDeclaration(
    FunctionalProviderDeclaration declaration,
  ) {}

  @override
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation invocation) {}

  @override
  void visitWidgetRefListenManualInvocation(
    WidgetRefListenManualInvocation invocation,
  ) {}

  @override
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation invocation) {}

  @override
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation invocation) {}
}

class UnimplementedRiverpodAstVisitor extends RiverpodAstVisitor {
  @override
  void visitProviderOverrideList(
    ProviderOverrideList overrideList,
  ) {
    throw UnimplementedError(
      'implement visitProviderOverrideList',
    );
  }

  @override
  void visitProviderOverrideExpression(
    ProviderOverrideExpression expression,
  ) {
    throw UnimplementedError(
      'implement visitProviderOverrideExpression',
    );
  }

  @override
  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression container,
  ) {
    throw UnimplementedError(
      'implement visitProviderScopeInstanceCreationExpression',
    );
  }

  @override
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression expression,
  ) {
    throw UnimplementedError(
      'implement visitProviderContainerInstanceCreationExpression',
    );
  }

  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration declaration) {
    throw UnimplementedError('implement visitConsumerStateDeclaration');
  }

  @override
  void visitConsumerStatefulWidgetDeclaration(
    ConsumerStatefulWidgetDeclaration declaration,
  ) {
    throw UnimplementedError(
      'implement visitConsumerStatefulWidgetDeclaration',
    );
  }

  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration declaration) {
    throw UnimplementedError('implement visitConsumerWidgetDeclaration');
  }

  @override
  void visitHookConsumerWidgetDeclaration(
    HookConsumerWidgetDeclaration declaration,
  ) {
    throw UnimplementedError('implement visitHookConsumerWidgetDeclaration');
  }

  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration declaration) {
    throw UnimplementedError('implement visitLegacyProviderDeclaration');
  }

  @override
  void visitLegacyProviderDependencies(
    LegacyProviderDependencies dependencies,
  ) {
    throw UnimplementedError('implement visitLegacyProviderDependencies');
  }

  @override
  void visitLegacyProviderDependency(LegacyProviderDependency dependency) {
    throw UnimplementedError('implement visitLegacyProviderDependency');
  }

  @override
  void visitProviderListenableExpression(
    ProviderListenableExpression expression,
  ) {
    throw UnimplementedError('implement visitProviderListenableExpression');
  }

  @override
  void visitRefListenInvocation(RefListenInvocation invocation) {
    throw UnimplementedError('implement visitRefListenInvocation');
  }

  @override
  void visitRefReadInvocation(RefReadInvocation invocation) {
    throw UnimplementedError('implement visitRefReadInvocation');
  }

  @override
  void visitRefWatchInvocation(RefWatchInvocation invocation) {
    throw UnimplementedError('implement visitRefWatchInvocation');
  }

  @override
  void visitResolvedRiverpodUnit(ResolvedRiverpodLibraryResult result) {
    throw UnimplementedError('implement visitResolvedRiverpodUnit');
  }

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation annotation) {
    throw UnimplementedError('implement visitRiverpodAnnotation');
  }

  @override
  void visitRiverpodAnnotationDependency(
    RiverpodAnnotationDependency dependency,
  ) {
    throw UnimplementedError('implement visitRiverpodAnnotationDependency');
  }

  @override
  void visitRiverpodAnnotationDependencies(
    RiverpodAnnotationDependencies dependencies,
  ) {
    throw UnimplementedError('implement visitRiverpodAnnotationDependencies');
  }

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
    StatefulHookConsumerWidgetDeclaration declaration,
  ) {
    throw UnimplementedError(
      'implement visitStatefulHookConsumerWidgetDeclaration',
    );
  }

  @override
  void visitClassBasedProviderDeclaration(
    ClassBasedProviderDeclaration declaration,
  ) {
    throw UnimplementedError('implement visitClassBasedProviderDeclaration');
  }

  @override
  void visitFunctionalProviderDeclaration(
    FunctionalProviderDeclaration declaration,
  ) {
    throw UnimplementedError('implement visitFunctionalProviderDeclaration');
  }

  @override
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation invocation) {
    throw UnimplementedError('implement visitWidgetRefListenInvocation');
  }

  @override
  void visitWidgetRefListenManualInvocation(
    WidgetRefListenManualInvocation invocation,
  ) {
    throw UnimplementedError('implement visitWidgetRefListenManualInvocation');
  }

  @override
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation invocation) {
    throw UnimplementedError('implement visitWidgetRefReadInvocation');
  }

  @override
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation invocation) {
    throw UnimplementedError('implement visitWidgetRefWatchInvocation');
  }
}

class RiverpodAstRegistry {
  void run(RiverpodAst node) {
    node.accept(_RiverpodAstRegistryVisitor(this));
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
    addClassBasedProviderDeclaration(cb);
    addFunctionalProviderDeclaration(cb);
  }

  final _onClassBasedProviderDeclaration =
      <void Function(ClassBasedProviderDeclaration)>[];
  void addClassBasedProviderDeclaration(
    void Function(ClassBasedProviderDeclaration) cb,
  ) {
    _onClassBasedProviderDeclaration.add(cb);
  }

  final _onFunctionalProviderDeclaration =
      <void Function(FunctionalProviderDeclaration)>[];
  void addFunctionalProviderDeclaration(
    void Function(FunctionalProviderDeclaration) cb,
  ) {
    _onFunctionalProviderDeclaration.add(cb);
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

  final _onRiverpodAnnotationDependencies =
      <void Function(RiverpodAnnotationDependencies)>[];
  void addRiverpodAnnotationDependencies(
    void Function(RiverpodAnnotationDependencies) cb,
  ) {
    _onRiverpodAnnotationDependencies.add(cb);
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

  final _onHookConsumerWidgetDeclaration =
      <void Function(HookConsumerWidgetDeclaration)>[];
  void addHookConsumerWidgetDeclaration(
    void Function(HookConsumerWidgetDeclaration) cb,
  ) {
    _onHookConsumerWidgetDeclaration.add(cb);
  }

  final _onStatefulHookConsumerWidgetDeclaration =
      <void Function(StatefulHookConsumerWidgetDeclaration)>[];
  void addStatefulHookConsumerWidgetDeclaration(
    void Function(StatefulHookConsumerWidgetDeclaration) cb,
  ) {
    _onStatefulHookConsumerWidgetDeclaration.add(cb);
  }

  final _onConsumerStatefulWidgetDeclaration =
      <void Function(ConsumerStatefulWidgetDeclaration)>[];
  void addConsumerStatefulWidgetDeclaration(
    void Function(ConsumerStatefulWidgetDeclaration) cb,
  ) {
    _onConsumerStatefulWidgetDeclaration.add(cb);
  }

  final _onConsumerStateDeclaration =
      <void Function(ConsumerStateDeclaration)>[];
  void addConsumerStateDeclaration(
    void Function(ConsumerStateDeclaration) cb,
  ) {
    _onConsumerStateDeclaration.add(cb);
  }

  final _onProviderScopeInstanceCreationExpression =
      <void Function(ProviderScopeInstanceCreationExpression)>[];
  void addProviderScopeInstanceCreationExpression(
    void Function(ProviderScopeInstanceCreationExpression) cb,
  ) {
    _onProviderScopeInstanceCreationExpression.add(cb);
  }

  final _onProviderContainerInstanceCreationExpression =
      <void Function(ProviderContainerInstanceCreationExpression)>[];
  void addProviderContainerInstanceCreationExpression(
    void Function(ProviderContainerInstanceCreationExpression) cb,
  ) {
    _onProviderContainerInstanceCreationExpression.add(cb);
  }

  final _onProviderOverrideExpression =
      <void Function(ProviderOverrideExpression)>[];
  void addProviderOverrideExpression(
    void Function(ProviderOverrideExpression) cb,
  ) {
    _onProviderOverrideExpression.add(cb);
  }

  final _onProviderOverrideList = <void Function(ProviderOverrideList)>[];
  void addProviderOverrideList(void Function(ProviderOverrideList) cb) {
    _onProviderOverrideList.add(cb);
  }
}

// Voluntarily not extenting RiverpodAstVisitor to trigger a compilation error
// when new nodes are added.
class _RiverpodAstRegistryVisitor extends RiverpodAstVisitor {
  _RiverpodAstRegistryVisitor(this._registry);

  final RiverpodAstRegistry _registry;

  @override
  void visitProviderOverrideList(
    ProviderOverrideList overrideList,
  ) {
    overrideList.visitChildren(this);
    _runSubscriptions(
      overrideList,
      _registry._onProviderOverrideList,
    );
  }

  @override
  void visitProviderOverrideExpression(
    ProviderOverrideExpression expression,
  ) {
    expression.visitChildren(this);
    _runSubscriptions(
      expression,
      _registry._onProviderOverrideExpression,
    );
  }

  @override
  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression container,
  ) {
    container.visitChildren(this);
    _runSubscriptions(
      container,
      _registry._onProviderScopeInstanceCreationExpression,
    );
  }

  @override
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression expression,
  ) {
    expression.visitChildren(this);
    _runSubscriptions(
      expression,
      _registry._onProviderContainerInstanceCreationExpression,
    );
  }

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
  void visitRiverpodAnnotationDependencies(
    RiverpodAnnotationDependencies dependencies,
  ) {
    dependencies.visitChildren(this);
    _runSubscriptions(
      dependencies,
      _registry._onRiverpodAnnotationDependencies,
    );
  }

  @override
  void visitConsumerStatefulWidgetDeclaration(
    ConsumerStatefulWidgetDeclaration declaration,
  ) {
    declaration.visitChildren(this);
    _runSubscriptions(
      declaration,
      _registry._onConsumerStatefulWidgetDeclaration,
    );
  }

  @override
  void visitClassBasedProviderDeclaration(
    ClassBasedProviderDeclaration declaration,
  ) {
    declaration.visitChildren(this);
    _runSubscriptions(declaration, _registry._onClassBasedProviderDeclaration);
  }

  @override
  void visitFunctionalProviderDeclaration(
    FunctionalProviderDeclaration declaration,
  ) {
    declaration.visitChildren(this);
    _runSubscriptions(
      declaration,
      _registry._onFunctionalProviderDeclaration,
    );
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

  @override
  void visitHookConsumerWidgetDeclaration(
    HookConsumerWidgetDeclaration declaration,
  ) {
    declaration.visitChildren(this);
    _runSubscriptions(declaration, _registry._onHookConsumerWidgetDeclaration);
  }

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
    StatefulHookConsumerWidgetDeclaration declaration,
  ) {
    declaration.visitChildren(this);
    _runSubscriptions(
      declaration,
      _registry._onStatefulHookConsumerWidgetDeclaration,
    );
  }
}
