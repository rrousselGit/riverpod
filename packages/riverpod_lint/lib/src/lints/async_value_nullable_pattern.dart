import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
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
      // Paren't isn't a "final value" pattern
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
      final genericType = grandParentType.typeArguments.first;

      if (genericType is! DynamicType &&
          genericType.nullabilitySuffix != NullabilitySuffix.question) {
        return;
      }

      reporter.reportErrorForNode(_code, node);
    });
  }
}
