import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class ProviderDependencies extends RiverpodLintRule {
  const ProviderDependencies() : super(code: _code);

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
    void checkInvocation(
      GeneratorProviderDeclaration provider,
      RefDependencyInvocation dependency,
    ) {
      final dependencyElement = dependency.provider.providerElement;
      if (dependencyElement is! GeneratorProviderDeclarationElement) {
        // If we cannot statically determine the dependencies of the dependency,
        // we cannot check if the provider is missing a dependency.
        return;
      }

      if (dependencyElement.annotation.dependencies == null) {
        // The dependency did not specify "dependencies" and therefore
        // does not need to be listed in the provider's "dependencies"
        return;
      }

      final dependencies = provider.annotation.dependencies;
      if (dependencies == null) {
        // Depends on a scoped provider but does not specify "dependencies"
        reporter.reportErrorForNode(_code, provider.annotation.annotation);
        return;
      }

      if (!dependencies.any((e) => e.provider == dependencyElement)) {
        // The provider specified "dependencies" but is missing a scoped dependency
        reporter.reportErrorForNode(_code, provider.annotation.annotation);
        return;
      }
    }

    void checkDependency(
      GeneratorProviderDeclaration declaration,
      RiverpodAnnotationDependency dependency,
    ) {
      for (final invocation
          in declaration.refInvocations.whereType<RefDependencyInvocation>()) {
        if (invocation.provider.providerElement?.name ==
            dependency.provider.name) {
          return;
        }
      }

      // The provider specified a dependency but does not use it
      reporter.reportErrorForNode(_code, dependency.node);
    }

    riverpodRegistry(context).addGeneratorProviderDeclaration((declaration) {
      for (final invocation in declaration.refInvocations) {
        if (invocation is RefDependencyInvocation) {
          checkInvocation(declaration, invocation);
        }
      }

      final dependencies = declaration.annotation.dependencies;
      if (dependencies != null) {
        for (final dependency in dependencies) {
          checkDependency(declaration, dependency);
        }
      }
    });
  }
}
