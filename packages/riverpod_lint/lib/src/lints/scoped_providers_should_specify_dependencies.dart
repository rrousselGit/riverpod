import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

class ScopedProvidersShouldSpecifyDependencies extends RiverpodLintRule {
  const ScopedProvidersShouldSpecifyDependencies() : super(code: _code);

  static const _code = LintCode(
    name: 'scoped_providers_should_specify_dependencies',
    problemMessage:
        'Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context)
      ..addProviderScopeInstanceCreationExpression((expression) {})
      ..addProviderContainerInstanceCreationExpression((expression) {});
  }
}
