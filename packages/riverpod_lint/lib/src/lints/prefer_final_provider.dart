import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

class PreferFinalProvider extends RiverpodLintRule {
  const PreferFinalProvider() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_final_provider',
    problemMessage: 'Providers should be declared as final variables',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addLegacyProviderDeclaration((provider) {
      if (!provider.node.isFinal) {
        reporter.atNode(provider.node, _code);
      }
    });
  }
}
