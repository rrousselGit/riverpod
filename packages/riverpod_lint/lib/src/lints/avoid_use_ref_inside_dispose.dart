import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

const disposeMethod = 'dispose';

class AvoidUseRefInsideDispose extends RiverpodLintRule {
  const AvoidUseRefInsideDispose() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_ref_inside_state_dispose',
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
          if (method is MethodDeclaration &&
              method.name.lexeme == disposeMethod) {
            /// This [thisOrAncestorMatching] is to look for an ancestor of the
            /// [dispose] method found
            final classe = method.thisOrAncestorMatching((element) {
              /// Looking for the class which is a [ConsumeState]
              final classe = element.thisOrAncestorMatching((classe) {
                if (classe is ClassDeclaration) {
                  final extendsClause = classe.extendsClause;
                  if (extendsClause == null) return false;
                  final extendsType = extendsClause.superclass.type;
                  if (extendsType == null) return false;

                  return consumerStateType.isExactlyType(extendsType);
                }

                return false;
              });

              return classe != null;
            });

            return classe != null;
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
