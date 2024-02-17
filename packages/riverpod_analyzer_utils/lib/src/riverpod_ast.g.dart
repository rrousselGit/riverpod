// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod_ast.dart';

// **************************************************************************
// _LintVisitorGenerator
// **************************************************************************

base mixin _$DependenciesAnnotationDependency on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitDependenciesAnnotationDependency(
      this as DependenciesAnnotationDependency,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

base mixin _$DependenciesAnnotation on RiverpodAst {
  List<DependenciesAnnotationDependency>? get dependencies;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitDependenciesAnnotation(
      this as DependenciesAnnotation,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    if (dependencies case final dependencies?) {
      for (final value in dependencies) {
        value.accept(visitor);
      }
    }
  }
}

base mixin _$ConsumerDeclaration on RiverpodAst {
  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

base mixin _$ConsumerWidgetDeclaration on RiverpodAst {
  List<WidgetRefInvocation> get widgetRefInvocations;
  List<ProviderScopeInstanceCreationExpression>
      get providerScopeInstanceCreateExpressions;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerWidgetDeclaration(
      this as ConsumerWidgetDeclaration,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);

    for (final value in widgetRefInvocations) {
      value.accept(visitor);
    }

    for (final value in providerScopeInstanceCreateExpressions) {
      value.accept(visitor);
    }
  }
}

base mixin _$HookConsumerWidgetDeclaration on RiverpodAst {
  List<WidgetRefInvocation> get widgetRefInvocations;
  List<ProviderScopeInstanceCreationExpression>
      get providerScopeInstanceCreateExpressions;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitHookConsumerWidgetDeclaration(
      this as HookConsumerWidgetDeclaration,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);

    for (final value in widgetRefInvocations) {
      value.accept(visitor);
    }

    for (final value in providerScopeInstanceCreateExpressions) {
      value.accept(visitor);
    }
  }
}

base mixin _$ConsumerStatefulWidgetDeclaration on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerStatefulWidgetDeclaration(
      this as ConsumerStatefulWidgetDeclaration,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
  }
}

base mixin _$StatefulHookConsumerWidgetDeclaration on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitStatefulHookConsumerWidgetDeclaration(
      this as StatefulHookConsumerWidgetDeclaration,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
  }
}

base mixin _$ConsumerStateDeclaration on RiverpodAst {
  List<WidgetRefInvocation> get widgetRefInvocations;
  List<ProviderScopeInstanceCreationExpression>
      get providerScopeInstanceCreateExpressions;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerStateDeclaration(
      this as ConsumerStateDeclaration,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);

    for (final value in widgetRefInvocations) {
      value.accept(visitor);
    }

    for (final value in providerScopeInstanceCreateExpressions) {
      value.accept(visitor);
    }
  }
}

base mixin _$GeneratorProviderDeclaration on RiverpodAst {
  List<RefInvocation> get refInvocations;
  RiverpodAnnotation get annotation;

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);

    for (final value in refInvocations) {
      value.accept(visitor);
    }

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

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
  }
}

base mixin _$FunctionalProviderDeclaration on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitFunctionalProviderDeclaration(
      this as FunctionalProviderDeclaration,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
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

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    if (dependencies case final dependencies?) {
      for (final value in dependencies) {
        value.accept(visitor);
      }
    }
  }
}

base mixin _$LegacyProviderDependency on RiverpodAst {
  ProviderListenableExpression? get provider;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitLegacyProviderDependency(
      this as LegacyProviderDependency,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    provider?.accept(visitor);
  }
}

base mixin _$LegacyProviderDeclaration on RiverpodAst {
  LegacyProviderDependencies? get dependencies;
  List<RefInvocation> get refInvocations;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitLegacyProviderDeclaration(
      this as LegacyProviderDeclaration,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    dependencies?.accept(visitor);

    for (final value in refInvocations) {
      value.accept(visitor);
    }
  }
}

base mixin _$ProviderContainerInstanceCreationExpression on RiverpodAst {
  ProviderOverrideList? get overrides;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitProviderContainerInstanceCreationExpression(
      this as ProviderContainerInstanceCreationExpression,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    overrides?.accept(visitor);
  }
}

base mixin _$ProviderDeclaration on RiverpodAst {
  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

base mixin _$ProviderListenableExpressionParent on RiverpodAst {
  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

base mixin _$ProviderListenableExpression on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitProviderListenableExpression(
      this as ProviderListenableExpression,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

base mixin _$ProviderOverrideExpression on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitProviderOverrideExpression(
      this as ProviderOverrideExpression,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

base mixin _$ProviderOverrideList on RiverpodAst {
  List<ProviderOverrideExpression>? get overrides;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitProviderOverrideList(
      this as ProviderOverrideList,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    if (overrides case final overrides?) {
      for (final value in overrides) {
        value.accept(visitor);
      }
    }
  }
}

base mixin _$ProviderScopeInstanceCreationExpression on RiverpodAst {
  ProviderOverrideList? get overrides;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitProviderScopeInstanceCreationExpression(
      this as ProviderScopeInstanceCreationExpression,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    overrides?.accept(visitor);
  }
}

base mixin _$RefInvocation on RiverpodAst {
  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

base mixin _$RefDependencyInvocation on RiverpodAst {
  ProviderListenableExpression get provider;

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    provider.accept(visitor);
  }
}

base mixin _$RefWatchInvocation on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRefWatchInvocation(
      this as RefWatchInvocation,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
  }
}

base mixin _$RefReadInvocation on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRefReadInvocation(
      this as RefReadInvocation,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
  }
}

base mixin _$RefListenInvocation on RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRefListenInvocation(
      this as RefListenInvocation,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
  }
}

base mixin _$ResolvedRiverpodLibraryResult on RiverpodAst {
  List<ProviderScopeInstanceCreationExpression>
      get providerScopeInstanceCreationExpressions;
  List<ProviderContainerInstanceCreationExpression>
      get providerContainerInstanceCreationExpressions;
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
  List<RefInvocation> get unknownRefInvocations;
  List<WidgetRefInvocation> get unknownWidgetRefInvocations;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitResolvedRiverpodLibraryResult(
      this as ResolvedRiverpodLibraryResult,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    for (final value in providerScopeInstanceCreationExpressions) {
      value.accept(visitor);
    }

    for (final value in providerContainerInstanceCreationExpressions) {
      value.accept(visitor);
    }

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

    for (final value in unknownRefInvocations) {
      value.accept(visitor);
    }

    for (final value in unknownWidgetRefInvocations) {
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

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

base mixin _$RiverpodAnnotationDependencies on RiverpodAst {
  List<RiverpodAnnotationDependency>? get dependencies;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitRiverpodAnnotationDependencies(
      this as RiverpodAnnotationDependencies,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
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

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    dependencies?.accept(visitor);
  }
}

base mixin _$WidgetRefInvocation on RiverpodAst {
  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

base mixin _$WidgetRefWatchInvocation on RiverpodAst {
  ProviderListenableExpression get provider;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitWidgetRefWatchInvocation(
      this as WidgetRefWatchInvocation,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    provider.accept(visitor);
  }
}

base mixin _$WidgetRefReadInvocation on RiverpodAst {
  ProviderListenableExpression get provider;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitWidgetRefReadInvocation(
      this as WidgetRefReadInvocation,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    provider.accept(visitor);
  }
}

base mixin _$WidgetRefListenInvocation on RiverpodAst {
  ProviderListenableExpression get provider;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitWidgetRefListenInvocation(
      this as WidgetRefListenInvocation,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    provider.accept(visitor);
  }
}

base mixin _$WidgetRefListenManualInvocation on RiverpodAst {
  ProviderListenableExpression get provider;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitWidgetRefListenManualInvocation(
      this as WidgetRefListenManualInvocation,
    );
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    super.visitChildren(visitor);
    provider.accept(visitor);
  }
}

abstract class RiverpodAstVisitor {
  void visitDependenciesAnnotationDependency(
      DependenciesAnnotationDependency node);

  void visitDependenciesAnnotation(DependenciesAnnotation node);

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

  void visitProviderContainerInstanceCreationExpression(
      ProviderContainerInstanceCreationExpression node);

  void visitProviderListenableExpression(ProviderListenableExpression node);

  void visitProviderOverrideExpression(ProviderOverrideExpression node);

  void visitProviderOverrideList(ProviderOverrideList node);

  void visitProviderScopeInstanceCreationExpression(
      ProviderScopeInstanceCreationExpression node);

  void visitRefWatchInvocation(RefWatchInvocation node);

  void visitRefReadInvocation(RefReadInvocation node);

  void visitRefListenInvocation(RefListenInvocation node);

  void visitResolvedRiverpodLibraryResult(ResolvedRiverpodLibraryResult node);

  void visitRiverpodAnnotationDependency(RiverpodAnnotationDependency node);

  void visitRiverpodAnnotationDependencies(RiverpodAnnotationDependencies node);

  void visitRiverpodAnnotation(RiverpodAnnotation node);

  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation node);

  void visitWidgetRefReadInvocation(WidgetRefReadInvocation node);

  void visitWidgetRefListenInvocation(WidgetRefListenInvocation node);

  void visitWidgetRefListenManualInvocation(
      WidgetRefListenManualInvocation node);
}

abstract class GeneralizingRiverpodAstVisitor implements RiverpodAstVisitor {
  void visitRiverpodAst(RiverpodAst node) {
    node.visitChildren(this);
  }

  @override
  void visitDependenciesAnnotationDependency(
      DependenciesAnnotationDependency node) {}

  @override
  void visitDependenciesAnnotation(DependenciesAnnotation node) {}

  void visitConsumerDeclaration(ConsumerDeclaration node) {}

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
  void visitLegacyProviderDependencies(LegacyProviderDependencies node) {}

  @override
  void visitLegacyProviderDependency(LegacyProviderDependency node) {
    visitProviderListenableExpressionParent(node);
  }

  @override
  void visitLegacyProviderDeclaration(LegacyProviderDeclaration node) {
    visitProviderDeclaration(node);
  }

  @override
  void visitProviderContainerInstanceCreationExpression(
      ProviderContainerInstanceCreationExpression node) {}

  void visitProviderDeclaration(ProviderDeclaration node) {}

  void visitProviderListenableExpressionParent(
      ProviderListenableExpressionParent node) {}

  @override
  void visitProviderListenableExpression(ProviderListenableExpression node) {}

  @override
  void visitProviderOverrideExpression(ProviderOverrideExpression node) {}

  @override
  void visitProviderOverrideList(ProviderOverrideList node) {}

  @override
  void visitProviderScopeInstanceCreationExpression(
      ProviderScopeInstanceCreationExpression node) {}

  void visitRefInvocation(RefInvocation node) {
    visitProviderListenableExpressionParent(node);
  }

  void visitRefDependencyInvocation(RefDependencyInvocation node) {
    visitRefInvocation(node);
    visitProviderListenableExpressionParent(node);
  }

  @override
  void visitRefWatchInvocation(RefWatchInvocation node) {
    visitRefDependencyInvocation(node);
    visitRefInvocation(node);
    visitProviderListenableExpressionParent(node);
  }

  @override
  void visitRefReadInvocation(RefReadInvocation node) {
    visitRefDependencyInvocation(node);
    visitRefInvocation(node);
    visitProviderListenableExpressionParent(node);
  }

  @override
  void visitRefListenInvocation(RefListenInvocation node) {
    visitRefDependencyInvocation(node);
    visitRefInvocation(node);
    visitProviderListenableExpressionParent(node);
  }

  @override
  void visitResolvedRiverpodLibraryResult(ResolvedRiverpodLibraryResult node) {}

  @override
  void visitRiverpodAnnotationDependency(RiverpodAnnotationDependency node) {}

  @override
  void visitRiverpodAnnotationDependencies(
      RiverpodAnnotationDependencies node) {}

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation node) {}

  void visitWidgetRefInvocation(WidgetRefInvocation node) {
    visitProviderListenableExpressionParent(node);
  }

  @override
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation node) {
    visitWidgetRefInvocation(node);
    visitProviderListenableExpressionParent(node);
  }

  @override
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation node) {
    visitWidgetRefInvocation(node);
    visitProviderListenableExpressionParent(node);
  }

  @override
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation node) {
    visitWidgetRefInvocation(node);
    visitProviderListenableExpressionParent(node);
  }

  @override
  void visitWidgetRefListenManualInvocation(
      WidgetRefListenManualInvocation node) {
    visitWidgetRefInvocation(node);
    visitProviderListenableExpressionParent(node);
  }
}

abstract class RecursiveRiverpodAstVisitor implements RiverpodAstVisitor {
  @override
  void visitDependenciesAnnotationDependency(
      DependenciesAnnotationDependency node) {
    node.visitChildren(this);
  }

  @override
  void visitDependenciesAnnotation(DependenciesAnnotation node) {
    node.visitChildren(this);
  }

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
  void visitProviderContainerInstanceCreationExpression(
      ProviderContainerInstanceCreationExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitProviderListenableExpression(ProviderListenableExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitProviderOverrideExpression(ProviderOverrideExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitProviderOverrideList(ProviderOverrideList node) {
    node.visitChildren(this);
  }

  @override
  void visitProviderScopeInstanceCreationExpression(
      ProviderScopeInstanceCreationExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitRefWatchInvocation(RefWatchInvocation node) {
    node.visitChildren(this);
  }

  @override
  void visitRefReadInvocation(RefReadInvocation node) {
    node.visitChildren(this);
  }

  @override
  void visitRefListenInvocation(RefListenInvocation node) {
    node.visitChildren(this);
  }

  @override
  void visitResolvedRiverpodLibraryResult(ResolvedRiverpodLibraryResult node) {
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

  @override
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation node) {
    node.visitChildren(this);
  }

  @override
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation node) {
    node.visitChildren(this);
  }

  @override
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation node) {
    node.visitChildren(this);
  }

  @override
  void visitWidgetRefListenManualInvocation(
      WidgetRefListenManualInvocation node) {
    node.visitChildren(this);
  }
}

abstract class SimpleRiverpodAstVisitor implements RiverpodAstVisitor {
  @override
  void visitDependenciesAnnotationDependency(
      DependenciesAnnotationDependency node) {}

  @override
  void visitDependenciesAnnotation(DependenciesAnnotation node) {}

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
  void visitProviderContainerInstanceCreationExpression(
      ProviderContainerInstanceCreationExpression node) {}

  @override
  void visitProviderListenableExpression(ProviderListenableExpression node) {}

  @override
  void visitProviderOverrideExpression(ProviderOverrideExpression node) {}

  @override
  void visitProviderOverrideList(ProviderOverrideList node) {}

  @override
  void visitProviderScopeInstanceCreationExpression(
      ProviderScopeInstanceCreationExpression node) {}

  @override
  void visitRefWatchInvocation(RefWatchInvocation node) {}

  @override
  void visitRefReadInvocation(RefReadInvocation node) {}

  @override
  void visitRefListenInvocation(RefListenInvocation node) {}

  @override
  void visitResolvedRiverpodLibraryResult(ResolvedRiverpodLibraryResult node) {}

  @override
  void visitRiverpodAnnotationDependency(RiverpodAnnotationDependency node) {}

  @override
  void visitRiverpodAnnotationDependencies(
      RiverpodAnnotationDependencies node) {}

  @override
  void visitRiverpodAnnotation(RiverpodAnnotation node) {}

  @override
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation node) {}

  @override
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation node) {}

  @override
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation node) {}

  @override
  void visitWidgetRefListenManualInvocation(
      WidgetRefListenManualInvocation node) {}
}

abstract class UnimplementedRiverpodAstVisitor implements RiverpodAstVisitor {
  @override
  void visitDependenciesAnnotationDependency(
      DependenciesAnnotationDependency node) {
    throw UnimplementedError();
  }

  @override
  void visitDependenciesAnnotation(DependenciesAnnotation node) {
    throw UnimplementedError();
  }

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
  void visitProviderContainerInstanceCreationExpression(
      ProviderContainerInstanceCreationExpression node) {
    throw UnimplementedError();
  }

  @override
  void visitProviderListenableExpression(ProviderListenableExpression node) {
    throw UnimplementedError();
  }

  @override
  void visitProviderOverrideExpression(ProviderOverrideExpression node) {
    throw UnimplementedError();
  }

  @override
  void visitProviderOverrideList(ProviderOverrideList node) {
    throw UnimplementedError();
  }

  @override
  void visitProviderScopeInstanceCreationExpression(
      ProviderScopeInstanceCreationExpression node) {
    throw UnimplementedError();
  }

  @override
  void visitRefWatchInvocation(RefWatchInvocation node) {
    throw UnimplementedError();
  }

  @override
  void visitRefReadInvocation(RefReadInvocation node) {
    throw UnimplementedError();
  }

  @override
  void visitRefListenInvocation(RefListenInvocation node) {
    throw UnimplementedError();
  }

  @override
  void visitResolvedRiverpodLibraryResult(ResolvedRiverpodLibraryResult node) {
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

  @override
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation node) {
    throw UnimplementedError();
  }

  @override
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation node) {
    throw UnimplementedError();
  }

  @override
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation node) {
    throw UnimplementedError();
  }

  @override
  void visitWidgetRefListenManualInvocation(
      WidgetRefListenManualInvocation node) {
    throw UnimplementedError();
  }
}

@internal
class RiverpodAnalysisResult extends GeneralizingRiverpodAstVisitor {
  final dependenciesAnnotationDependencys =
      <DependenciesAnnotationDependency>[];
  @override
  void visitDependenciesAnnotationDependency(
    DependenciesAnnotationDependency node,
  ) {
    super.visitDependenciesAnnotationDependency(node);
    dependenciesAnnotationDependencys.add(node);
  }

  final dependenciesAnnotations = <DependenciesAnnotation>[];
  @override
  void visitDependenciesAnnotation(
    DependenciesAnnotation node,
  ) {
    super.visitDependenciesAnnotation(node);
    dependenciesAnnotations.add(node);
  }

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

  final providerContainerInstanceCreationExpressions =
      <ProviderContainerInstanceCreationExpression>[];
  @override
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression node,
  ) {
    super.visitProviderContainerInstanceCreationExpression(node);
    providerContainerInstanceCreationExpressions.add(node);
  }

  final providerDeclarations = <ProviderDeclaration>[];
  @override
  void visitProviderDeclaration(
    ProviderDeclaration node,
  ) {
    super.visitProviderDeclaration(node);
    providerDeclarations.add(node);
  }

  final providerListenableExpressionParents =
      <ProviderListenableExpressionParent>[];
  @override
  void visitProviderListenableExpressionParent(
    ProviderListenableExpressionParent node,
  ) {
    super.visitProviderListenableExpressionParent(node);
    providerListenableExpressionParents.add(node);
  }

  final providerListenableExpressions = <ProviderListenableExpression>[];
  @override
  void visitProviderListenableExpression(
    ProviderListenableExpression node,
  ) {
    super.visitProviderListenableExpression(node);
    providerListenableExpressions.add(node);
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

  final providerScopeInstanceCreationExpressions =
      <ProviderScopeInstanceCreationExpression>[];
  @override
  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression node,
  ) {
    super.visitProviderScopeInstanceCreationExpression(node);
    providerScopeInstanceCreationExpressions.add(node);
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

  final resolvedRiverpodLibraryResults = <ResolvedRiverpodLibraryResult>[];
  @override
  void visitResolvedRiverpodLibraryResult(
    ResolvedRiverpodLibraryResult node,
  ) {
    super.visitResolvedRiverpodLibraryResult(node);
    resolvedRiverpodLibraryResults.add(node);
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
  void visitDependenciesAnnotationDependency(
      DependenciesAnnotationDependency node) {
    super.visitDependenciesAnnotationDependency(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onDependenciesAnnotationDependency,
    );
  }

  @override
  void visitDependenciesAnnotation(DependenciesAnnotation node) {
    super.visitDependenciesAnnotation(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onDependenciesAnnotation,
    );
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
  void visitProviderContainerInstanceCreationExpression(
      ProviderContainerInstanceCreationExpression node) {
    super.visitProviderContainerInstanceCreationExpression(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onProviderContainerInstanceCreationExpression,
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
  void visitProviderListenableExpressionParent(
      ProviderListenableExpressionParent node) {
    super.visitProviderListenableExpressionParent(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onProviderListenableExpressionParent,
    );
  }

  @override
  void visitProviderListenableExpression(ProviderListenableExpression node) {
    super.visitProviderListenableExpression(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onProviderListenableExpression,
    );
  }

  @override
  void visitProviderOverrideExpression(ProviderOverrideExpression node) {
    super.visitProviderOverrideExpression(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onProviderOverrideExpression,
    );
  }

  @override
  void visitProviderOverrideList(ProviderOverrideList node) {
    super.visitProviderOverrideList(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onProviderOverrideList,
    );
  }

  @override
  void visitProviderScopeInstanceCreationExpression(
      ProviderScopeInstanceCreationExpression node) {
    super.visitProviderScopeInstanceCreationExpression(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onProviderScopeInstanceCreationExpression,
    );
  }

  @override
  void visitRefInvocation(RefInvocation node) {
    super.visitRefInvocation(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onRefInvocation,
    );
  }

  @override
  void visitRefDependencyInvocation(RefDependencyInvocation node) {
    super.visitRefDependencyInvocation(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onRefDependencyInvocation,
    );
  }

  @override
  void visitRefWatchInvocation(RefWatchInvocation node) {
    super.visitRefWatchInvocation(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onRefWatchInvocation,
    );
  }

  @override
  void visitRefReadInvocation(RefReadInvocation node) {
    super.visitRefReadInvocation(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onRefReadInvocation,
    );
  }

  @override
  void visitRefListenInvocation(RefListenInvocation node) {
    super.visitRefListenInvocation(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onRefListenInvocation,
    );
  }

  @override
  void visitResolvedRiverpodLibraryResult(ResolvedRiverpodLibraryResult node) {
    super.visitResolvedRiverpodLibraryResult(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onResolvedRiverpodLibraryResult,
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

  @override
  void visitWidgetRefInvocation(WidgetRefInvocation node) {
    super.visitWidgetRefInvocation(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onWidgetRefInvocation,
    );
  }

  @override
  void visitWidgetRefWatchInvocation(WidgetRefWatchInvocation node) {
    super.visitWidgetRefWatchInvocation(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onWidgetRefWatchInvocation,
    );
  }

  @override
  void visitWidgetRefReadInvocation(WidgetRefReadInvocation node) {
    super.visitWidgetRefReadInvocation(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onWidgetRefReadInvocation,
    );
  }

  @override
  void visitWidgetRefListenInvocation(WidgetRefListenInvocation node) {
    super.visitWidgetRefListenInvocation(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onWidgetRefListenInvocation,
    );
  }

  @override
  void visitWidgetRefListenManualInvocation(
      WidgetRefListenManualInvocation node) {
    super.visitWidgetRefListenManualInvocation(node);
    node.visitChildren(this);
    _runSubscriptions(
      node,
      _registry._onWidgetRefListenManualInvocation,
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

  final _onDependenciesAnnotationDependency =
      <void Function(DependenciesAnnotationDependency)>[];
  void addDependenciesAnnotationDependency(
      void Function(DependenciesAnnotationDependency node) cb) {
    _onDependenciesAnnotationDependency.add(cb);
  }

  final _onDependenciesAnnotation = <void Function(DependenciesAnnotation)>[];
  void addDependenciesAnnotation(
      void Function(DependenciesAnnotation node) cb) {
    _onDependenciesAnnotation.add(cb);
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

  final _onProviderContainerInstanceCreationExpression =
      <void Function(ProviderContainerInstanceCreationExpression)>[];
  void addProviderContainerInstanceCreationExpression(
      void Function(ProviderContainerInstanceCreationExpression node) cb) {
    _onProviderContainerInstanceCreationExpression.add(cb);
  }

  final _onProviderDeclaration = <void Function(ProviderDeclaration)>[];
  void addProviderDeclaration(void Function(ProviderDeclaration node) cb) {
    _onProviderDeclaration.add(cb);
  }

  final _onProviderListenableExpressionParent =
      <void Function(ProviderListenableExpressionParent)>[];
  void addProviderListenableExpressionParent(
      void Function(ProviderListenableExpressionParent node) cb) {
    _onProviderListenableExpressionParent.add(cb);
  }

  final _onProviderListenableExpression =
      <void Function(ProviderListenableExpression)>[];
  void addProviderListenableExpression(
      void Function(ProviderListenableExpression node) cb) {
    _onProviderListenableExpression.add(cb);
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

  final _onProviderScopeInstanceCreationExpression =
      <void Function(ProviderScopeInstanceCreationExpression)>[];
  void addProviderScopeInstanceCreationExpression(
      void Function(ProviderScopeInstanceCreationExpression node) cb) {
    _onProviderScopeInstanceCreationExpression.add(cb);
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

  final _onResolvedRiverpodLibraryResult =
      <void Function(ResolvedRiverpodLibraryResult)>[];
  void addResolvedRiverpodLibraryResult(
      void Function(ResolvedRiverpodLibraryResult node) cb) {
    _onResolvedRiverpodLibraryResult.add(cb);
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
}

// ignore_for_file: type=lint
