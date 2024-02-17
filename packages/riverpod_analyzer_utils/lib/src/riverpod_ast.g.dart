// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod_ast.dart';

// **************************************************************************
// _LintVisitorGenerator
// **************************************************************************

base mixin _$ConsumerDeclaration on RiverpodAst {}

base mixin _$ConsumerWidgetDeclaration on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerWidgetDeclaration(
      this as ConsumerWidgetDeclaration,
    );
  }
}

base mixin _$HookConsumerWidgetDeclaration on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitHookConsumerWidgetDeclaration(
      this as HookConsumerWidgetDeclaration,
    );
  }
}

base mixin _$ConsumerStatefulWidgetDeclaration on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerStatefulWidgetDeclaration(
      this as ConsumerStatefulWidgetDeclaration,
    );
  }
}

base mixin _$StatefulHookConsumerWidgetDeclaration on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitStatefulHookConsumerWidgetDeclaration(
      this as StatefulHookConsumerWidgetDeclaration,
    );
  }
}

base mixin _$ConsumerStateDeclaration on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerStateDeclaration(
      this as ConsumerStateDeclaration,
    );
  }
}

base mixin _$GeneratorProviderDeclaration on RiverpodAst {
  RiverpodAnnotation get annotation;

  @mustCallSuper
  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    annotation.accept(visitor);
  }
}

base mixin _$ClassBasedProviderDeclaration on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitClassBasedProviderDeclaration(
      this as ClassBasedProviderDeclaration,
    );
  }
}

base mixin _$FunctionalProviderDeclaration on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitFunctionalProviderDeclaration(
      this as FunctionalProviderDeclaration,
    );
  }
}

base mixin _$LegacyProviderDependencies on RiverpodAst {
  List<LegacyProviderDependency>? get dependencies;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitLegacyProviderDependencies(
      this as LegacyProviderDependencies,
    );
  }

  @mustCallSuper
  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    if (dependencies case final dependencies?) {
      for (final value in dependencies) {
        value.accept(visitor);
      }
    }
  }
}

base mixin _$LegacyProviderDependency on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitLegacyProviderDependency(
      this as LegacyProviderDependency,
    );
  }
}

base mixin _$LegacyProviderDeclaration on RiverpodAst {
  LegacyProviderDependencies? get dependencies;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitLegacyProviderDeclaration(
      this as LegacyProviderDeclaration,
    );
  }

  @mustCallSuper
  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    dependencies?.accept(visitor);
  }
}

base mixin _$ProviderDeclaration on RiverpodAst {}

base mixin _$RiverpodCompilationUnit on RiverpodAst {
  List<FunctionalProviderDeclaration> get functionalProviderDeclarations;
  List<ClassBasedProviderDeclaration> get classBasedProviderDeclarations;
  List<LegacyProviderDeclaration> get legacyProviderDeclarations;
  List<ConsumerWidgetDeclaration> get consumerWidgetDeclarations;
  List<ConsumerStatefulWidgetDeclaration>
      get consumerStatefulWidgetDeclarations;
  List<ConsumerStateDeclaration> get consumerStateDeclaration;
  List<StatefulHookConsumerWidgetDeclaration>
      get statefulHookConsumerWidgetDeclarations;
  List<HookConsumerWidgetDeclaration> get hookConsumerWidgetDeclarations;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRiverpodCompilationUnit(
      this as RiverpodCompilationUnit,
    );
  }

  @mustCallSuper
  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);

    for (final value in functionalProviderDeclarations) {
      value.accept(visitor);
    }

    for (final value in classBasedProviderDeclarations) {
      value.accept(visitor);
    }

    for (final value in legacyProviderDeclarations) {
      value.accept(visitor);
    }

    for (final value in consumerWidgetDeclarations) {
      value.accept(visitor);
    }

    for (final value in consumerStatefulWidgetDeclarations) {
      value.accept(visitor);
    }

    for (final value in consumerStateDeclaration) {
      value.accept(visitor);
    }

    for (final value in statefulHookConsumerWidgetDeclarations) {
      value.accept(visitor);
    }

    for (final value in hookConsumerWidgetDeclarations) {
      value.accept(visitor);
    }
  }
}

base mixin _$RiverpodAnnotationDependency on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRiverpodAnnotationDependency(
      this as RiverpodAnnotationDependency,
    );
  }
}

base mixin _$RiverpodAnnotationDependencies on RiverpodAst {
  List<RiverpodAnnotationDependency>? get dependencies;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRiverpodAnnotationDependencies(
      this as RiverpodAnnotationDependencies,
    );
  }

  @mustCallSuper
  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    if (dependencies case final dependencies?) {
      for (final value in dependencies) {
        value.accept(visitor);
      }
    }
  }
}

base mixin _$RiverpodAnnotation on RiverpodAst {
  RiverpodAnnotationDependencies? get dependencies;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRiverpodAnnotation(
      this as RiverpodAnnotation,
    );
  }

  @mustCallSuper
  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    dependencies?.accept(visitor);
  }
}

abstract class RiverpodAstVisitor {
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration node);

  void visitHookConsumerWidgetDeclaration(HookConsumerWidgetDeclaration node);

  void visitConsumerStatefulWidgetDeclaration(
      ConsumerStatefulWidgetDeclaration node);

  void visitStatefulHookConsumerWidgetDeclaration(
      StatefulHookConsumerWidgetDeclaration node);

  void visitConsumerStateDeclaration(ConsumerStateDeclaration node);

  void visitClassBasedProviderDeclaration(ClassBasedProviderDeclaration node);

  void visitFunctionalProviderDeclaration(FunctionalProviderDeclaration node);

  void visitLegacyProviderDependencies(LegacyProviderDependencies node);

  void visitLegacyProviderDependency(LegacyProviderDependency node);

  void visitLegacyProviderDeclaration(LegacyProviderDeclaration node);

  void visitRiverpodCompilationUnit(RiverpodCompilationUnit node);

  void visitRiverpodAnnotationDependency(RiverpodAnnotationDependency node);

  void visitRiverpodAnnotationDependencies(RiverpodAnnotationDependencies node);

  void visitRiverpodAnnotation(RiverpodAnnotation node);
}

abstract class GeneralizingRiverpodAstVisitor implements RiverpodAstVisitor {
  void visitRiverpodAst(RiverpodAst node) {
    node.visitChildren(this);
  }

  void visitConsumerDeclaration(ConsumerDeclaration node) {
    visitRiverpodAst(node);
  }

  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration node) {
    visitConsumerDeclaration(node);
  }

  @override
  void visitHookConsumerWidgetDeclaration(HookConsumerWidgetDeclaration node) {
    visitConsumerDeclaration(node);
  }

  @override
  void visitConsumerStatefulWidgetDeclaration(
      ConsumerStatefulWidgetDeclaration node) {
    visitConsumerDeclaration(node);
  }

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
      StatefulHookConsumerWidgetDeclaration node) {
    visitConsumerDeclaration(node);
  }

  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration node) {
    visitConsumerDeclaration(node);
  }

  void visitGeneratorProviderDeclaration(GeneratorProviderDeclaration node) {
    visitProviderDeclaration(node);
  }

  @override
  void visitClassBasedProviderDeclaration(ClassBasedProviderDeclaration node) {
    visitGeneratorProviderDeclaration(node);
    visitProviderDeclaration(node);
  }

  @override
  void visitFunctionalProviderDeclaration(FunctionalProviderDeclaration node) {
    visitGeneratorProviderDeclaration(node);
    visitProviderDeclaration(node);
  }

  @override
  void visitLegacyProviderDependencies(LegacyProviderDependencies node) {
    visitRiverpodAst(node);
  }

  @override
  void visitLegacyProviderDependency(LegacyProviderDependency node) {
    visitRiverpodAst(node);
  }

  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration node) {
    visitProviderDeclaration(node);
  }

  void visitProviderDeclaration(ProviderDeclaration node) {
    visitRiverpodAst(node);
  }

  @override
  void visitRiverpodCompilationUnit(RiverpodCompilationUnit node) {
    visitRiverpodAst(node);
  }

  @override
  void visitRiverpodAnnotationDependency(RiverpodAnnotationDependency node) {
    visitRiverpodAst(node);
  }

  @override
  void visitRiverpodAnnotationDependencies(
      RiverpodAnnotationDependencies node) {
    visitRiverpodAst(node);
  }

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation node) {
    visitRiverpodAst(node);
  }
}

abstract class RecursiveRiverpodAstVisitor implements RiverpodAstVisitor {
  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration node) {
    node.visitChildren(this);
  }

  @override
  void visitHookConsumerWidgetDeclaration(HookConsumerWidgetDeclaration node) {
    node.visitChildren(this);
  }

  @override
  void visitConsumerStatefulWidgetDeclaration(
      ConsumerStatefulWidgetDeclaration node) {
    node.visitChildren(this);
  }

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
      StatefulHookConsumerWidgetDeclaration node) {
    node.visitChildren(this);
  }

  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration node) {
    node.visitChildren(this);
  }

  @override
  void visitClassBasedProviderDeclaration(ClassBasedProviderDeclaration node) {
    node.visitChildren(this);
  }

  @override
  void visitFunctionalProviderDeclaration(FunctionalProviderDeclaration node) {
    node.visitChildren(this);
  }

  @override
  void visitLegacyProviderDependencies(LegacyProviderDependencies node) {
    node.visitChildren(this);
  }

  @override
  void visitLegacyProviderDependency(LegacyProviderDependency node) {
    node.visitChildren(this);
  }

  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration node) {
    node.visitChildren(this);
  }

  @override
  void visitRiverpodCompilationUnit(RiverpodCompilationUnit node) {
    node.visitChildren(this);
  }

  @override
  void visitRiverpodAnnotationDependency(RiverpodAnnotationDependency node) {
    node.visitChildren(this);
  }

  @override
  void visitRiverpodAnnotationDependencies(
      RiverpodAnnotationDependencies node) {
    node.visitChildren(this);
  }

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation node) {
    node.visitChildren(this);
  }
}

abstract class SimpleRiverpodAstVisitor implements RiverpodAstVisitor {
  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration node) {}

  @override
  void visitHookConsumerWidgetDeclaration(HookConsumerWidgetDeclaration node) {}

  @override
  void visitConsumerStatefulWidgetDeclaration(
      ConsumerStatefulWidgetDeclaration node) {}

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
      StatefulHookConsumerWidgetDeclaration node) {}

  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration node) {}

  @override
  void visitClassBasedProviderDeclaration(ClassBasedProviderDeclaration node) {}

  @override
  void visitFunctionalProviderDeclaration(FunctionalProviderDeclaration node) {}

  @override
  void visitLegacyProviderDependencies(LegacyProviderDependencies node) {}

  @override
  void visitLegacyProviderDependency(LegacyProviderDependency node) {}

  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration node) {}

  @override
  void visitRiverpodCompilationUnit(RiverpodCompilationUnit node) {}

  @override
  void visitRiverpodAnnotationDependency(RiverpodAnnotationDependency node) {}

  @override
  void visitRiverpodAnnotationDependencies(
      RiverpodAnnotationDependencies node) {}

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation node) {}
}

abstract class UnimplementedRiverpodAstVisitor implements RiverpodAstVisitor {
  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration node) {
    throw UnimplementedError();
  }

  @override
  void visitHookConsumerWidgetDeclaration(HookConsumerWidgetDeclaration node) {
    throw UnimplementedError();
  }

  @override
  void visitConsumerStatefulWidgetDeclaration(
      ConsumerStatefulWidgetDeclaration node) {
    throw UnimplementedError();
  }

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
      StatefulHookConsumerWidgetDeclaration node) {
    throw UnimplementedError();
  }

  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration node) {
    throw UnimplementedError();
  }

  @override
  void visitClassBasedProviderDeclaration(ClassBasedProviderDeclaration node) {
    throw UnimplementedError();
  }

  @override
  void visitFunctionalProviderDeclaration(FunctionalProviderDeclaration node) {
    throw UnimplementedError();
  }

  @override
  void visitLegacyProviderDependencies(LegacyProviderDependencies node) {
    throw UnimplementedError();
  }

  @override
  void visitLegacyProviderDependency(LegacyProviderDependency node) {
    throw UnimplementedError();
  }

  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration node) {
    throw UnimplementedError();
  }

  @override
  void visitRiverpodCompilationUnit(RiverpodCompilationUnit node) {
    throw UnimplementedError();
  }

  @override
  void visitRiverpodAnnotationDependency(RiverpodAnnotationDependency node) {
    throw UnimplementedError();
  }

  @override
  void visitRiverpodAnnotationDependencies(
      RiverpodAnnotationDependencies node) {
    throw UnimplementedError();
  }

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation node) {
    throw UnimplementedError();
  }
}

@internal
class RiverpodAnalysisResult extends GeneralizingRiverpodAstVisitor {
  final consumerDeclarations = <ConsumerDeclaration>[];
  @override
  void visitConsumerDeclaration(
    ConsumerDeclaration node,
  ) {
    super.visitConsumerDeclaration(node);
    consumerDeclarations.add(node);
  }

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

  final generatorProviderDeclarations = <GeneratorProviderDeclaration>[];
  @override
  void visitGeneratorProviderDeclaration(
    GeneratorProviderDeclaration node,
  ) {
    super.visitGeneratorProviderDeclaration(node);
    generatorProviderDeclarations.add(node);
  }

  final classBasedProviderDeclarations = <ClassBasedProviderDeclaration>[];
  @override
  void visitClassBasedProviderDeclaration(
    ClassBasedProviderDeclaration node,
  ) {
    super.visitClassBasedProviderDeclaration(node);
    classBasedProviderDeclarations.add(node);
  }

  final functionalProviderDeclarations = <FunctionalProviderDeclaration>[];
  @override
  void visitFunctionalProviderDeclaration(
    FunctionalProviderDeclaration node,
  ) {
    super.visitFunctionalProviderDeclaration(node);
    functionalProviderDeclarations.add(node);
  }

  final legacyProviderDependenciess = <LegacyProviderDependencies>[];
  @override
  void visitLegacyProviderDependencies(
    LegacyProviderDependencies node,
  ) {
    super.visitLegacyProviderDependencies(node);
    legacyProviderDependenciess.add(node);
  }

  final legacyProviderDependencys = <LegacyProviderDependency>[];
  @override
  void visitLegacyProviderDependency(
    LegacyProviderDependency node,
  ) {
    super.visitLegacyProviderDependency(node);
    legacyProviderDependencys.add(node);
  }

  final legacyProviderDeclarations = <LegacyProviderDeclaration>[];
  @override
  void visitLegacyProviderDeclaration(
    LegacyProviderDeclaration node,
  ) {
    super.visitLegacyProviderDeclaration(node);
    legacyProviderDeclarations.add(node);
  }

  final providerDeclarations = <ProviderDeclaration>[];
  @override
  void visitProviderDeclaration(
    ProviderDeclaration node,
  ) {
    super.visitProviderDeclaration(node);
    providerDeclarations.add(node);
  }

  final riverpodCompilationUnits = <RiverpodCompilationUnit>[];
  @override
  void visitRiverpodCompilationUnit(
    RiverpodCompilationUnit node,
  ) {
    super.visitRiverpodCompilationUnit(node);
    riverpodCompilationUnits.add(node);
  }

  final riverpodAnnotationDependencys = <RiverpodAnnotationDependency>[];
  @override
  void visitRiverpodAnnotationDependency(
    RiverpodAnnotationDependency node,
  ) {
    super.visitRiverpodAnnotationDependency(node);
    riverpodAnnotationDependencys.add(node);
  }

  final riverpodAnnotationDependenciess = <RiverpodAnnotationDependencies>[];
  @override
  void visitRiverpodAnnotationDependencies(
    RiverpodAnnotationDependencies node,
  ) {
    super.visitRiverpodAnnotationDependencies(node);
    riverpodAnnotationDependenciess.add(node);
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

class _RiverpodAstRegistryVisitor extends GeneralizingRiverpodAstVisitor {
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
  void visitRiverpodAst(RiverpodAst node) {
    node.visitChildren(this);
  }

  @override
  void visitConsumerDeclaration(ConsumerDeclaration node) {
    super.visitConsumerDeclaration(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onConsumerDeclaration,
    );
  }

  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration node) {
    super.visitConsumerWidgetDeclaration(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onConsumerWidgetDeclaration,
    );
  }

  @override
  void visitHookConsumerWidgetDeclaration(HookConsumerWidgetDeclaration node) {
    super.visitHookConsumerWidgetDeclaration(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onHookConsumerWidgetDeclaration,
    );
  }

  @override
  void visitConsumerStatefulWidgetDeclaration(
      ConsumerStatefulWidgetDeclaration node) {
    super.visitConsumerStatefulWidgetDeclaration(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onConsumerStatefulWidgetDeclaration,
    );
  }

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
      StatefulHookConsumerWidgetDeclaration node) {
    super.visitStatefulHookConsumerWidgetDeclaration(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onStatefulHookConsumerWidgetDeclaration,
    );
  }

  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration node) {
    super.visitConsumerStateDeclaration(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onConsumerStateDeclaration,
    );
  }

  @override
  void visitGeneratorProviderDeclaration(GeneratorProviderDeclaration node) {
    super.visitGeneratorProviderDeclaration(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onGeneratorProviderDeclaration,
    );
  }

  @override
  void visitClassBasedProviderDeclaration(ClassBasedProviderDeclaration node) {
    super.visitClassBasedProviderDeclaration(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onClassBasedProviderDeclaration,
    );
  }

  @override
  void visitFunctionalProviderDeclaration(FunctionalProviderDeclaration node) {
    super.visitFunctionalProviderDeclaration(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onFunctionalProviderDeclaration,
    );
  }

  @override
  void visitLegacyProviderDependencies(LegacyProviderDependencies node) {
    super.visitLegacyProviderDependencies(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onLegacyProviderDependencies,
    );
  }

  @override
  void visitLegacyProviderDependency(LegacyProviderDependency node) {
    super.visitLegacyProviderDependency(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onLegacyProviderDependency,
    );
  }

  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration node) {
    super.visitLegacyProviderDeclaration(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onLegacyProviderDeclaration,
    );
  }

  @override
  void visitProviderDeclaration(ProviderDeclaration node) {
    super.visitProviderDeclaration(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onProviderDeclaration,
    );
  }

  @override
  void visitRiverpodCompilationUnit(RiverpodCompilationUnit node) {
    super.visitRiverpodCompilationUnit(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onRiverpodCompilationUnit,
    );
  }

  @override
  void visitRiverpodAnnotationDependency(RiverpodAnnotationDependency node) {
    super.visitRiverpodAnnotationDependency(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onRiverpodAnnotationDependency,
    );
  }

  @override
  void visitRiverpodAnnotationDependencies(
      RiverpodAnnotationDependencies node) {
    super.visitRiverpodAnnotationDependencies(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onRiverpodAnnotationDependencies,
    );
  }

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation node) {
    super.visitRiverpodAnnotation(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onRiverpodAnnotation,
    );
  }
}

class RiverpodAstRegistry {
  void run(RiverpodAst node) {
    node.accept(_RiverpodAstRegistryVisitor(this));
  }

  final _onRiverpodAst = <void Function(RiverpodAst)>[];
  void addRiverpodAst(void Function(RiverpodAst node) cb) {
    _onRiverpodAst.add(cb);
  }

  final _onConsumerDeclaration = <void Function(ConsumerDeclaration)>[];
  void addConsumerDeclaration(void Function(ConsumerDeclaration node) cb) {
    _onConsumerDeclaration.add(cb);
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

  final _onGeneratorProviderDeclaration =
      <void Function(GeneratorProviderDeclaration)>[];
  void addGeneratorProviderDeclaration(
      void Function(GeneratorProviderDeclaration node) cb) {
    _onGeneratorProviderDeclaration.add(cb);
  }

  final _onClassBasedProviderDeclaration =
      <void Function(ClassBasedProviderDeclaration)>[];
  void addClassBasedProviderDeclaration(
      void Function(ClassBasedProviderDeclaration node) cb) {
    _onClassBasedProviderDeclaration.add(cb);
  }

  final _onFunctionalProviderDeclaration =
      <void Function(FunctionalProviderDeclaration)>[];
  void addFunctionalProviderDeclaration(
      void Function(FunctionalProviderDeclaration node) cb) {
    _onFunctionalProviderDeclaration.add(cb);
  }

  final _onLegacyProviderDependencies =
      <void Function(LegacyProviderDependencies)>[];
  void addLegacyProviderDependencies(
      void Function(LegacyProviderDependencies node) cb) {
    _onLegacyProviderDependencies.add(cb);
  }

  final _onLegacyProviderDependency =
      <void Function(LegacyProviderDependency)>[];
  void addLegacyProviderDependency(
      void Function(LegacyProviderDependency node) cb) {
    _onLegacyProviderDependency.add(cb);
  }

  final _onLegacyProviderDeclaration =
      <void Function(LegacyProviderDeclaration)>[];
  void addLegacyProviderDeclaration(
      void Function(LegacyProviderDeclaration node) cb) {
    _onLegacyProviderDeclaration.add(cb);
  }

  final _onProviderDeclaration = <void Function(ProviderDeclaration)>[];
  void addProviderDeclaration(void Function(ProviderDeclaration node) cb) {
    _onProviderDeclaration.add(cb);
  }

  final _onRiverpodCompilationUnit = <void Function(RiverpodCompilationUnit)>[];
  void addRiverpodCompilationUnit(
      void Function(RiverpodCompilationUnit node) cb) {
    _onRiverpodCompilationUnit.add(cb);
  }

  final _onRiverpodAnnotationDependency =
      <void Function(RiverpodAnnotationDependency)>[];
  void addRiverpodAnnotationDependency(
      void Function(RiverpodAnnotationDependency node) cb) {
    _onRiverpodAnnotationDependency.add(cb);
  }

  final _onRiverpodAnnotationDependencies =
      <void Function(RiverpodAnnotationDependencies)>[];
  void addRiverpodAnnotationDependencies(
      void Function(RiverpodAnnotationDependencies node) cb) {
    _onRiverpodAnnotationDependencies.add(cb);
  }

  final _onRiverpodAnnotation = <void Function(RiverpodAnnotation)>[];
  void addRiverpodAnnotation(void Function(RiverpodAnnotation node) cb) {
    _onRiverpodAnnotation.add(cb);
  }
}

// ignore_for_file: type=lint
