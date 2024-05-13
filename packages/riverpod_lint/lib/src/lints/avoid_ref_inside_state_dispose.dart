import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

const disposeMethod = 'dispose';

class AvoidRefInsideStateDispose extends RiverpodLintRule {
  const AvoidRefInsideStateDispose() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_ref_inside_state_dispose',
    problemMessage: "Avoid using 'Ref' inside State.dispose.",
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      final targetType = node.realTarget?.staticType;
      if (targetType == null) return;
      if (!widgetRefType.isAssignableFromType(targetType)) return;

      final ancestor = node.thisOrAncestorMatching((method) {
        final isDisposeMethod =
            method is MethodDeclaration && method.name.lexeme == disposeMethod;
        if (!isDisposeMethod) return false;

        return _findConsumerStateClass(node) != null;
      });

      if (ancestor != null) {
        reporter.atNode(node, _code);
      }
    });
  }

  /// Looking for the ConsumerState class ancestor
  /// into the [node] parent.
  AstNode? _findConsumerStateClass(AstNode node) {
    return node.parent?.thisOrAncestorMatching((node) {
      if (node is! ClassDeclaration) return false;

      /// Looking for the class which is a [ConsumerState]
      final extendsClause = node.extendsClause;
      if (extendsClause == null) return false;
      final extendsType = extendsClause.superclass.type;
      if (extendsType == null) return false;

      return consumerStateType.isExactlyType(extendsType);
    });
  }
}
