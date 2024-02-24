import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class Deps extends RiverpodLintRule {
  const Deps() : super(code: _code);

  static const _code = LintCode(
    name: 'dependencies',
    problemMessage: '{0}',
    // TODO changelog: provider_dependencies is now a WARNING
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addAccumulatedDependencyList((list) {
      final allDependencies = list.allDependencies ?? const [];
      for (final dependency in allDependencies) {
        final parent = list.parent;
        if (parent == null) continue;

        if (parent.allDependencies
                ?.any((e) => e.provider == dependency.provider) ??
            false) {
          continue;
        }

        final message = switch (list.node) {
          final IdentifierAccumulatedDependencyNode node =>
            '`${node.node.name}` has for dependency `${dependency.provider.name}`, '
                'but the dependency is not present in the ancestor @Dependencies/@Riverpod',
          final TypeAnnotationAccumulatedDependencyNode node =>
            'Type `${node.node.type}` has for dependency `${dependency.provider.name}`, '
                'but the dependency is not present in the ancestor @Dependencies/@Riverpod',
          AnnotatedNodeAccumulatedDependencyNode() =>
            'Specified `${dependency.provider.name}`, '
                'but the dependency is not present in the ancestor @Dependencies/@Riverpod',
        };

        reporter.reportErrorForNode(
          _code,
          dependency.node ?? list.node.node,
          [message],
        );
      }
    });
  }
}
