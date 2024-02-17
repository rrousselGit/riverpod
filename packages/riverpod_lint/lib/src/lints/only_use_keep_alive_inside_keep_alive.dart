import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class OnlyUseKeepAliveInsideKeepAlive extends RiverpodLintRule {
  const OnlyUseKeepAliveInsideKeepAlive() : super(code: _code);

  // TODO changelog added avoid_keep_alive_dependency_inside_auto_dispose
  static const _code = LintCode(
    name: 'only_use_keep_alive_inside_keep_alive',
    problemMessage: 'If a provider is declared as `keepAlive`, '
        'it can only use providers that are also declared as `keepAlive.',
    correctionMessage: 'Either stop marking this provider as `keepAlive` or '
        'remove `keepAlive` from the used provider.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addGeneratorProviderDeclaration((node) {
      // The current provider is "autoDispose", so it is allowed to use other "autoDispose" providers
      if (node.providerElement.isAutoDispose) return;

      for (final refInvocation in node.node.refInvocations) {
        switch (refInvocation) {
          case RefDependencyInvocation(
                provider: ProviderListenableExpression(
                  :final GeneratorProviderDeclarationElement providerElement,
                )
              )
              when providerElement.isAutoDispose:
            reporter.reportErrorForNode(_code, refInvocation.node);
        }
      }
    });
  }
}
