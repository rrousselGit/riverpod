import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

class IncorrectUsageOfWidgetRefRead extends RiverpodLintRule {
  const IncorrectUsageOfWidgetRefRead() : super(code: _code);

  static const _code = LintCode(
    name: 'incorrect_usage_of_widget_ref_read',
    problemMessage: 'Incorrect usage of ref.read.',
    correctionMessage: 'Use ref.watch instead.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addWidgetRefReadInvocation((invocation) {
      final functionExpression =
          invocation.node.thisOrAncestorOfType<FunctionExpression>();
      final methodName = invocation.node
          .thisOrAncestorOfType<MethodDeclaration>()
          ?.name
          .lexeme;

      if (functionExpression != null || methodName != 'build') return;

      reporter.reportErrorForNode(code, invocation.node.methodName);
    });
  }

  @override
  List<Fix> getFixes() => [UseWidgetRefWatch()];
}

class UseWidgetRefWatch extends RiverpodFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    riverpodRegistry(context).addWidgetRefReadInvocation((invocation) {
      if (!invocation.node.methodName.sourceRange
          .intersects(analysisError.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Use ref.watch',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          invocation.node.methodName.sourceRange,
          'watch',
        );
      });
    });
  }
}
