import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:meta/meta.dart';

@internal
class GenericName extends DartLintRule {
  const GenericName() : super(code: _code);

  static const _code = LintCode(
    name: 'generic_name',
    problemMessage:
        'Suffix generics with an uppercase T and as least 2 characters.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addTypeParameter((node) {
      if (node.name.lexeme.endsWith('T') && node.name.lexeme.length >= 2) {
        return;
      }

      reporter.atNode(node, _code);
    });
  }
}
