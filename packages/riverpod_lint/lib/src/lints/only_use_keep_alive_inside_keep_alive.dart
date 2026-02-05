import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

class OnlyUseKeepAliveInsideKeepAlive extends AnalysisRule {
  OnlyUseKeepAliveInsideKeepAlive()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'only_use_keep_alive_inside_keep_alive',
    'KeepAliveLink can only be used inside providers that are kept alive.',
    correctionMessage:
        'Either stop marking this provider as `keepAlive` or '
        'remove `keepAlive` from the used provider.',
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
    final refInvocation = node.refInvocation;
    if (refInvocation is! RefDependencyInvocation) return;

    final dependencyElement =
        refInvocation.listenable.provider?.providerElement;
    // This only applies if the watched provider is a generated one.
    if (dependencyElement is! GeneratorProviderDeclarationElement) return;
    if (!dependencyElement.isAutoDispose) return;

    final provider = node
        .thisOrAncestorOfType<NamedCompilationUnitMember>()
        ?.provider;
    if (provider == null) return;

    // The enclosing provider is "autoDispose", so it is allowed to use other "autoDispose" providers
    if (provider.providerElement.isAutoDispose) return;

    rule.reportAtNode(node);
  }
}
