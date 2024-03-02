import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AvoidExposingProviderRef extends DartLintRule {
  const AvoidExposingProviderRef() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_exposing_provider_ref',
    problemMessage:
        'The "ref" of a provider should not be accessible from outside of the '
        'provider and its internals.',
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
