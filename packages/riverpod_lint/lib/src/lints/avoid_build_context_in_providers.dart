import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

const TypeChecker buildContextType = TypeChecker.fromName(
  'BuildContext',
  packageName: 'flutter',
);

class AvoidBuildContextInProviders extends AnalysisRule {
  AvoidBuildContextInProviders()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'avoid_build_context_in_providers',
    'Passing BuildContext to providers indicates mixing UI with the business logic.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addMethodDeclaration(this, visitor);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addFunctionalProviderDeclaration((declaration) {
      final parameters = declaration.node.functionExpression.parameters;
      if (parameters == null) return;
      _emitWarningsForBuildContext(reporter, parameters);
    });

    riverpodRegistry(context).addClassBasedProviderDeclaration((declaration) {
      final methods = declaration.node.members.whereType<MethodDeclaration>();

      for (final method in methods) {
        final parameters = method.parameters;
        if (parameters == null) continue;
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
          e.declaredFragment?.element.type != null &&
          buildContextType.isExactlyType(e.declaredFragment!.element.type),
    );

    for (final contextParameter in buildContextParameters) {
      reporter.atNode(contextParameter, _code);
    }
  }
}
