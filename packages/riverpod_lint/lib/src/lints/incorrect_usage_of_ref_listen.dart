import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class IncorrectUsageOfRefListen extends RiverpodLintRule {
  const IncorrectUsageOfRefListen() : super(code: _code);

  static const _code = LintCode(
    name: 'incorrect_usage_of_ref_listen',
    problemMessage: 'Incorrect usage of ref.listen.',
    correctionMessage: 'Put ref.listen in build method.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addRefListenInvocation((invocation) {
      final parent = invocation.parent;
      final methodName = invocation.node
          .thisOrAncestorOfType<MethodDeclaration>()
          ?.name
          .lexeme;

      if (parent is LegacyProviderDeclaration ||
          parent is FunctionalProviderDeclaration ||
          methodName == 'build') return;

      reporter.reportErrorForNode(code, invocation.node.methodName);
    });
  }
}
