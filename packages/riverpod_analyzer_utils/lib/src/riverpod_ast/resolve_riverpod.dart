part of '../riverpod_ast.dart';

final class ResolvedRiverpodLibraryResult extends RiverpodAst
    with _$ResolvedRiverpodLibraryResult {
  ResolvedRiverpodLibraryResult._();

  factory ResolvedRiverpodLibraryResult.from(
    List<CompilationUnit> units,
  ) {
    final result = ResolvedRiverpodLibraryResult._();
    final visitor = _ParseRiverpodUnitVisitor(result);

    try {
      errorReporter = result.errors.add;

      for (final unit in units) {
        // Let's not parse generated files
        const generatedExtensions = {'.freezed.dart', '.g.dart'};
        final shortName = unit.declaredElement?.source.shortName ?? '';
        if (generatedExtensions.any(shortName.endsWith)) {
          continue;
        }
        unit.accept(visitor);
      }
    } finally {
      errorReporter = null;
    }

    result.visitChildren(_SetParentVisitor(result));

    return result;
  }

  final errors = <RiverpodAnalysisError>[];

  @override
  final functionalProviderDeclarations = <FunctionalProviderDeclaration>[];
  @override
  final classBasedProviderDeclarations = <ClassBasedProviderDeclaration>[];

  @override
  final legacyProviderDeclarations = <LegacyProviderDeclaration>[];

  @override
  final consumerWidgetDeclarations = <ConsumerWidgetDeclaration>[];
  @override
  final consumerStatefulWidgetDeclarations =
      <ConsumerStatefulWidgetDeclaration>[];
  @override
  final consumerStateDeclaration = <ConsumerStateDeclaration>[];
  @override
  final statefulHookConsumerWidgetDeclarations =
      <StatefulHookConsumerWidgetDeclaration>[];
  @override
  final hookConsumerWidgetDeclarations = <HookConsumerWidgetDeclaration>[];

  @override
  Null get parent => null;

  @override
  Null get node => null;

  // TODO changelog breaking renamed visitResolvedRiverpodLibraryResult
}

class _AddConsumerDeclarationVisitor extends UnimplementedRiverpodAstVisitor {
  _AddConsumerDeclarationVisitor(this.result);

  final ResolvedRiverpodLibraryResult result;

  @override
  void visitConsumerStatefulWidgetDeclaration(
    ConsumerStatefulWidgetDeclaration declaration,
  ) {
    result.consumerStatefulWidgetDeclarations.add(declaration);
  }

  @override
  void visitConsumerStateDeclaration(ConsumerStateDeclaration declaration) {
    result.consumerStateDeclaration.add(declaration);
  }

  @override
  void visitStatefulHookConsumerWidgetDeclaration(
    StatefulHookConsumerWidgetDeclaration declaration,
  ) {
    result.statefulHookConsumerWidgetDeclarations.add(declaration);
  }

  @override
  void visitHookConsumerWidgetDeclaration(
    HookConsumerWidgetDeclaration declaration,
  ) {
    result.hookConsumerWidgetDeclarations.add(declaration);
  }

  @override
  void visitConsumerWidgetDeclaration(ConsumerWidgetDeclaration declaration) {
    result.consumerWidgetDeclarations.add(declaration);
  }
}

class _ParseRiverpodUnitVisitor extends SimpleAstVisitor<void> {
  _ParseRiverpodUnitVisitor(this.result);

  final ResolvedRiverpodLibraryResult result;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final declaration = ClassBasedProviderDeclaration._parse(node);
    if (declaration != null) {
      result.classBasedProviderDeclarations.add(declaration);
      return;
    }

    final consumerDeclaration = ConsumerDeclaration._parse(node);
    if (consumerDeclaration != null) {
      consumerDeclaration.accept(_AddConsumerDeclarationVisitor(result));
      return;
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final declaration = FunctionalProviderDeclaration._parse(node);
    if (declaration != null) {
      result.functionalProviderDeclarations.add(declaration);
      return;
    }
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    final declaration = LegacyProviderDeclaration._parse(node);
    if (declaration != null) {
      result.legacyProviderDeclarations.add(declaration);
      return;
    }
  }
}
