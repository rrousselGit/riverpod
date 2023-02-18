import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class ProviderDependency extends RiverpodLintRule {
  const ProviderDependency() : super(code: _code);

  static const _code = LintCode(
    name: 'provider_dependencies',
    problemMessage:
        'If a provider depends on providers which specify "dependencies", '
        'they should themselves specify "dependencies" and include all the scoped providers.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    void checkDependency(ProviderListenableExpression dependency) {
      final dependencyElement = dependency.providerElement;
      if (dependencyElement is! GeneratorProviderDeclarationElement) {
        return;
      }
    }

    riverpodRegistry(context).addGeneratorProviderDeclaration((declaration) {});
  }
}
