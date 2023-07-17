import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

const disposeMethod = 'dispose';

class AvoidUseRefInsideDispose extends RiverpodLintRule {
  const AvoidUseRefInsideDispose() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_ref_inside_state_dispose',
    problemMessage: "Avoid using 'Ref' in the dispose method.",
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
        final isMethodCalledDispose =
            method is MethodDeclaration && method.name.lexeme == disposeMethod;

        if (!isMethodCalledDispose) return false;

        final classeDeclaration = _findConsumeStateClass(node);

        return classeDeclaration != null;
      });

      if (ancestor != null) {
        reporter.reportErrorForNode(_code, node);
      }
    });
  }

  /// Looking for the ConsumeState class ancestor
  /// into the [node] parent.
  AstNode? _findConsumeStateClass(AstNode node) {
    final classeDeclaration = node.parent?.thisOrAncestorMatching((node) {
      if (node is! ClassDeclaration) return false;

      /// Looking for the class which is a [ConsumeState]
      final extendsClause = node.extendsClause;
      if (extendsClause == null) return false;
      final extendsType = extendsClause.superclass.type;
      if (extendsType == null) return false;

      return consumerStateType.isExactlyType(extendsType);
    });

    return classeDeclaration;
  }
}
