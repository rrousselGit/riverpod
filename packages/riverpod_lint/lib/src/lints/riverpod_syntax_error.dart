import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

class RiverpodSyntaxError extends AnalysisRule {
  RiverpodSyntaxError()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'riverpod_syntax_error',
    '{0}',
    severity: DiagnosticSeverity.ERROR,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addCompilationUnit(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitCompilationUnit(CompilationUnit node) {
    final registry = RiverpodAstRegistry();

    registry.addRiverpodAnalysisError((error) {
      if (error.code == RiverpodAnalysisErrorCode.missingNotifierBuild) {
        return;
      }

      rule.reportAtNode(error.targetNode, arguments: [error.message]);
    });

    registry.run(node);
  }
}
