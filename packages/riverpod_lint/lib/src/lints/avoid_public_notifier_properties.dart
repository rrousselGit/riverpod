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
    problemMessage:
        'Notifiers should not have public properties/getters. '
        'Instead, all their public API should be exposed through the `state` property.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final notifierElement = node.declaredFragment?.element;

      if (notifierElement == null ||
          !anyNotifierType.isAssignableFromType(notifierElement.thisType)) {
        return;
      }

      for (final member in node.members) {
        final metadata = switch (member) {
          FieldDeclaration() =>
            member.fields.variables.first.declaredFragment?.element,
          _ => member.declaredFragment?.element,
        };
        // Skip members if there's an @override annotation
        if (metadata == null || metadata.metadata.hasOverride) {
          continue;
        }

        bool isVisibleOutsideTheNotifier(Element? element) {
          return element != null &&
              element.isPublic &&
              !element.metadata.hasProtected &&
              !element.metadata.hasVisibleForOverriding &&
              !element.metadata.hasVisibleForTesting;
        }

        if (member is FieldDeclaration) {
          // We only check class fields, not top-level fields
          if (member.isStatic) continue;

          for (final variable in member.fields.variables) {
            if (variable.isFinal) continue;
            if (!isVisibleOutsideTheNotifier(
              variable.declaredFragment?.element,
            )) {
              continue;
            }

            reporter.atNode(member, _code);
          }
        } else if (member is MethodDeclaration) {
          if (!member.isGetter) continue;
          if (member.isStatic) continue;
          if (!isVisibleOutsideTheNotifier(member.declaredFragment!.element)) {
            continue;
          }

          reporter.atNode(member, _code);
        }
      }
    });
  }
}
