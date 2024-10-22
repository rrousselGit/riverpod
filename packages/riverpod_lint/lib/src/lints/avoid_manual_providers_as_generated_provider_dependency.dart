import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class AvoidManualProvidersAsGeneratedProviderDependency
    extends RiverpodLintRule {
  const AvoidManualProvidersAsGeneratedProviderDependency()
      : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_manual_providers_as_generated_provider_dependency',
    problemMessage:
        'Generated providers should only depend on other generated providers. '
        'Failing to do so may break rules such as "provider_dependencies".',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    void checkDependency(
      GeneratorProviderDeclaration provider,
      RefDependencyInvocation dependency,
    ) {
      final dependencyElement = dependency.provider.providerElement;
      if (dependencyElement is! GeneratorProviderDeclarationElement) {
        reporter.atNode(
          dependency.provider.provider ?? dependency.provider.node,
          _code,
        );
      }
    }

    riverpodRegistry(context).addGeneratorProviderDeclaration((declaration) {
      for (final invocation in declaration.refInvocations) {
        if (invocation is RefDependencyInvocation) {
          checkDependency(declaration, invocation);
        }
      }
    });
  }
}
