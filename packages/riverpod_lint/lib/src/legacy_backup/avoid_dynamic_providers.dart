import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AvoidDynamicProviders extends DartLintRule {
  const AvoidDynamicProviders() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_dynamic_providers',
    problemMessage:
        'Providers should only be created statically. They should not be '
        'created inside functions or as properties of an object.',
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
