import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

extension SimpleIdentifierX on SimpleIdentifier {
  bool get isFlutterRunApp {
    if (name != 'runApp') return false;

    final library = element?.library;
    if (library == null) return false;

    return library.uri.scheme == 'package' &&
        library.uri.pathSegments.first == 'flutter';
  }

  bool get isPumpWidget {
    if (name != 'pumpWidget') return false;

    final library = element?.library;
    if (library == null) return false;

    return library.uri.scheme == 'package' &&
        library.uri.pathSegments.first == 'flutter_test';
  }
}

class ScopedProvidersShouldSpecifyDependencies extends AnalysisRule {
  ScopedProvidersShouldSpecifyDependencies()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'scoped_providers_should_specify_dependencies',
    'Scoped providers must specify a list of dependencies.',
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

    registry.addProviderContainerInstanceCreationExpression(
      handleProviderContainerInstanceCreation,
    );

    registry.addProviderScopeInstanceCreationExpression(
      handleProviderScopeInstanceCreation,
    );

    registry.run(node);
  }

  void checkScopedOverrideList(ProviderOverrideList? overrideList) {
    final overrides = overrideList?.overrides;
    if (overrides == null) return;

    for (final override in overrides) {
      final provider = override.provider?.providerElement;

      // We can only know statically if a provider is scoped on generator providers
      if (provider is! GeneratorProviderDeclarationElement) continue;
      if (!provider.isScoped) {
        rule.reportAtNode(override.node);
      }
    }
  }

  void handleProviderScopeInstanceCreation(
    ProviderScopeInstanceCreationExpression expression,
  ) {
    final isScoped = isProviderScopeScoped(expression);
    if (!isScoped) return;

    checkScopedOverrideList(expression.overrides);
  }

  void handleProviderContainerInstanceCreation(
    ProviderContainerInstanceCreationExpression expression,
  ) {
    // This might be doable by checking that the expression's
    // static type is non-nullable
    final hasParent = expression.parent != null;

    // No parent: parameter found, therefore ProviderContainer is never scoped
    if (!hasParent) return;

    checkScopedOverrideList(expression.overrides);
  }

  bool isProviderScopeScoped(
    ProviderScopeInstanceCreationExpression expression,
  ) {
    // in runApp(ProviderScope(..)) the direct parent of the ProviderScope
    // is an ArgumentList.
    final enclosingExpression = expression.node.parent?.parent;

    // If the ProviderScope isn't directly as a child of runApp, it is scoped
    return enclosingExpression is! MethodInvocation ||
        (!enclosingExpression.methodName.isFlutterRunApp &&
            !enclosingExpression.methodName.isPumpWidget);
  }
}
