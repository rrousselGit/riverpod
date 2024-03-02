import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class DontModifyProvidersInsideWidgetLifecycles extends DartLintRule {
  const DontModifyProvidersInsideWidgetLifecycles() : super(code: _code);

  static const _code = LintCode(
    name: 'dont_modify_providers_inside_widget_lifecycles',
    problemMessage: 'Widget life-cycles are not allowed to modify providers, '
        'and this would lead to an exception.',
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
