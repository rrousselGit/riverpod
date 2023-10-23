import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
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
    correctionMessage: 'Try closing the returned subscription properly.',
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
      final methodDeclaration =
          invocation.node.thisOrAncestorOfType<MethodDeclaration>();

      if (methodDeclaration != null &&
          methodDeclaration.name.lexeme == 'build' &&
          functionExpression == null) {
        if (_isSubscriptionClosed(
          invocation: invocation.node,
          functionBody: methodDeclaration.body,
        )) return;

        reporter.reportErrorForNode(code, invocation.node.methodName);
      }
    });
  }

  bool _isSubscriptionClosed({
    required MethodInvocation invocation,
    required FunctionBody functionBody,
  }) {
    final parent = invocation.parent;
    final grandParent = parent?.parent;

    if (parent is AssignmentExpression &&
        grandParent is ExpressionStatement &&
        functionBody is BlockFunctionBody) {
      final subscriptionElement = parent.writeElement;
      if (subscriptionElement is! PropertyAccessorElement) return false;

      final statements = functionBody.block.statements;
      final closeSubscriptionStatement =
          statements.whereType<ExpressionStatement>().firstWhereOrNull(
        (statement) {
          final expression = statement.expression;
          if (expression is! MethodInvocation) return false;

          final methodTarget = expression.realTarget;
          if (methodTarget is! SimpleIdentifier) return false;

          final methodTargetElement = methodTarget.staticElement;
          if (methodTargetElement is! PropertyAccessorElement) return false;

          return methodTargetElement.variable == subscriptionElement.variable &&
              expression.methodName.name == 'close';
        },
      );

      if (closeSubscriptionStatement != null) {
        final refListenManualIndex = statements.indexOf(grandParent);
        final closeSubscriptionIndex =
            statements.indexOf(closeSubscriptionStatement);

        if (closeSubscriptionIndex < refListenManualIndex) return true;
      }
    }

    return false;
  }
}
