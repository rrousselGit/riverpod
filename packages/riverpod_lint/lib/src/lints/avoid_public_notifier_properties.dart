import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

class AvoidPublicNotifierProperties extends DartLintRule {
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
        bool isVisibleOutsideTheNotifier(Element? element) {
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
            if (!isVisibleOutsideTheNotifier(variable.declaredElement)) {
              continue;
            }

            reporter.atNode(member, _code);
          }
        } else if (member is MethodDeclaration) {
          if (!member.isGetter) continue;
          if (member.isStatic) continue;
          if (!isVisibleOutsideTheNotifier(member.declaredElement)) continue;

          reporter.atNode(member, _code);
        }
      }
    });
  }
}
