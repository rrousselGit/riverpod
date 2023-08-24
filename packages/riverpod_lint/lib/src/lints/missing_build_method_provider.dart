import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

const _riverpodAnnotation = 'riverpod';
const _buildMethodName = 'build';

class NotifierBuild extends RiverpodLintRule {
  const NotifierBuild() : super(code: _code);

  static const _code = LintCode(
    name: 'notifier_build',
    problemMessage:
        'Classes annotated by `@riverpod` must have the `build` method',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final hasRiverpodAnnotation = node.metadata
          .where(
            (element) => element.name.name.toLowerCase() == _riverpodAnnotation,
          )
          .isNotEmpty;

      if (!hasRiverpodAnnotation) return;

      final hasBuildMethod = node.members
          .where((e) => e.declaredElement?.displayName == _buildMethodName)
          .isNotEmpty;

      if (hasBuildMethod) return;

      reporter.reportErrorForNode(_code, node);
    });
  }
}
