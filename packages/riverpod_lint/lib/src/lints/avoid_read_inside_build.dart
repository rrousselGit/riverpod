import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AvoidReadAutoDispose extends DartLintRule {
  const AvoidReadAutoDispose() : super(code: _code);

  static const _code = LintCode(
    name: 'riverpod_avoid_read_auto_dispose',
    problemMessage: 'Avoid using ref.read on an autoDispose provider',
    correctionMessage: '''
Instead use:
  final listener = ref.listen({0}, (_, __){});
  final currentValue = listener.read();
Then dispose of the listener when you no longer need the autoDispose provider to be kept alive.''',
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
