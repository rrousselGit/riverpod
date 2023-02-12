import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class ProviderMissingDependency extends DartLintRule {
  const ProviderMissingDependency() : super(code: _code);

  static const _code = LintCode(
    name: 'provider_missing_dependency',
    problemMessage:
        'The provider depends on {0} but {0} is not present in `dependencies`.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // TODO: implement run
  }
}
