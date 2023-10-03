import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

class IncorrectUsageOfWidgetRefListen extends RiverpodLintRule {
  const IncorrectUsageOfWidgetRefListen() : super(code: _code);

  static const _code = LintCode(
    name: 'incorrect_usage_of_widget_ref_listen',
    problemMessage: 'Incorrect usage of ref.listen.',
    correctionMessage: 'Use ref.listenManual instead.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addWidgetRefListenInvocation((invocation) {
      final functionExpression =
          invocation.node.thisOrAncestorOfType<FunctionExpression>();
      final methodName = invocation.node
          .thisOrAncestorOfType<MethodDeclaration>()
          ?.name
          .lexeme;

      if (functionExpression == null && methodName == 'build') return;

      reporter.reportErrorForNode(code, invocation.node.methodName);
    });
  }

  @override
  List<Fix> getFixes() => [UseWidgetRefListenManual()];
}

class UseWidgetRefListenManual extends RiverpodFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    riverpodRegistry(context).addWidgetRefListenInvocation((invocation) {
      if (!invocation.node.methodName.sourceRange
          .intersects(analysisError.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Use ref.listenManual',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          invocation.node.methodName.sourceRange,
          'listenManual',
        );
      });
    });
  }
}
