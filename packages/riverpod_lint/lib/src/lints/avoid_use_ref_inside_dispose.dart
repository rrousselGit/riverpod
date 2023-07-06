import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

const overrideAnnotation = 'override';
const disposeMethod = 'dispose';

class AvoidUseRefInsideDispose extends RiverpodLintRule {
  const AvoidUseRefInsideDispose() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_use_ref_inside_dispose',
    problemMessage: "Avoid using 'Ref' in the dispose method.",
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      final targetType = node.realTarget?.staticType;

      if (targetType == null) return;

      if (widgetRefType.isAssignableFromType(targetType)) {
        final ancestor = node.thisOrAncestorMatching((method) {
          if (method is MethodDeclaration) {
            final hasOverride = method.metadata.firstWhereOrNull((element) {
              return element.name.name == overrideAnnotation;
            });

            if (method.name.lexeme == disposeMethod && hasOverride != null) {
              return true;
            }
          }
          return false;
        });

        if (ancestor != null) {
          reporter.reportErrorForNode(_code, node);
        }
      }
    });
  }
}
