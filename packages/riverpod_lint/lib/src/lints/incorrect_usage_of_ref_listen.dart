import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class IncorrectUsageOfRefListen extends RiverpodLintRule {
  const IncorrectUsageOfRefListen() : super(code: _code);

  static const _code = LintCode(
    name: 'incorrect_usage_of_ref_listen',
    problemMessage: 'Incorrect usage of ref.listen.',
    correctionMessage: 'Try closing the returned subscription properly.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addRefListenInvocation((invocation) {
      final parent = invocation.node.parent;
      final methodDeclaration =
          invocation.node.thisOrAncestorOfType<MethodDeclaration>();

      if (parent is LegacyProviderDeclaration ||
          parent is FunctionalProviderDeclaration ||
          methodDeclaration == null ||
          methodDeclaration.name.lexeme == 'build') return;

      if (_isSubscriptionClosed(
        invocation: invocation.node,
        functionBody: methodDeclaration.body,
      )) return;

      reporter.reportErrorForNode(code, invocation.node.methodName);
    });
  }

  bool _isSubscriptionClosed({
    required MethodInvocation invocation,
    required FunctionBody functionBody,
  }) {
    final parent = invocation.parent;
    final grandParent = parent?.parent;
    final body = functionBody;

    if (parent is AssignmentExpression &&
        grandParent is ExpressionStatement &&
        body is BlockFunctionBody) {
      final subscriptionElement = parent.writeElement;
      if (subscriptionElement is! PropertyAccessorElement) return false;

      final statements = body.block.statements;
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
