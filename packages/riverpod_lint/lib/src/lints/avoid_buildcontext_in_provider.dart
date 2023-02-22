import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AvoidBuildContextInProvider extends DartLintRule {
  const AvoidBuildContextInProvider() : super(code: _code);

  static const _code = LintCode(
      name: 'avoid_buildcontext_in_providers',
      problemMessage:
          'Providers should pass BuildContext to any of its methods',);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {}
}
