import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

@internal
class AvoidSubRead extends AnalysisRule {
  AvoidSubRead()
    : super(
        name: 'avoid_sub_read',
        description: 'Do not use `sub.read()` within Riverpod packages.',
      );

  @override
  DiagnosticCode get diagnosticCode => const LintCode(
    'avoid_sub_read',
    'Do not use `sub.read()` within Riverpod packages. {0}',
    severity: DiagnosticSeverity.ERROR,
  );

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    const ignoredFolderPaths = {
      'test',
      'example',
      'examples',
      'website',
      'benchmarks',
    };
    final segments = p.split(context.definingUnit.file.path).toSet();
    if (segments.intersection(ignoredFolderPaths).isNotEmpty) return;

    final visitor = _Visitor(this, context);
    registry.addPrefixedIdentifier(this, visitor);
    registry.addMethodInvocation(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AvoidSubRead rule;
  final RuleContext context;

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (node.identifier.name != 'read') return;

    final targetType = node.prefix.staticType;
    if (targetType == null) return;

    if (!providerSubscriptionType.isAssignableFromType(targetType)) return;

    rule.reportAtNode(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.name != 'read') return;

    final targetType = node.realTarget?.staticType;
    if (targetType == null) return;

    if (!providerSubscriptionType.isAssignableFromType(targetType)) return;

    rule.reportAtNode(node);
  }
}

/// [TypeChecker] from `ProviderSubscription`
const providerSubscriptionType = TypeChecker.fromName(
  'ProviderSubscription',
  packageName: 'riverpod',
);
