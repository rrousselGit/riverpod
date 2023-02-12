import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

class AvoidWatchOutsideBuild extends RiverpodLintRule {
  const AvoidWatchOutsideBuild() : super(code: _code);

  static const _code = LintCode(
    name: 'riverpod_avoid_watch_outside_build',
    problemMessage:
        'Avoid using ref.watch outside the build method of widgets/providers.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addRefWatchInvocation((watch) {});
  }
}
