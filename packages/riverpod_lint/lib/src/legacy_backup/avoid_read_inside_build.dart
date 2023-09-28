import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

class AvoidReadInsideBuild extends RiverpodLintRule {
  const AvoidReadInsideBuild() : super(code: _code);

  static const _code = LintCode(
    name: 'riverpod_avoid_read_inside_build',
    problemMessage:
        'Avoid using ref.read inside the build method of widgets/providers.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {}
}
