import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

extension DartObjectSuperField on DartObject {
  DartObject? getFieldInThisOrSuper(String name) {
    final field = getField(name);
    if (field != null) return field;

    final superField = getField('(super)');
    if (superField == null) return null;

    return superField.getFieldInThisOrSuper(name);
  }
}

class ConsumerDependencies extends RiverpodLintRule {
  const ConsumerDependencies() : super(code: _code);

  static const _code = LintCode(
    name: 'consumer_dependencies',
    problemMessage: '{0}',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addSimpleIdentifier((node) {
      final type = node.staticType;
      if (type == null) return;
      final element = node.staticElement;
      if (element is! PropertyAccessorElement) return;

      final variableElement = element.variable;
      if (!providerForType.hasAnnotationOfExact(variableElement)) return;

      final constantValue = variableElement.computeConstantValue();
      if (constantValue == null) return;

      final allTransitiveDependenciesObject =
          constantValue.getFieldInThisOrSuper('allTransitiveDependencies');

      if (allTransitiveDependenciesObject == null) {
        // Bad state, the constant likely didn't contain a provider.
        // Did a user annotate a random variable with `@ProviderFor`?
        return;
      }
      final allTransitiveDependencies =
          allTransitiveDependenciesObject.toListValue();

      // No, nothing to lint.
      if (allTransitiveDependencies == null) return;

      final enclosingMethodInvocation =
          node.thisOrAncestorOfType<MethodInvocation>();
      final refInvocation = enclosingMethodInvocation?.refInvocation;
      final widgetRefInvocation =
          enclosingMethodInvocation?.widgetRefInvocation;

      // TODO reject ref.watch(obj.method(provider))
      if (refInvocation != null || widgetRefInvocation != null) return;

      // The provider expression is for an override, so it's fine.
      final enclosingExpression = node.thisOrAncestorOfType<Expression>();
      final enclosingExpressionType = enclosingExpression?.staticType;

      if (enclosingExpressionType != null &&
          overrideType.isAssignableFromType(enclosingExpressionType)) {
        return;
      }

      reporter.reportErrorForNode(
        code,
        node,
        ['A provider was used, but could not find the associated `ref`.'],
      );
    });
  }
}
