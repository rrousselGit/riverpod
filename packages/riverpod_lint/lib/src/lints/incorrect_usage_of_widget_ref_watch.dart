import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class IncorrectUsageOfWidgetRefWatch extends RiverpodLintRule {
  const IncorrectUsageOfWidgetRefWatch() : super(code: _code);

  static const _code = LintCode(
    name: 'incorrect_usage_of_widget_ref_watch',
    problemMessage: 'Incorrect usage of ref.watch.',
    correctionMessage: 'Use ref.read instead.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addWidgetRefWatchInvocation((invocation) {
      final functionExpression =
          invocation.node.thisOrAncestorOfType<FunctionExpression>();
      final methodName = invocation.node
          .thisOrAncestorOfType<MethodDeclaration>()
          ?.name
          .lexeme;

      if (functionExpression == null && methodName == 'build') return;

      if (functionExpression != null) {
        final parent = functionExpression
            .thisOrAncestorOfType<InstanceCreationExpression>();
        final parentType = parent?.staticType;
        if (parentType != null && anyConsumerType.isExactlyType(parentType)) {
          return;
        }
      }

      reporter.reportErrorForNode(code, invocation.node.methodName);
    });
  }

  @override
  List<Fix> getFixes() => [UseWidgetRefRead()];
}

class UseWidgetRefRead extends RiverpodFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    riverpodRegistry(context).addWidgetRefWatchInvocation((invocation) {
      if (!invocation.node.methodName.sourceRange
          .intersects(analysisError.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Use ref.read',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          invocation.node.methodName.sourceRange,
          'read',
        );
      });
    });
  }
}