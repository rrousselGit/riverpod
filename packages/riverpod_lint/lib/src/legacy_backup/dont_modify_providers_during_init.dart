import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class DontModifyProvidersDuringInit extends DartLintRule {
  const DontModifyProvidersDuringInit() : super(code: _code);

  static const _code = LintCode(
    name: 'dont_modify_providers_during_init',
    problemMessage:
        'During its initialization, a provider should not modify other providers.',
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
