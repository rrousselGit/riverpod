import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

class AsyncValueNullablePattern extends AnalysisRule {
  AsyncValueNullablePattern()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'async_value_nullable_pattern',
    'Using AsyncValue(:final value?) on possibly nullable value is unsafe. '
        'Use AsyncValue(:final value, hasValue: true) instead.',
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
    registry.addNullCheckPattern(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AsyncValueNullablePattern rule;
  final RuleContext context;

  @override
  void visitNullCheckPattern(NullCheckPattern node) {
    // We are looking for "case AsyncValue(:final value?)"
    // We found the ? pattern

    final parent = node.parent;
    // Parent isn't a "final value" pattern
    if (parent is! PatternField || parent.effectiveName != 'value') return;

    final grandParent = parent.parent;
    // GrandParent isn't a "AsyncValue(...)"
    if (grandParent is! ObjectPattern) return;

    final grandParentType = grandParent.type.type;

    const asyncValueTypesToCheck = TypeChecker.any([
      asyncValueType,
      asyncLoadingType,
      asyncErrorType,
      // No AsyncData in here as "hasValue" will always be true
    ]);

    // GrandParent isn't a "AsyncValue<T>"
    if (grandParentType == null ||
        !asyncValueTypesToCheck.isExactlyType(grandParentType)) {
      return;
    }

    grandParentType as InterfaceType;
    var genericType = grandParentType.typeArguments.first;

    // If the AsyncValue's type is a generic type, we check the generic's constraint
    if (genericType is TypeParameterType) {
      final unit = node.thisOrAncestorOfType<CompilationUnit>()!;

      genericType =
          genericType.element3.bound ??
          unit.declaredFragment!.element.library2.typeProvider.dynamicType;
    }

    if (genericType is! DynamicType &&
        genericType.nullabilitySuffix != NullabilitySuffix.question) {
      return;
    }

    rule.reportAtNode(node);
  }
}

class RemoveNullCheckPatternAndAddHasDataCheck
    extends ResolvedCorrectionProducer {
  RemoveNullCheckPatternAndAddHasDataCheck({required super.context});

  static const fix = FixKind(
    'riverpod.remove_null_check_pattern_and_add_has_data_check',
    DartFixKindPriority.standard,
    'Replace null check with hasData:true pattern',
  );

  @override
  FixKind get fixKind => fix;

  @override
  FixKind get multiFixKind => fix;

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.automatically;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final nullCheckPattern = switch (node) {
      final NullCheckPattern node => node,
      _ => null,
    };
    if (nullCheckPattern == null) return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addDeletion(range.token(nullCheckPattern.operator));

      builder.addSimpleInsertion(
        nullCheckPattern.operator.end,
        ', hasValue: true',
      );
    });
  }
}
