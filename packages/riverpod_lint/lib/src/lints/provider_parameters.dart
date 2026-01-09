import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

class ProviderParameters extends AnalysisRule {
  ProviderParameters()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'provider_parameters',
    'Providers should not rely on parameters for their value. '
        'Instead, they should use a family or read other providers.',
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
    registry.addFunctionExpressionInvocation(this, visitor);
    registry.addMethodInvocation(this, visitor);
    registry.addInstanceCreationExpression(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    _checkExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    _checkExpression(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    _checkExpression(node);
  }

  void _checkExpression(Expression node) {
    final expression = node.providerListenable;
    if (expression == null) return;

    final arguments = expression.familyArguments;
    if (arguments == null) return;

    for (final argument in arguments.arguments) {
      Expression value;
      if (argument is NamedExpression) {
        value = argument.expression;
      } else {
        value = argument;
      }

      if (value is TypedLiteral && !value.isConst) {
        // Non-const literals always return a new instance and don't override ==
        rule.reportAtNode(value);
      } else if (value is FunctionExpression) {
        // provider(() => 42) is bad because a new function will always be created
        rule.reportAtNode(value);
      } else if (value is InstanceCreationExpression && !value.isConst) {
        final instantiatedObject =
            value.constructorName.element?.applyRedirectedConstructors();

        final operatorEqual = instantiatedObject?.enclosingElement
            .recursiveGetMethod('==');

        if (operatorEqual == null) {
          // Doing `provider(new Class())` is bad if the class does not override ==
          rule.reportAtNode(value);
        }
      }
    }
  }
}

extension on ConstructorElement {
  ConstructorElement applyRedirectedConstructors() {
    final redirected = redirectedConstructor;
    if (redirected != null) return redirected.applyRedirectedConstructors();
    return this;
  }
}

extension on InterfaceElement {
  MethodElement? recursiveGetMethod(String name) {
    if (thisType.isDartCoreObject) return null;

    final thisMethod = getMethod(name);
    if (thisMethod != null) return thisMethod;

    for (final superType in allSupertypes) {
      if (superType.isDartCoreObject) continue;

      final superMethod = superType.getMethod(name);
      if (superMethod != null) return superMethod;
    }

    return null;
  }
}
