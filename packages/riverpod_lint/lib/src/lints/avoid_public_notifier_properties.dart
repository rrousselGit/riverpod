import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class AvoidPublicNotifierProperties extends RiverpodLintRule {
  const AvoidPublicNotifierProperties() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_public_notifier_properties',
    problemMessage: 'Notifiers should not have public properties/getters. '
        'Instead, all their public API should be exposed through the `state` property.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final notifierElement = node.declaredElement;

      if (notifierElement == null ||
          !anyNotifierType.isAssignableFromType(notifierElement.thisType)) {
        return;
      }

      for (final member in node.members) {
        bool isVisibleOutsiteTheNotifier(Element? element) {
          return element != null &&
              element.isPublic &&
              !element.hasProtected &&
              !element.hasVisibleForOverriding &&
              !element.hasVisibleForTesting;
        }

        if (member is FieldDeclaration) {
          // We only check class fields, not top-level fields
          if (member.isStatic) continue;

          for (final variable in member.fields.variables) {
            if (!isVisibleOutsiteTheNotifier(variable.declaredElement)) {
              continue;
            }

            reporter.reportErrorForNode(_code, member);
          }
        } else if (member is MethodDeclaration) {
          if (!member.isGetter) continue;
          if (member.isStatic) continue;
          if (!isVisibleOutsiteTheNotifier(member.declaredElement)) continue;

          reporter.reportErrorForNode(_code, member);
        }
      }
    });
  }
}
