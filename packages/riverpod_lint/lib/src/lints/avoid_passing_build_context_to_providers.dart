import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

const TypeChecker buildContextType = TypeChecker.fromName(
  'BuildContext',
  packageName: 'flutter',
);

class AvoidPassingBuildContextToProviders extends RiverpodLintRule {
  const AvoidPassingBuildContextToProviders() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_passing_build_context_to_providers',
    problemMessage:
        'Passing BuildContext to providers indicates mixing UI with the business logic.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addFunctionalProviderDeclaration((declaration) {
      final parameters = declaration.node.functionExpression.parameters!;
      _emitWarningsForBuildContext(reporter, parameters);
    });

    riverpodRegistry(context).addClassBasedProviderDeclaration((declaration) {
      final methods = declaration.node.members.whereType<MethodDeclaration>();

      for (final method in methods) {
        final parameters = method.parameters!;
        _emitWarningsForBuildContext(reporter, parameters);
      }
    });
  }

  void _emitWarningsForBuildContext(
    ErrorReporter reporter,
    FormalParameterList parameters,
  ) {
    final buildContextParameters = parameters.parameters.where(
      (e) =>
          e.declaredElement?.type != null &&
          buildContextType.isExactlyType(e.declaredElement!.type),
    );

    for (final contextParameter in buildContextParameters) {
      reporter.reportErrorForNode(_code, contextParameter);
    }
  }
}
