import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

const buildContextType = TypeChecker.fromName(
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
    registry.addFunctionDeclaration(this, visitor);
    registry.addClassDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final declaration = node.provider;
    if (declaration == null) return;

    final parameters = declaration.node.functionExpression.parameters;
    if (parameters == null) return;

    _emitWarningsForBuildContext(parameters);
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final declaration = node.provider;
    if (declaration == null) return;

    final methods = declaration.node.members.whereType<MethodDeclaration>();

    for (final method in methods) {
      final parameters = method.parameters;
      if (parameters == null) continue;
      _emitWarningsForBuildContext(parameters);
    }
  }

  void _emitWarningsForBuildContext(FormalParameterList parameters) {
    final buildContextParameters = parameters.parameters.where(
      (e) =>
          e.declaredFragment?.element.type != null &&
          buildContextType.isExactlyType(e.declaredFragment!.element.type),
    );

    buildContextParameters.forEach(rule.reportAtNode);
  }
}
