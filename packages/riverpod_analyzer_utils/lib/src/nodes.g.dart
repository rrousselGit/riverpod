// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nodes.dart';

// **************************************************************************
// _LintVisitorGenerator
// **************************************************************************

mixin RiverpodAstVisitor {
  void visitWidgetDeclaration(WidgetDeclaration node) {}
  void visitStateDeclaration(StateDeclaration node) {}
  void visitDependenciesAnnotation(DependenciesAnnotation node) {}
  void visitAccumulatedDependencyList(AccumulatedDependencyList node) {}
  void visitIdentifierDependencies(IdentifierDependencies node) {}
  void visitNamedTypeDependencies(NamedTypeDependencies node) {}
  void visitFunctionalProviderDeclaration(FunctionalProviderDeclaration node) {}
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration node) {}
  void visitClassBasedProviderDeclaration(ClassBasedProviderDeclaration node) {}
  void visitGeneratorProviderDeclaration(GeneratorProviderDeclaration node) {}
  void visitProviderIdentifier(ProviderIdentifier node) {}
  void visitRiverpodAnnotation(RiverpodAnnotation node) {}
  void visitProviderListenableExpression(ProviderListenableExpression node) {}
  void visitRefInvocation(RefInvocation node) {}
  void visitRefDependencyInvocation(RefDependencyInvocation node) {}
  void visitRefWatchInvocation(RefWatchInvocation node) {}
  void visitRefReadInvocation(RefReadInvocation node) {}
  void visitRefListenInvocation(RefListenInvocation node) {}
  void visitWidgetRefInvocation(WidgetRefInvocation node) {}
  void visitWidgetRefDependencyInvocation(WidgetRefDependencyInvocation node) {}
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
  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);
    node.widget.let(visitWidgetDeclaration);
    node.state.let(visitStateDeclaration);
    node.provider.let(visitClassBasedProviderDeclaration);
  }

  @override
  void visitAnnotatedNode(AnnotatedNode node) {
    super.visitAnnotatedNode(node);
    node.dependencies.let(visitDependenciesAnnotation);
    node.riverpod.let(visitRiverpodAnnotation);
  }

  @override
  void visitNode(AstNode node) {
    super.visitNode(node);
    node.accumulatedDependencies.let(visitAccumulatedDependencyList);
  }

  @override
  void visitIdentifier(Identifier node) {
    super.visitIdentifier(node);
    node.identifierDependencies.let(visitIdentifierDependencies);
  }

  @override
  void visitNamedType(NamedType node) {
    super.visitNamedType(node);
    node.typeAnnotationDependencies.let(visitNamedTypeDependencies);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);
    node.provider.let(visitFunctionalProviderDeclaration);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);
    node.provider.let(visitLegacyProviderDeclaration);
  }

  @override
  void visitDeclaration(Declaration node) {
    super.visitDeclaration(node);
    node.provider.let(visitGeneratorProviderDeclaration);
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    super.visitSimpleIdentifier(node);
    node.provider.let(visitProviderIdentifier);
  }

  @override
  void visitExpression(Expression node) {
    super.visitExpression(node);
    node.providerListenable.let(visitProviderListenableExpression);
    node.overrides.let(visitProviderOverrideList);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);
    node.refInvocation.let(visitRefInvocation);
    node.refDependencyInvocation.let(visitRefDependencyInvocation);
    node.refWatchInvocation.let(visitRefWatchInvocation);
    node.refReadInvocation.let(visitRefReadInvocation);
    node.refListenInvocation.let(visitRefListenInvocation);
    node.widgetRefInvocation.let(visitWidgetRefInvocation);
    node.widgetRefDependencyInvocation.let(visitWidgetRefDependencyInvocation);
    node.widgetRefWatchInvocation.let(visitWidgetRefWatchInvocation);
    node.widgetRefReadInvocation.let(visitWidgetRefReadInvocation);
    node.widgetRefListenInvocation.let(visitWidgetRefListenInvocation);
    node.widgetRefListenManualInvocation
        .let(visitWidgetRefListenManualInvocation);
  }

  @override
  void visitCollectionElement(CollectionElement node) {
    super.visitCollectionElement(node);
    node.providerOverride.let(visitProviderOverrideExpression);
  }

  @override
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
  void visitWidgetDeclaration(WidgetDeclaration node) =>
      throw UnimplementedError();
  void visitStateDeclaration(StateDeclaration node) =>
      throw UnimplementedError();
  void visitDependenciesAnnotation(DependenciesAnnotation node) =>
      throw UnimplementedError();
  void visitAccumulatedDependencyList(AccumulatedDependencyList node) =>
      throw UnimplementedError();
  void visitIdentifierDependencies(IdentifierDependencies node) =>
      throw UnimplementedError();
  void visitNamedTypeDependencies(NamedTypeDependencies node) =>
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
  void visitRefDependencyInvocation(RefDependencyInvocation node) =>
      throw UnimplementedError();
  void visitRefWatchInvocation(RefWatchInvocation node) =>
      throw UnimplementedError();
  void visitRefReadInvocation(RefReadInvocation node) =>
      throw UnimplementedError();
  void visitRefListenInvocation(RefListenInvocation node) =>
      throw UnimplementedError();
  void visitWidgetRefInvocation(WidgetRefInvocation node) =>
      throw UnimplementedError();
  void visitWidgetRefDependencyInvocation(WidgetRefDependencyInvocation node) =>
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

  final widgetDeclarations = <WidgetDeclaration>[];
  @override
  void visitWidgetDeclaration(
    WidgetDeclaration node,
  ) {
    super.visitWidgetDeclaration(node);
    widgetDeclarations.add(node);
  }

  final stateDeclarations = <StateDeclaration>[];
  @override
  void visitStateDeclaration(
    StateDeclaration node,
  ) {
    super.visitStateDeclaration(node);
    stateDeclarations.add(node);
  }

  final dependenciesAnnotations = <DependenciesAnnotation>[];
  @override
  void visitDependenciesAnnotation(
    DependenciesAnnotation node,
  ) {
    super.visitDependenciesAnnotation(node);
    dependenciesAnnotations.add(node);
  }

  final accumulatedDependencyLists = <AccumulatedDependencyList>[];
  @override
  void visitAccumulatedDependencyList(
    AccumulatedDependencyList node,
  ) {
    super.visitAccumulatedDependencyList(node);
    accumulatedDependencyLists.add(node);
  }

  final identifierDependenciesList = <IdentifierDependencies>[];
  @override
  void visitIdentifierDependencies(
    IdentifierDependencies node,
  ) {
    super.visitIdentifierDependencies(node);
    identifierDependenciesList.add(node);
  }

  final namedTypeDependenciesList = <NamedTypeDependencies>[];
  @override
  void visitNamedTypeDependencies(
    NamedTypeDependencies node,
  ) {
    super.visitNamedTypeDependencies(node);
    namedTypeDependenciesList.add(node);
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

  final refDependencyInvocations = <RefDependencyInvocation>[];
  @override
  void visitRefDependencyInvocation(
    RefDependencyInvocation node,
  ) {
    super.visitRefDependencyInvocation(node);
    refDependencyInvocations.add(node);
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

  final widgetRefDependencyInvocations = <WidgetRefDependencyInvocation>[];
  @override
  void visitWidgetRefDependencyInvocation(
    WidgetRefDependencyInvocation node,
  ) {
    super.visitWidgetRefDependencyInvocation(node);
    widgetRefDependencyInvocations.add(node);
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
    final previousErrorReporter = errorReporter;
    try {
      final errors = node.upsert(
        'RiverpodAstRegistry.errors',
        () => <RiverpodAnalysisError>[],
      );

      final visitor = _RiverpodAstRegistryVisitor(this);
      errorReporter = errors.add;

      node.accept(visitor);
      for (final error in errors) {
        visitor._runSubscriptions(error, _onRiverpodAnalysisError);
      }
    } finally {
      errorReporter = previousErrorReporter;
    }
  }

  final _onRiverpodAnalysisError = <void Function(RiverpodAnalysisError)>[];
  void addRiverpodAnalysisError(
    void Function(RiverpodAnalysisError node) cb,
  ) {
    _onRiverpodAnalysisError.add(cb);
  }

  final _onWidgetDeclaration = <void Function(WidgetDeclaration)>[];
  void addWidgetDeclaration(void Function(WidgetDeclaration node) cb) {
    _onWidgetDeclaration.add(cb);
  }

  final _onStateDeclaration = <void Function(StateDeclaration)>[];
  void addStateDeclaration(void Function(StateDeclaration node) cb) {
    _onStateDeclaration.add(cb);
  }

  final _onDependenciesAnnotation = <void Function(DependenciesAnnotation)>[];
  void addDependenciesAnnotation(
      void Function(DependenciesAnnotation node) cb) {
    _onDependenciesAnnotation.add(cb);
  }

  final _onAccumulatedDependencyList =
      <void Function(AccumulatedDependencyList)>[];
  void addAccumulatedDependencyList(
      void Function(AccumulatedDependencyList node) cb) {
    _onAccumulatedDependencyList.add(cb);
  }

  final _onIdentifierDependencies = <void Function(IdentifierDependencies)>[];
  void addIdentifierDependencies(
      void Function(IdentifierDependencies node) cb) {
    _onIdentifierDependencies.add(cb);
  }

  final _onNamedTypeDependencies = <void Function(NamedTypeDependencies)>[];
  void addNamedTypeDependencies(void Function(NamedTypeDependencies node) cb) {
    _onNamedTypeDependencies.add(cb);
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

  final _onRefDependencyInvocation = <void Function(RefDependencyInvocation)>[];
  void addRefDependencyInvocation(
      void Function(RefDependencyInvocation node) cb) {
    _onRefDependencyInvocation.add(cb);
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

  final _onWidgetRefDependencyInvocation =
      <void Function(WidgetRefDependencyInvocation)>[];
  void addWidgetRefDependencyInvocation(
      void Function(WidgetRefDependencyInvocation node) cb) {
    _onWidgetRefDependencyInvocation.add(cb);
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
  void visitWidgetDeclaration(WidgetDeclaration node) {
    super.visitWidgetDeclaration(node);
    _runSubscriptions(
      node,
      _registry._onWidgetDeclaration,
    );
  }

  @override
  void visitStateDeclaration(StateDeclaration node) {
    super.visitStateDeclaration(node);
    _runSubscriptions(
      node,
      _registry._onStateDeclaration,
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
  void visitAccumulatedDependencyList(AccumulatedDependencyList node) {
    super.visitAccumulatedDependencyList(node);
    _runSubscriptions(
      node,
      _registry._onAccumulatedDependencyList,
    );
  }

  @override
  void visitIdentifierDependencies(IdentifierDependencies node) {
    super.visitIdentifierDependencies(node);
    _runSubscriptions(
      node,
      _registry._onIdentifierDependencies,
    );
  }

  @override
  void visitNamedTypeDependencies(NamedTypeDependencies node) {
    super.visitNamedTypeDependencies(node);
    _runSubscriptions(
      node,
      _registry._onNamedTypeDependencies,
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
  void visitRefDependencyInvocation(RefDependencyInvocation node) {
    super.visitRefDependencyInvocation(node);
    _runSubscriptions(
      node,
      _registry._onRefDependencyInvocation,
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
  void visitWidgetRefDependencyInvocation(WidgetRefDependencyInvocation node) {
    super.visitWidgetRefDependencyInvocation(node);
    _runSubscriptions(
      node,
      _registry._onWidgetRefDependencyInvocation,
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
