import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

const disposeMethod = 'dispose';

class AvoidRefInsideStateDispose extends AnalysisRule {
  AvoidRefInsideStateDispose()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'avoid_ref_inside_state_dispose',
    'Avoid using ref in State.dispose. '
        'Ref is already disposed when State.dispose is called.',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addMethodInvocation(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final targetType = node.realTarget?.staticType;
    if (targetType == null) return;
    if (!widgetRefType.isAssignableFromType(targetType)) return;

    final ancestor = node.thisOrAncestorMatching((method) {
      final isDisposeMethod =
          method is MethodDeclaration && method.name.lexeme == disposeMethod;
      if (!isDisposeMethod) return false;

      return _findConsumerStateClass(node) != null;
    });

    if (ancestor != null) {
      rule.reportAtNode(node);
    }
  }

  /// Looking for the ConsumerState class ancestor
  /// into the [node] parent.
  AstNode? _findConsumerStateClass(AstNode node) {
    return node.parent?.thisOrAncestorMatching((node) {
      if (node is! ClassDeclaration) return false;

      /// Looking for the class which is a [ConsumerState]
      final extendsClause = node.extendsClause;
      if (extendsClause == null) return false;
      final extendsType = extendsClause.superclass.type;
      if (extendsType == null) return false;

      return consumerStateType.isExactlyType(extendsType);
    });
  }
}
