import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

class IncorrectUsageOfWidgetRefListenManual extends RiverpodLintRule {
  const IncorrectUsageOfWidgetRefListenManual() : super(code: _code);

  static const _code = LintCode(
    name: 'incorrect_usage_of_widget_ref_listen_manual',
    problemMessage: 'Incorrect usage of ref.listenManual.',
    correctionMessage: 'Try canceling the subscription manually.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addWidgetRefListenManualInvocation((invocation) {
      final functionExpression =
          invocation.node.thisOrAncestorOfType<FunctionExpression>();
      if (functionExpression != null) return;

      final method = invocation.node.thisOrAncestorOfType<MethodDeclaration>();
      if (method == null || method.name.lexeme != 'build') return;

      final parent = invocation.node.parent;
      final grandParent = parent?.parent;
      final body = method.body;
      if (parent is AssignmentExpression &&
          grandParent is ExpressionStatement &&
          parent.leftHandSide is SimpleIdentifier &&
          body is BlockFunctionBody) {
        final variableName = parent.leftHandSide as SimpleIdentifier;
        final statements = body.block.statements;

        final subscriptionClose =
            statements.whereType<ExpressionStatement>().firstWhereOrNull(
          (statement) {
            final expression = statement.expression;
            if (expression is! MethodInvocation) return false;

            final target = expression.target;
            if (target is! SimpleIdentifier) return false;

            return target.name == variableName.name &&
                expression.methodName.name == 'close';
          },
        );

        if (subscriptionClose != null) {
          final refListenManualIndex = statements.indexOf(grandParent);
          final subscriptionCloseIndex = statements.indexOf(subscriptionClose);

          if (subscriptionCloseIndex < refListenManualIndex) {
            return;
          }
        }

        reporter.reportErrorForNode(code, invocation.node.methodName);
      }

      reporter.reportErrorForNode(code, invocation.node.methodName);
    });
  }
}
