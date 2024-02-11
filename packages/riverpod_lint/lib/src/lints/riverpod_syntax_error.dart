import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

// TODO changelog new lint
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
    riverpodRegistry(context).addRiverpodUnit((unit) {
      for (final error in unit.errors) {
        switch (error.code) {
          case RiverpodAnalysisErrorCode.missingNotifierBuild:
            // Silencing errors already covered by a different lint
            continue;
          case _:
        }

        final location = switch (error) {
          RiverpodAnalysisError(:final targetElement?) =>
            SourceRange(targetElement.nameOffset, targetElement.nameLength),
          RiverpodAnalysisError(:final targetNode?) => targetNode.sourceRange,
          _ => null,
        };

        if (location == null) continue;

        reporter.reportErrorForOffset(
          _code,
          location.offset,
          location.length,
          [error.message],
        );
      }
    });
  }
}
