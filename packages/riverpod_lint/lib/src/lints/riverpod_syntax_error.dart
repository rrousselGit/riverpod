import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class RiverpodSyntaxError extends RiverpodLintRule {
  const RiverpodSyntaxError() : super(code: _code);

  static const _code = LintCode(
    name: 'riverpod_syntax_error',
    problemMessage: '{0}',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addRiverpodAnalysisError((error) {
      if (error.code == RiverpodAnalysisErrorCode.missingNotifierBuild) {
        return;
      }

      final location = switch (error) {
        RiverpodAnalysisError(:final targetElement?) =>
          SourceRange(targetElement.nameOffset, targetElement.nameLength),
        RiverpodAnalysisError(:final targetNode?) => targetNode.sourceRange,
        _ => null,
      };

      if (location == null) return;

      reporter.reportErrorForOffset(
        _code,
        location.offset,
        location.length,
        [error.message],
      );
    });
  }
}
