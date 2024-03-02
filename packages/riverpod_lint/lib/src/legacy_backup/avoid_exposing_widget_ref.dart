import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AvoidExposingWidgetRef extends DartLintRule {
  const AvoidExposingWidgetRef() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_exposing_widget_ref',
    problemMessage:
        'The "ref" of a widget should not be accessible outside of that widget.',
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
