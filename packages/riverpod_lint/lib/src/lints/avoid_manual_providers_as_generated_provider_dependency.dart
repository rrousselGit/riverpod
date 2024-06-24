import 'package:analyzer/dart/ast/ast.dart';
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
    riverpodRegistry(context).addProviderIdentifier((dependency) {
      // The dependency is a generated provider, no need to check
      if (dependency.providerElement is GeneratorProviderDeclarationElement) {
        return;
      }
      // We're depending on a non-generated provider. Let's check if the
      // associated provider is a generated provider
      final enclosingProvider = dependency.node
          .thisOrAncestorOfType<NamedCompilationUnitMember>()
          ?.provider;

      if (enclosingProvider != null) {
        reporter.atNode(dependency.node, code);
      }
    });
  }
}
