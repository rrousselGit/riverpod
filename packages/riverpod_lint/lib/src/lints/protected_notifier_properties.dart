import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

class ProtectedNotifierProperties extends AnalysisRule {
  ProtectedNotifierProperties()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'protected_notifier_properties',
    'Notifier.state should not be used outside of its own class.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addPropertyAccess(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitPropertyAccess(PropertyAccess node) {
    const protectedProperties = {'state', 'stateOrNull', 'future', 'ref'};

    if (!protectedProperties.contains(node.propertyName.name)) {
      return;
    }

    final enclosingClass = node.thisOrAncestorOfType<ClassDeclaration>();
    final enclosingClassElement = enclosingClass?.declaredFragment?.element;
    if (enclosingClass == null || enclosingClassElement == null) return;

    if (enclosingClass.riverpod == null) return;

    final targetType = node.target?.staticType;
    if (targetType == null) return;
    if (targetType == enclosingClassElement.thisType) return;
    if (!anyNotifierType.isAssignableFromType(targetType)) return;

    rule.reportAtNode(node.propertyName);
  }
}
