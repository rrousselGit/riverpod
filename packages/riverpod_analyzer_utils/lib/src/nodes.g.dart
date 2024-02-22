// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nodes.dart';

// **************************************************************************
// _LintVisitorGenerator
// **************************************************************************

mixin RiverpodAstVisitor {
  void visitDependenciesAnnotation(DependenciesAnnotation node) {}
  void visitFunctionalProviderDeclaration(FunctionalProviderDeclaration node) {}
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration node) {}
  void visitClassBasedProviderDeclaration(ClassBasedProviderDeclaration node) {}
  void visitGeneratorProviderDeclaration(GeneratorProviderDeclaration node) {}
  void visitProviderIdentifier(ProviderIdentifier node) {}
  void visitRiverpodAnnotation(RiverpodAnnotation node) {}
}

abstract class RecursiveRiverpodAstVisitor extends GeneralizingAstVisitor<void>
    with RiverpodAstVisitor {
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

  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);
    node.provider.let(visitClassBasedProviderDeclaration);
  }

  void visitDeclaration(Declaration node) {
    super.visitDeclaration(node);
    node.provider.let(visitGeneratorProviderDeclaration);
  }

  void visitSimpleIdentifier(SimpleIdentifier node) {
    super.visitSimpleIdentifier(node);
    node.provider.let(visitProviderIdentifier);
  }
}

abstract class SimpleRiverpodAstVisitor extends RecursiveRiverpodAstVisitor {
  @override
  void visitNode(AstNode node) {}
}

abstract class UnimplementedRiverpodAstVisitor
    extends SimpleRiverpodAstVisitor {
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
}

@internal
class RiverpodAnalysisResult extends RecursiveRiverpodAstVisitor {
  final List<RiverpodAnalysisError> errors = [];

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
}

class RiverpodAstRegistry {
  void run(AstNode node) {
    node.accept(_RiverpodAstRegistryVisitor(this));
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
}

// ignore_for_file: type=lint
