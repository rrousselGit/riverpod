import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

class ProtectedNotifierProperties extends DartLintRule {
  const ProtectedNotifierProperties() : super(code: _code);

  static const _code = LintCode(
    name: 'protected_notifier_properties',
    problemMessage:
        'Notifier.state should not be used outside of its own class.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addPropertyAccess((propertyAccess) {
      const protectedProperties = {
        'state',
        'stateOrNull',
        'future',
        'ref',
      };

      if (!protectedProperties.contains(propertyAccess.propertyName.name)) {
        return;
      }

      final enclosingClass =
          propertyAccess.thisOrAncestorOfType<ClassDeclaration>();
      final enclosingClassElement = enclosingClass?.declaredElement;
      if (enclosingClass == null || enclosingClassElement == null) return;

      if (enclosingClass.riverpod == null) return;

      final targetType = propertyAccess.target?.staticType;
      if (targetType == null) return;
      if (targetType == enclosingClassElement.thisType) return;
      if (!anyNotifierType.isAssignableFromType(targetType)) return;

      reporter.reportErrorForNode(_code, propertyAccess.propertyName);
    });
  }
}
