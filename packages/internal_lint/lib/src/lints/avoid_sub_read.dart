import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

@internal
class AvoidSubRead extends DartLintRule {
  const AvoidSubRead() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_sub_read',
    problemMessage: 'Do not use `sub.read()` within Riverpod packages.',
    errorSeverity: DiagnosticSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    const ignoredFolderPaths = {
      'test',
      'example',
      'examples',
      'website',
      'benchmarks',
    };
    final segments = p.split(resolver.path).toSet();
    if (segments.intersection(ignoredFolderPaths).isNotEmpty) return;

    context.registry.addPrefixedIdentifier((node) {
      if (node.identifier.name != 'read') return;

      final targetType = node.prefix.staticType;
      if (targetType == null) return;

      if (!providerSubscriptionType.isAssignableFromType(targetType)) {
        return;
      }

      reporter.atNode(node, _code, arguments: [targetType.toString()]);
    });

    context.registry.addMethodInvocation((node) {
      if (node.methodName.name != 'read') return;

      final targetType = node.realTarget?.staticType;
      if (targetType == null) return;

      if (!providerSubscriptionType.isAssignableFromType(targetType)) {
        return;
      }

      reporter.atNode(node, _code);
    });
  }
}
