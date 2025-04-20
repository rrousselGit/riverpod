import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart'
    hide
        // ignore: undefined_hidden_name, necessary to support lower analyzer version
        LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class AsyncValueNullablePattern extends RiverpodLintRule {
  const AsyncValueNullablePattern() : super(code: _code);

  static const _code = LintCode(
    name: 'async_value_nullable_pattern',
    problemMessage:
        'Using AsyncValue(:final value?) on possibly nullable value is unsafe. '
        'Use AsyncValue(:final value, hasValue: true) instead.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addNullCheckPattern((node) {
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

        genericType = genericType.element.bound ??
            unit.declaredElement!.library.typeProvider.dynamicType;
      }

      if (genericType is! DynamicType &&
          genericType.nullabilitySuffix != NullabilitySuffix.question) {
        return;
      }

      reporter.atNode(node, _code);
    });
  }

  @override
  List<DartFix> getFixes() => [_AddHasDataFix()];
}

class _AddHasDataFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addNullCheckPattern((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Use "hasValue: true" instead',
        priority: 100,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addDeletion(node.operator.sourceRange);

        builder.addSimpleInsertion(node.operator.end, ', hasValue: true');
      });
    });
  }
}
