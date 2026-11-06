import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

@internal
class RuleVisitor extends AnalysisRule {
  RuleVisitor()
    : super(
        name: 'rule_visitor',
        description: 'registerNodeProcessors must match its AstVisitor ',
      );

  @override
  DiagnosticCode get diagnosticCode => const LintCode(
    'rule_visitor',
    '{0}',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addMethodDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final RuleVisitor rule;
  final RuleContext context;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.name.lexeme != 'registerNodeProcessors') {
      return;
    }

    final body = node.body;
    if (body is! BlockFunctionBody) {
      rule.reportAtNode(node, arguments: ['Must use a block body.']);
      return;
    }

    final visitorVar = body.block.statements
        .whereType<VariableDeclarationStatement>()
        .map((e) {
          final type =
              e.variables.variables.firstOrNull?.declaredFragment?.element.type;
          if (type == null) return null;
          return (type: type, node: e);
        })
        .where((e) {
          return e != null &&
              _astVisitorTypeChecker.isAssignableFromType(e.type);
        })
        .firstOrNull;
    if (visitorVar == null ||
        !_astVisitorTypeChecker.isAssignableFromType(visitorVar.type)) {
      rule.reportAtNode(
        node,
        arguments: ['Must contain a visitor variable declaration.'],
      );
      return;
    }

    final registryAdds = _registryAdds(visitorVar.node, body);
    final visitorVisits = _visitorVisits(visitorVar.type);

    for (final registryAdd in registryAdds) {
      if (visitorVisits.contains(registryAdd.$1)) continue;

      rule.reportAtNode(
        registryAdd.$2,
        arguments: ['Unused registry add: $registryAdd.'],
      );
    }

    for (final visitorVisit in visitorVisits) {
      if (registryAdds.any((e) => e.$1 == visitorVisit)) continue;

      rule.reportAtNode(
        node,
        arguments: ['Missing registry add: $visitorVisit.'],
      );
    }
  }

  Set<(String, AstNode)> _registryAdds(
    VariableDeclarationStatement firstVar,
    BlockFunctionBody body,
  ) {
    final registryAdds = <(String, AstNode)>{};
    final otherStatements = body.block.statements.skipWhile(
      (e) => e != firstVar,
    );
    for (final statement in otherStatements) {
      if (statement == firstVar) continue;

      if (statement is! ExpressionStatement) {
        rule.reportAtNode(
          statement,
          arguments: ['Must be an expression statement.'],
        );
        continue;
      }

      final expression = statement.expression;
      if (expression is! MethodInvocation) {
        rule.reportAtNode(
          expression,
          arguments: ['Must be a method invocation.'],
        );
        continue;
      }

      final name = expression.methodName.name;
      if (!name.startsWith('add')) {
        rule.reportAtNode(expression, arguments: ['Must start with "add".']);
        continue;
      }
      final registryTargetName = name.substring('add'.length);

      registryAdds.add((registryTargetName, statement));
    }

    return registryAdds;
  }

  Set<String> _visitorVisits(DartType visitorType) {
    final element = visitorType.element;
    if (element == null || element is! ClassElement) return <String>{};

    final visitorVisits = <String>{};

    final methods = element.methods;
    for (final method in methods) {
      final visitName = method.name;
      if (visitName == null || !visitName.startsWith('visit')) continue;

      final visitTargetName = visitName.substring('visit'.length);
      visitorVisits.add(visitTargetName);
    }

    return visitorVisits;
  }
}

const _astVisitorTypeChecker = TypeChecker.fromName(
  'AstVisitor',
  packageName: 'analyzer',
);
