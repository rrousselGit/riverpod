import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart'
    hide
        // ignore: undefined_hidden_name, necessary to support broad analyzer versions
        LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class OnlyUseKeepAliveInsideKeepAlive extends RiverpodLintRule {
  const OnlyUseKeepAliveInsideKeepAlive() : super(code: _code);

  static const _code = LintCode(
    name: 'only_use_keep_alive_inside_keep_alive',
    problemMessage:
        'If a provider is declared as `keepAlive`, '
        'it can only use providers that are also declared as `keepAlive.',
    correctionMessage:
        'Either stop marking this provider as `keepAlive` or '
        'remove `keepAlive` from the used provider.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addRefInvocation((node) {
      if (node is! RefDependencyInvocation) return;
      final dependencyElement = node.listenable.provider?.providerElement;
      // This only applies if the watched provider is a generated one.
      if (dependencyElement is! GeneratorProviderDeclarationElement) return;
      if (!dependencyElement.isAutoDispose) return;

      final provider =
          node.node
              .thisOrAncestorOfType<NamedCompilationUnitMember>()
              ?.provider;
      if (provider == null) return;

      // The enclosing provider is "autoDispose", so it is allowed to use other "autoDispose" providers
      if (provider.providerElement.isAutoDispose) return;

      reporter.atNode(node.node, _code);
    });
  }
}
