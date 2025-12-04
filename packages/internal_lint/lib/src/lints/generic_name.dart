import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:meta/meta.dart';

@internal
class GenericName extends AnalysisRule {
  GenericName()
    : super(
        name: 'generic_name',
        description:
            'Suffix generics with an uppercase T and as least 2 characters.',
      );

  @override
  DiagnosticCode get diagnosticCode => const LintCode(
    'generic_name',
    'Suffix generics with an uppercase T and as least 2 characters.',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addTypeParameter(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final GenericName rule;
  final RuleContext context;

  @override
  void visitTypeParameter(TypeParameter node) {
    if (node.name.lexeme.endsWith('T') && node.name.lexeme.length >= 2) {
      return;
    }

    rule.reportAtNode(node);
  }
}
