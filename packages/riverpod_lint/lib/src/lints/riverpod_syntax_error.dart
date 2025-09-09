import 'package:analyzer/error/error.dart'
    hide
        // ignore: undefined_hidden_name, necessary to support broad analyzer versions
        LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class RiverpodSyntaxError extends RiverpodLintRule {
  const RiverpodSyntaxError() : super(code: _code);

  static const _code = LintCode(
    name: 'riverpod_syntax_error',
    problemMessage: '{0}',
    errorSeverity: DiagnosticSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addRiverpodAnalysisError((error) {
      if (error.code == RiverpodAnalysisErrorCode.missingNotifierBuild) {
        return;
      }

      final location = error.targetNode.sourceRange;

      reporter.atOffset(
        diagnosticCode: _code,
        offset: location.offset,
        length: location.length,
        arguments: [error.message],
      );
    });
  }
}
