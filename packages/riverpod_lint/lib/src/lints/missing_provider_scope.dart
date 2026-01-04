import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../imports.dart';
import 'scoped_providers_should_specify_dependencies.dart';

class MissingProviderScope extends AnalysisRule {
  MissingProviderScope()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'missing_provider_scope',
    'Flutter applications using Riverpod must contain a ProviderScope at the root of their widget tree.',
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
    if (!node.methodName.isFlutterRunApp) return;
    final function = node.function;
    if (function is! SimpleIdentifier) return;
    final functionElement = function.element;
    if (functionElement is! ExecutableElement) return;

    // runApp call detected, now checking if if the first widget is a ProviderScope
    final firstArgument = node.argumentList.arguments.firstOrNull?.staticType;
    if (firstArgument == null) return;

    // There is correctly a ProviderScope at the top of the widget tree
    if (providerScopeType.isExactlyType(firstArgument) ||
        uncontrolledProviderScopeType.isExactlyType(firstArgument)) {
      return;
    }

    rule.reportAtNode(node.methodName, arguments: []);
  }
}

class AddProviderScope extends ResolvedCorrectionProducer {
  AddProviderScope({required super.context});

  static const fix = FixKind(
    'missing_provider_scope',
    DartFixKindPriority.standard,
    'Add ProviderScope',
  );

  @override
  FixKind get fixKind => fix;

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    final methodInvocation = node.parent;
    if (methodInvocation is! MethodInvocation) return;

    final firstArgument = methodInvocation.argumentList.arguments.firstOrNull;
    if (firstArgument == null) return;

    await builder.addDartFileEdit(file, (builder) {
      final providerScope = builder.importProviderScope();

      builder.addSimpleInsertion(
        firstArgument.offset,
        '$providerScope(child: ',
      );
      builder.addSimpleInsertion(firstArgument.end, ')');
    });
  }
}
