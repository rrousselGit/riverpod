import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class StatelessToStatefulProvider extends DartAssist {
  StatelessToStatefulProvider();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    // TODO: implement run
  }
}
