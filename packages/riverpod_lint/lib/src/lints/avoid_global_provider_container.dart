import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AvoidGlobalProviderContainer extends DartLintRule {
  const AvoidGlobalProviderContainer() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_global_provider_container',
    problemMessage:
        'ProviderContainer instances should not be accessible globally.',
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
