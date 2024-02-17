part of '../riverpod_ast.dart';

final class ResolvedRiverpodLibraryResult {
  ResolvedRiverpodLibraryResult._(this.units);

  factory ResolvedRiverpodLibraryResult.from(
    List<CompilationUnit> units,
  ) {
    final riverpodUnits = units.map(RiverpodCompilationUnit._).toList();

    final errors = <RiverpodAnalysisError>[];
    errorReporter = errors.add;
    try {
      for (final unit in riverpodUnits) {
        // Let's not parse generated files
        const generatedExtensions = {'.freezed.dart', '.g.dart'};
        final shortName = unit.node.declaredElement?.source.shortName ?? '';
        if (generatedExtensions.any(shortName.endsWith)) {
          continue;
        }

        final visitor = _ParseRiverpodUnitVisitor(unit);
        unit.node.accept(visitor);

        unit.visitChildren(_SetParentVisitor(unit));
      }
    } finally {
      errorReporter = null;
    }

    return ResolvedRiverpodLibraryResult._(riverpodUnits);
  }

  final errors = <RiverpodAnalysisError>[];

  final List<RiverpodCompilationUnit> units;
}

final class RiverpodCompilationUnit extends RiverpodAst
    with _$RiverpodCompilationUnit {
  RiverpodCompilationUnit._(this.node);

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
  final CompilationUnit node;
}

class _AddConsumerDeclarationVisitor extends UnimplementedRiverpodAstVisitor {
  _AddConsumerDeclarationVisitor(this.result);

  final RiverpodCompilationUnit result;

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

  final RiverpodCompilationUnit result;

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
