import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class ProviderUnsusedDependency extends DartLintRule {
  const ProviderUnsusedDependency() : super(code: _code);

  static const _code = LintCode(
    name: 'provider_unused_dependency',
    problemMessage: 'A provider is listed as dependency but is not used.',
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
