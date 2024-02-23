// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nodes.dart';

// **************************************************************************
// _LintVisitorGenerator
// **************************************************************************

mixin RiverpodAstVisitor {
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration node) {}
  void visitHookConsumerWidgetDeclaration(HookConsumerWidgetDeclaration node) {}
  void visitConsumerStatefulWidgetDeclaration(
      ConsumerStatefulWidgetDeclaration node) {}
  void visitStatefulHookConsumerWidgetDeclaration(
      StatefulHookConsumerWidgetDeclaration node) {}
  void visitConsumerStateDeclaration(ConsumerStateDeclaration node) {}
  void visitDependenciesAnnotation(DependenciesAnnotation node) {}
  void visitFunctionalProviderDeclaration(FunctionalProviderDeclaration node) {}
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration node) {}
  void visitClassBasedProviderDeclaration(ClassBasedProviderDeclaration node) {}
  void visitGeneratorProviderDeclaration(GeneratorProviderDeclaration node) {}
  void visitProviderIdentifier(ProviderIdentifier node) {}
  void visitRiverpodAnnotation(RiverpodAnnotation node) {}
  void visitProviderListenableExpression(ProviderListenableExpression node) {}
  void visitRefInvocation(RefInvocation node) {}
  void visitRefWatchInvocation(RefWatchInvocation node) {}
  void visitRefReadInvocation(RefReadInvocation node) {}
  void visitRefListenInvocation(RefListenInvocation node) {}
  void visitWidgetRefInvocation(WidgetRefInvocation node) {}
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation node) {}
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation node) {}
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation node) {}
  void visitWidgetRefListenManualInvocation(
      WidgetRefListenManualInvocation node) {}
  void visitProviderOverrideExpression(ProviderOverrideExpression node) {}
  void visitProviderOverrideList(ProviderOverrideList node) {}
  void visitProviderContainerInstanceCreationExpression(
      ProviderContainerInstanceCreationExpression node) {}
  void visitProviderScopeInstanceCreationExpression(
      ProviderScopeInstanceCreationExpression node) {}
}

abstract class RecursiveRiverpodAstVisitor extends GeneralizingAstVisitor<void>
    with RiverpodAstVisitor {
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);
    node.consumerWidget.let(visitConsumerWidgetDeclaration);
    node.hookConsumerWidget.let(visitHookConsumerWidgetDeclaration);
    node.consumerStatefulWidget.let(visitConsumerStatefulWidgetDeclaration);
    node.statefulHookConsumerWidget
        .let(visitStatefulHookConsumerWidgetDeclaration);
    node.consumerState.let(visitConsumerStateDeclaration);
    node.provider.let(visitClassBasedProviderDeclaration);
  }

  void visitAnnotatedNode(AnnotatedNode node) {
    super.visitAnnotatedNode(node);
    node.dependencies.let(visitDependenciesAnnotation);
    node.riverpod.let(visitRiverpodAnnotation);
  }

  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);
    node.provider.let(visitFunctionalProviderDeclaration);
  }

  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);
    node.provider.let(visitLegacyProviderDeclaration);
  }

  void visitDeclaration(Declaration node) {
    super.visitDeclaration(node);
    node.provider.let(visitGeneratorProviderDeclaration);
  }

  void visitSimpleIdentifier(SimpleIdentifier node) {
    super.visitSimpleIdentifier(node);
    node.provider.let(visitProviderIdentifier);
  }

  void visitExpression(Expression node) {
    super.visitExpression(node);
    node.providerListenable.let(visitProviderListenableExpression);
    node.overrides.let(visitProviderOverrideList);
  }

  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);
    node.refInvocation.let(visitRefInvocation);
    node.refWatchInvocation.let(visitRefWatchInvocation);
    node.refReadInvocation.let(visitRefReadInvocation);
    node.refListenInvocation.let(visitRefListenInvocation);
    node.widgetRefInvocation.let(visitWidgetRefInvocation);
    node.widgetRefWatchInvocation.let(visitWidgetRefWatchInvocation);
    node.widgetRefReadInvocation.let(visitWidgetRefReadInvocation);
    node.widgetRefListenInvocation.let(visitWidgetRefListenInvocation);
    node.widgetRefListenManualInvocation
        .let(visitWidgetRefListenManualInvocation);
  }

  void visitCollectionElement(CollectionElement node) {
    super.visitCollectionElement(node);
    node.providerOverride.let(visitProviderOverrideExpression);
  }

  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);
    node.providerContainer
        .let(visitProviderContainerInstanceCreationExpression);
    node.providerScope.let(visitProviderScopeInstanceCreationExpression);
  }
}

abstract class SimpleRiverpodAstVisitor extends RecursiveRiverpodAstVisitor {
  @override
  void visitNode(AstNode node) {}
}

abstract class UnimplementedRiverpodAstVisitor
    extends SimpleRiverpodAstVisitor {
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration node) =>
      throw UnimplementedError();
  void visitHookConsumerWidgetDeclaration(HookConsumerWidgetDeclaration node) =>
      throw UnimplementedError();
  void visitConsumerStatefulWidgetDeclaration(
          ConsumerStatefulWidgetDeclaration node) =>
      throw UnimplementedError();
  void visitStatefulHookConsumerWidgetDeclaration(
          StatefulHookConsumerWidgetDeclaration node) =>
      throw UnimplementedError();
  void visitConsumerStateDeclaration(ConsumerStateDeclaration node) =>
      throw UnimplementedError();
  void visitDependenciesAnnotation(DependenciesAnnotation node) =>
      throw UnimplementedError();
  void visitFunctionalProviderDeclaration(FunctionalProviderDeclaration node) =>
      throw UnimplementedError();
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration node) =>
      throw UnimplementedError();
  void visitClassBasedProviderDeclaration(ClassBasedProviderDeclaration node) =>
      throw UnimplementedError();
  void visitGeneratorProviderDeclaration(GeneratorProviderDeclaration node) =>
      throw UnimplementedError();
  void visitProviderIdentifier(ProviderIdentifier node) =>
      throw UnimplementedError();
  void visitRiverpodAnnotation(RiverpodAnnotation node) =>
      throw UnimplementedError();
  void visitProviderListenableExpression(ProviderListenableExpression node) =>
      throw UnimplementedError();
  void visitRefInvocation(RefInvocation node) => throw UnimplementedError();
  void visitRefWatchInvocation(RefWatchInvocation node) =>
      throw UnimplementedError();
  void visitRefReadInvocation(RefReadInvocation node) =>
      throw UnimplementedError();
  void visitRefListenInvocation(RefListenInvocation node) =>
      throw UnimplementedError();
  void visitWidgetRefInvocation(WidgetRefInvocation node) =>
      throw UnimplementedError();
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation node) =>
      throw UnimplementedError();
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation node) =>
      throw UnimplementedError();
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation node) =>
      throw UnimplementedError();
  void visitWidgetRefListenManualInvocation(
          WidgetRefListenManualInvocation node) =>
      throw UnimplementedError();
  void visitProviderOverrideExpression(ProviderOverrideExpression node) =>
      throw UnimplementedError();
  void visitProviderOverrideList(ProviderOverrideList node) =>
      throw UnimplementedError();
  void visitProviderContainerInstanceCreationExpression(
          ProviderContainerInstanceCreationExpression node) =>
      throw UnimplementedError();
  void visitProviderScopeInstanceCreationExpression(
          ProviderScopeInstanceCreationExpression node) =>
      throw UnimplementedError();
}

@internal
class RiverpodAnalysisResult extends RecursiveRiverpodAstVisitor {
  final List<RiverpodAnalysisError> errors = [];

  final consumerWidgetDeclarations = <ConsumerWidgetDeclaration>[];
  @override
  void visitConsumerWidgetDeclaration(
    ConsumerWidgetDeclaration node,
  ) {
    super.visitConsumerWidgetDeclaration(node);
    consumerWidgetDeclarations.add(node);
  }

  final hookConsumerWidgetDeclarations = <HookConsumerWidgetDeclaration>[];
  @override
  void visitHookConsumerWidgetDeclaration(
    HookConsumerWidgetDeclaration node,
  ) {
    super.visitHookConsumerWidgetDeclaration(node);
    hookConsumerWidgetDeclarations.add(node);
  }

  final consumerStatefulWidgetDeclarations =
      <ConsumerStatefulWidgetDeclaration>[];
  @override
  void visitConsumerStatefulWidgetDeclaration(
    ConsumerStatefulWidgetDeclaration node,
  ) {
    super.visitConsumerStatefulWidgetDeclaration(node);
    consumerStatefulWidgetDeclarations.add(node);
  }

  final statefulHookConsumerWidgetDeclarations =
      <StatefulHookConsumerWidgetDeclaration>[];
  @override
  void visitStatefulHookConsumerWidgetDeclaration(
    StatefulHookConsumerWidgetDeclaration node,
  ) {
    super.visitStatefulHookConsumerWidgetDeclaration(node);
    statefulHookConsumerWidgetDeclarations.add(node);
  }

  final consumerStateDeclarations = <ConsumerStateDeclaration>[];
  @override
  void visitConsumerStateDeclaration(
    ConsumerStateDeclaration node,
  ) {
    super.visitConsumerStateDeclaration(node);
    consumerStateDeclarations.add(node);
  }

  final dependenciesAnnotations = <DependenciesAnnotation>[];
  @override
  void visitDependenciesAnnotation(
    DependenciesAnnotation node,
  ) {
    super.visitDependenciesAnnotation(node);
    dependenciesAnnotations.add(node);
  }

  final functionalProviderDeclarations = <FunctionalProviderDeclaration>[];
  @override
  void visitFunctionalProviderDeclaration(
    FunctionalProviderDeclaration node,
  ) {
    super.visitFunctionalProviderDeclaration(node);
    functionalProviderDeclarations.add(node);
  }

  final legacyProviderDeclarations = <LegacyProviderDeclaration>[];
  @override
  void visitLegacyProviderDeclaration(
    LegacyProviderDeclaration node,
  ) {
    super.visitLegacyProviderDeclaration(node);
    legacyProviderDeclarations.add(node);
  }

  final classBasedProviderDeclarations = <ClassBasedProviderDeclaration>[];
  @override
  void visitClassBasedProviderDeclaration(
    ClassBasedProviderDeclaration node,
  ) {
    super.visitClassBasedProviderDeclaration(node);
    classBasedProviderDeclarations.add(node);
  }

  final generatorProviderDeclarations = <GeneratorProviderDeclaration>[];
  @override
  void visitGeneratorProviderDeclaration(
    GeneratorProviderDeclaration node,
  ) {
    super.visitGeneratorProviderDeclaration(node);
    generatorProviderDeclarations.add(node);
  }

  final providerIdentifiers = <ProviderIdentifier>[];
  @override
  void visitProviderIdentifier(
    ProviderIdentifier node,
  ) {
    super.visitProviderIdentifier(node);
    providerIdentifiers.add(node);
  }

  final riverpodAnnotations = <RiverpodAnnotation>[];
  @override
  void visitRiverpodAnnotation(
    RiverpodAnnotation node,
  ) {
    super.visitRiverpodAnnotation(node);
    riverpodAnnotations.add(node);
  }

  final providerListenableExpressions = <ProviderListenableExpression>[];
  @override
  void visitProviderListenableExpression(
    ProviderListenableExpression node,
  ) {
    super.visitProviderListenableExpression(node);
    providerListenableExpressions.add(node);
  }

  final refInvocations = <RefInvocation>[];
  @override
  void visitRefInvocation(
    RefInvocation node,
  ) {
    super.visitRefInvocation(node);
    refInvocations.add(node);
  }

  final refWatchInvocations = <RefWatchInvocation>[];
  @override
  void visitRefWatchInvocation(
    RefWatchInvocation node,
  ) {
    super.visitRefWatchInvocation(node);
    refWatchInvocations.add(node);
  }

  final refReadInvocations = <RefReadInvocation>[];
  @override
  void visitRefReadInvocation(
    RefReadInvocation node,
  ) {
    super.visitRefReadInvocation(node);
    refReadInvocations.add(node);
  }

  final refListenInvocations = <RefListenInvocation>[];
  @override
  void visitRefListenInvocation(
    RefListenInvocation node,
  ) {
    super.visitRefListenInvocation(node);
    refListenInvocations.add(node);
  }

  final widgetRefInvocations = <WidgetRefInvocation>[];
  @override
  void visitWidgetRefInvocation(
    WidgetRefInvocation node,
  ) {
    super.visitWidgetRefInvocation(node);
    widgetRefInvocations.add(node);
  }

  final widgetRefWatchInvocations = <WidgetRefWatchInvocation>[];
  @override
  void visitWidgetRefWatchInvocation(
    WidgetRefWatchInvocation node,
  ) {
    super.visitWidgetRefWatchInvocation(node);
    widgetRefWatchInvocations.add(node);
  }

  final widgetRefReadInvocations = <WidgetRefReadInvocation>[];
  @override
  void visitWidgetRefReadInvocation(
    WidgetRefReadInvocation node,
  ) {
    super.visitWidgetRefReadInvocation(node);
    widgetRefReadInvocations.add(node);
  }

  final widgetRefListenInvocations = <WidgetRefListenInvocation>[];
  @override
  void visitWidgetRefListenInvocation(
    WidgetRefListenInvocation node,
  ) {
    super.visitWidgetRefListenInvocation(node);
    widgetRefListenInvocations.add(node);
  }

  final widgetRefListenManualInvocations = <WidgetRefListenManualInvocation>[];
  @override
  void visitWidgetRefListenManualInvocation(
    WidgetRefListenManualInvocation node,
  ) {
    super.visitWidgetRefListenManualInvocation(node);
    widgetRefListenManualInvocations.add(node);
  }

  final providerOverrideExpressions = <ProviderOverrideExpression>[];
  @override
  void visitProviderOverrideExpression(
    ProviderOverrideExpression node,
  ) {
    super.visitProviderOverrideExpression(node);
    providerOverrideExpressions.add(node);
  }

  final providerOverrideLists = <ProviderOverrideList>[];
  @override
  void visitProviderOverrideList(
    ProviderOverrideList node,
  ) {
    super.visitProviderOverrideList(node);
    providerOverrideLists.add(node);
  }

  final providerContainerInstanceCreationExpressions =
      <ProviderContainerInstanceCreationExpression>[];
  @override
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression node,
  ) {
    super.visitProviderContainerInstanceCreationExpression(node);
    providerContainerInstanceCreationExpressions.add(node);
  }

  final providerScopeInstanceCreationExpressions =
      <ProviderScopeInstanceCreationExpression>[];
  @override
  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression node,
  ) {
    super.visitProviderScopeInstanceCreationExpression(node);
    providerScopeInstanceCreationExpressions.add(node);
  }
}

class RiverpodAstRegistry {
  void run(AstNode node) {
    node.accept(_RiverpodAstRegistryVisitor(this));
  }

  final _onConsumerWidgetDeclaration =
      <void Function(ConsumerWidgetDeclaration)>[];
  void addConsumerWidgetDeclaration(
      void Function(ConsumerWidgetDeclaration node) cb) {
    _onConsumerWidgetDeclaration.add(cb);
  }

  final _onHookConsumerWidgetDeclaration =
      <void Function(HookConsumerWidgetDeclaration)>[];
  void addHookConsumerWidgetDeclaration(
      void Function(HookConsumerWidgetDeclaration node) cb) {
    _onHookConsumerWidgetDeclaration.add(cb);
  }

  final _onConsumerStatefulWidgetDeclaration =
      <void Function(ConsumerStatefulWidgetDeclaration)>[];
  void addConsumerStatefulWidgetDeclaration(
      void Function(ConsumerStatefulWidgetDeclaration node) cb) {
    _onConsumerStatefulWidgetDeclaration.add(cb);
  }

  final _onStatefulHookConsumerWidgetDeclaration =
      <void Function(StatefulHookConsumerWidgetDeclaration)>[];
  void addStatefulHookConsumerWidgetDeclaration(
      void Function(StatefulHookConsumerWidgetDeclaration node) cb) {
    _onStatefulHookConsumerWidgetDeclaration.add(cb);
  }

  final _onConsumerStateDeclaration =
      <void Function(ConsumerStateDeclaration)>[];
  void addConsumerStateDeclaration(
      void Function(ConsumerStateDeclaration node) cb) {
    _onConsumerStateDeclaration.add(cb);
  }

  final _onDependenciesAnnotation = <void Function(DependenciesAnnotation)>[];
  void addDependenciesAnnotation(
      void Function(DependenciesAnnotation node) cb) {
    _onDependenciesAnnotation.add(cb);
  }

  final _onFunctionalProviderDeclaration =
      <void Function(FunctionalProviderDeclaration)>[];
  void addFunctionalProviderDeclaration(
      void Function(FunctionalProviderDeclaration node) cb) {
    _onFunctionalProviderDeclaration.add(cb);
  }

  final _onLegacyProviderDeclaration =
      <void Function(LegacyProviderDeclaration)>[];
  void addLegacyProviderDeclaration(
      void Function(LegacyProviderDeclaration node) cb) {
    _onLegacyProviderDeclaration.add(cb);
  }

  final _onClassBasedProviderDeclaration =
      <void Function(ClassBasedProviderDeclaration)>[];
  void addClassBasedProviderDeclaration(
      void Function(ClassBasedProviderDeclaration node) cb) {
    _onClassBasedProviderDeclaration.add(cb);
  }

  final _onGeneratorProviderDeclaration =
      <void Function(GeneratorProviderDeclaration)>[];
  void addGeneratorProviderDeclaration(
      void Function(GeneratorProviderDeclaration node) cb) {
    _onGeneratorProviderDeclaration.add(cb);
  }

  final _onProviderIdentifier = <void Function(ProviderIdentifier)>[];
  void addProviderIdentifier(void Function(ProviderIdentifier node) cb) {
    _onProviderIdentifier.add(cb);
  }

  final _onRiverpodAnnotation = <void Function(RiverpodAnnotation)>[];
  void addRiverpodAnnotation(void Function(RiverpodAnnotation node) cb) {
    _onRiverpodAnnotation.add(cb);
  }

  final _onProviderListenableExpression =
      <void Function(ProviderListenableExpression)>[];
  void addProviderListenableExpression(
      void Function(ProviderListenableExpression node) cb) {
    _onProviderListenableExpression.add(cb);
  }

  final _onRefInvocation = <void Function(RefInvocation)>[];
  void addRefInvocation(void Function(RefInvocation node) cb) {
    _onRefInvocation.add(cb);
  }

  final _onRefWatchInvocation = <void Function(RefWatchInvocation)>[];
  void addRefWatchInvocation(void Function(RefWatchInvocation node) cb) {
    _onRefWatchInvocation.add(cb);
  }

  final _onRefReadInvocation = <void Function(RefReadInvocation)>[];
  void addRefReadInvocation(void Function(RefReadInvocation node) cb) {
    _onRefReadInvocation.add(cb);
  }

  final _onRefListenInvocation = <void Function(RefListenInvocation)>[];
  void addRefListenInvocation(void Function(RefListenInvocation node) cb) {
    _onRefListenInvocation.add(cb);
  }

  final _onWidgetRefInvocation = <void Function(WidgetRefInvocation)>[];
  void addWidgetRefInvocation(void Function(WidgetRefInvocation node) cb) {
    _onWidgetRefInvocation.add(cb);
  }

  final _onWidgetRefWatchInvocation =
      <void Function(WidgetRefWatchInvocation)>[];
  void addWidgetRefWatchInvocation(
      void Function(WidgetRefWatchInvocation node) cb) {
    _onWidgetRefWatchInvocation.add(cb);
  }

  final _onWidgetRefReadInvocation = <void Function(WidgetRefReadInvocation)>[];
  void addWidgetRefReadInvocation(
      void Function(WidgetRefReadInvocation node) cb) {
    _onWidgetRefReadInvocation.add(cb);
  }

  final _onWidgetRefListenInvocation =
      <void Function(WidgetRefListenInvocation)>[];
  void addWidgetRefListenInvocation(
      void Function(WidgetRefListenInvocation node) cb) {
    _onWidgetRefListenInvocation.add(cb);
  }

  final _onWidgetRefListenManualInvocation =
      <void Function(WidgetRefListenManualInvocation)>[];
  void addWidgetRefListenManualInvocation(
      void Function(WidgetRefListenManualInvocation node) cb) {
    _onWidgetRefListenManualInvocation.add(cb);
  }

  final _onProviderOverrideExpression =
      <void Function(ProviderOverrideExpression)>[];
  void addProviderOverrideExpression(
      void Function(ProviderOverrideExpression node) cb) {
    _onProviderOverrideExpression.add(cb);
  }

  final _onProviderOverrideList = <void Function(ProviderOverrideList)>[];
  void addProviderOverrideList(void Function(ProviderOverrideList node) cb) {
    _onProviderOverrideList.add(cb);
  }

  final _onProviderContainerInstanceCreationExpression =
      <void Function(ProviderContainerInstanceCreationExpression)>[];
  void addProviderContainerInstanceCreationExpression(
      void Function(ProviderContainerInstanceCreationExpression node) cb) {
    _onProviderContainerInstanceCreationExpression.add(cb);
  }

  final _onProviderScopeInstanceCreationExpression =
      <void Function(ProviderScopeInstanceCreationExpression)>[];
  void addProviderScopeInstanceCreationExpression(
      void Function(ProviderScopeInstanceCreationExpression node) cb) {
    _onProviderScopeInstanceCreationExpression.add(cb);
  }
}

class _RiverpodAstRegistryVisitor extends RecursiveRiverpodAstVisitor {
  _RiverpodAstRegistryVisitor(this._registry);

  final RiverpodAstRegistry _registry;

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
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration node) {
    super.visitConsumerWidgetDeclaration(node);
    _runSubscriptions(
      node,
      _registry._onConsumerWidgetDeclaration,
    );
  }

  @override
  void visitHookConsumerWidgetDeclaration(HookConsumerWidgetDeclaration node) {
    super.visitHookConsumerWidgetDeclaration(node);
    _runSubscriptions(
      node,
      _registry._onHookConsumerWidgetDeclaration,
    );
  }

  @override
  void visitConsumerStatefulWidgetDeclaration(
      ConsumerStatefulWidgetDeclaration node) {
    super.visitConsumerStatefulWidgetDeclaration(node);
    _runSubscriptions(
      node,
      _registry._onConsumerStatefulWidgetDeclaration,
    );
  }

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
      StatefulHookConsumerWidgetDeclaration node) {
    super.visitStatefulHookConsumerWidgetDeclaration(node);
    _runSubscriptions(
      node,
      _registry._onStatefulHookConsumerWidgetDeclaration,
    );
  }

  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration node) {
    super.visitConsumerStateDeclaration(node);
    _runSubscriptions(
      node,
      _registry._onConsumerStateDeclaration,
    );
  }

  @override
  void visitDependenciesAnnotation(DependenciesAnnotation node) {
    super.visitDependenciesAnnotation(node);
    _runSubscriptions(
      node,
      _registry._onDependenciesAnnotation,
    );
  }

  @override
  void visitFunctionalProviderDeclaration(FunctionalProviderDeclaration node) {
    super.visitFunctionalProviderDeclaration(node);
    _runSubscriptions(
      node,
      _registry._onFunctionalProviderDeclaration,
    );
  }

  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration node) {
    super.visitLegacyProviderDeclaration(node);
    _runSubscriptions(
      node,
      _registry._onLegacyProviderDeclaration,
    );
  }

  @override
  void visitClassBasedProviderDeclaration(ClassBasedProviderDeclaration node) {
    super.visitClassBasedProviderDeclaration(node);
    _runSubscriptions(
      node,
      _registry._onClassBasedProviderDeclaration,
    );
  }

  @override
  void visitGeneratorProviderDeclaration(GeneratorProviderDeclaration node) {
    super.visitGeneratorProviderDeclaration(node);
    _runSubscriptions(
      node,
      _registry._onGeneratorProviderDeclaration,
    );
  }

  @override
  void visitProviderIdentifier(ProviderIdentifier node) {
    super.visitProviderIdentifier(node);
    _runSubscriptions(
      node,
      _registry._onProviderIdentifier,
    );
  }

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation node) {
    super.visitRiverpodAnnotation(node);
    _runSubscriptions(
      node,
      _registry._onRiverpodAnnotation,
    );
  }

  @override
  void visitProviderListenableExpression(ProviderListenableExpression node) {
    super.visitProviderListenableExpression(node);
    _runSubscriptions(
      node,
      _registry._onProviderListenableExpression,
    );
  }

  @override
  void visitRefInvocation(RefInvocation node) {
    super.visitRefInvocation(node);
    _runSubscriptions(
      node,
      _registry._onRefInvocation,
    );
  }

  @override
  void visitRefWatchInvocation(RefWatchInvocation node) {
    super.visitRefWatchInvocation(node);
    _runSubscriptions(
      node,
      _registry._onRefWatchInvocation,
    );
  }

  @override
  void visitRefReadInvocation(RefReadInvocation node) {
    super.visitRefReadInvocation(node);
    _runSubscriptions(
      node,
      _registry._onRefReadInvocation,
    );
  }

  @override
  void visitRefListenInvocation(RefListenInvocation node) {
    super.visitRefListenInvocation(node);
    _runSubscriptions(
      node,
      _registry._onRefListenInvocation,
    );
  }

  @override
  void visitWidgetRefInvocation(WidgetRefInvocation node) {
    super.visitWidgetRefInvocation(node);
    _runSubscriptions(
      node,
      _registry._onWidgetRefInvocation,
    );
  }

  @override
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation node) {
    super.visitWidgetRefWatchInvocation(node);
    _runSubscriptions(
      node,
      _registry._onWidgetRefWatchInvocation,
    );
  }

  @override
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation node) {
    super.visitWidgetRefReadInvocation(node);
    _runSubscriptions(
      node,
      _registry._onWidgetRefReadInvocation,
    );
  }

  @override
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation node) {
    super.visitWidgetRefListenInvocation(node);
    _runSubscriptions(
      node,
      _registry._onWidgetRefListenInvocation,
    );
  }

  @override
  void visitWidgetRefListenManualInvocation(
      WidgetRefListenManualInvocation node) {
    super.visitWidgetRefListenManualInvocation(node);
    _runSubscriptions(
      node,
      _registry._onWidgetRefListenManualInvocation,
    );
  }

  @override
  void visitProviderOverrideExpression(ProviderOverrideExpression node) {
    super.visitProviderOverrideExpression(node);
    _runSubscriptions(
      node,
      _registry._onProviderOverrideExpression,
    );
  }

  @override
  void visitProviderOverrideList(ProviderOverrideList node) {
    super.visitProviderOverrideList(node);
    _runSubscriptions(
      node,
      _registry._onProviderOverrideList,
    );
  }

  @override
  void visitProviderContainerInstanceCreationExpression(
      ProviderContainerInstanceCreationExpression node) {
    super.visitProviderContainerInstanceCreationExpression(node);
    _runSubscriptions(
      node,
      _registry._onProviderContainerInstanceCreationExpression,
    );
  }

  @override
  void visitProviderScopeInstanceCreationExpression(
      ProviderScopeInstanceCreationExpression node) {
    super.visitProviderScopeInstanceCreationExpression(node);
    _runSubscriptions(
      node,
      _registry._onProviderScopeInstanceCreationExpression,
    );
  }
}

// ignore_for_file: type=lint
