import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart'
    hide
        // ignore: undefined_hidden_name, necessary to support broad analyzer versions
        LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

class MissingLegacyImport extends RiverpodLintRule {
  const MissingLegacyImport() : super(code: _code);

  static const _code = LintCode(
    name: 'missing_legacy_import',
    problemMessage:
        'StateProvider/StateNotifierProvider/ChangeNotifierProvider/StateNotifier were used '
        'without importing `package:flutter_riverpod/legacy.dart`.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    void handleType(AstNode node, DartType? type, String? name) {
      // Skip resolved types. Even if the import is missing,
      // chances are the import was indirectly imported.
      if (type != null && type is! InvalidType) {
        return;
      }

      const legacyIdentifiers = [
        'StateProvider',
        'StateNotifierProvider',
        'StateNotifier',
        'ChangeNotifierProvider',
      ];

      if (!legacyIdentifiers.contains(name)) return;

      final unit = node.thisOrAncestorOfType<CompilationUnit>()!;

      final imports = unit.directives
          .whereType<ImportDirective>()
          .map((e) => e.uri.stringValue);

      final compatibleImports = [
        'package:flutter_riverpod/legacy.dart',
        'package:hooks_riverpod/legacy.dart',
        if (name != 'ChangeNotifierProvider') 'package:riverpod/legacy.dart',
      ];

      if (compatibleImports.any(imports.contains)) return;

      reporter.atNode(node, code);
    }

    context.registry.addNamedType((node) {
      handleType(node, node.type, node.name2.lexeme);
    });

    context.registry.addIdentifier((node) {
      handleType(node, node.staticType, node.name);
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
    void handleType(AstNode node, String? name) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      final toImport = name == 'ChangeNotifierProvider'
          ? 'package:flutter_riverpod/legacy.dart'
          : 'package:riverpod/legacy.dart';

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Import "$toImport"',
        priority: 100,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(0, "import '$toImport';\n");
      });
    }

    context.registry.addIdentifier((node) {
      handleType(node, node.name);
    });

    context.registry.addNamedType((node) {
      handleType(node, node.name2.lexeme);
    });
  }
}
