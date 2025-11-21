import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

extension on ClassBasedProviderDeclaration {
  /// Returns whether the value exposed by the provider is the newly created
  /// Notifier itself.
  bool get returnsSelf {
    return providerElement.valueTypeNode ==
        node.declaredFragment?.element.thisType;
  }
}

class UnsupportedProviderValue extends AnalysisRule {
  UnsupportedProviderValue()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'unsupported_provider_value',
    'The value returned by the provider is not supported.',
    correctionMessage: 'Try wrapping the value in a Future or Stream.',
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

    registry.addFunctionalProviderDeclaration(checkCreatedType);
    registry.addClassBasedProviderDeclaration(checkCreatedType);

    registry.run(node);
  }

  void checkCreatedType(GeneratorProviderDeclaration declaration) {
    final valueType = declaration.providerElement.valueTypeNode;
    if (valueType.isRaw) return;

    String? invalidValueName;
    if (notifierBaseType.isAssignableFromType(valueType)) {
      invalidValueName = 'Notifier';
    } else if (asyncNotifierBaseType.isAssignableFromType(valueType)) {
      invalidValueName = 'AsyncNotifier';
    }

    /// If a provider returns itself, we allow it. This is to enable
    /// ChangeNotifier-like mutable state.
    if (invalidValueName != null &&
        declaration is ClassBasedProviderDeclaration &&
        declaration.returnsSelf) {
      return;
    }

    if (stateNotifierType.isAssignableFromType(valueType)) {
      invalidValueName = 'StateNotifier';
    } else if (changeNotifierType.isAssignableFromType(valueType)) {
      invalidValueName = 'ChangeNotifier';
    }

    if (invalidValueName != null) {
      rule.reportAtToken(
        declaration.name,
        arguments: [invalidValueName],
      );
    }
  }
}
