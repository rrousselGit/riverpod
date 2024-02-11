import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

// TODO changelog added migration for missing import.
class MissingLegacyImport extends RiverpodLintRule {
  const MissingLegacyImport() : super(code: _code);

  static const _code = LintCode(
    name: 'missing_legacy_import',
    problemMessage:
        'StateProvider/StateNotifierProvider/ChangeNotifierProvider were used '
        'without importing `package:flutter_riverpod/legacy.dart`.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addIdentifier((node) {
      const legacyProviders = [
        'StateProvider',
        'StateNotifierProvider',
        'ChangeNotifierProvider',
      ];

      if (!legacyProviders.contains(node.name)) return;

      final unit = node.thisOrAncestorOfType<CompilationUnit>()!;

      final imports = unit.directives
          .whereType<ImportDirective>()
          .map((e) => e.uri.stringValue);

      final compatibleImports = [
        'package:flutter_riverpod/legacy.dart',
        'package:hooks_riverpod/legacy.dart',
        if (node.name != 'ChangeNotifierProvider')
          'package:riverpod/legacy.dart',
      ];

      if (compatibleImports.any(imports.contains)) return;

      reporter.reportErrorForNode(_code, node);
    });
  }

  @override
  List<DartFix> getFixes() => [_AddMissingLegacyImport()];
}

class _AddMissingLegacyImport extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addIdentifier((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      final toImport = node.name == 'ChangeNotifierProvider'
          ? 'package:flutter_riverpod/legacy.dart'
          : 'package:riverpod/legacy.dart';

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Import "$toImport"',
        priority: 100,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(0, "import '$toImport';\n");
      });
    });
  }
}
