import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart'
    hide
        // ignore: undefined_hidden_name, necessary to support broad analyzer versions
        LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class ProviderParameters extends RiverpodLintRule {
  const ProviderParameters() : super(code: _code);

  static const _code = LintCode(
    name: 'provider_parameters',
    problemMessage: 'Providers parameters should have a consistent ==. '
        'Meaning either the values should be cached, or the parameters should override ==',
    url:
        'https://riverpod.dev/docs/concepts/modifiers/family#passing-multiple-parameters-to-a-family',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addExpression((node) {
      final expression = node.providerListenable;
      if (expression == null) return;

      final arguments = expression.familyArguments;
      if (arguments == null) return;

      for (final argument in arguments.arguments) {
        Expression value;
        if (argument is NamedExpression) {
          value = argument.expression;
        } else {
          value = argument;
        }

        if (value is TypedLiteral && !value.isConst) {
          // Non-const literals always return a new instance and don't override ==
          reporter.atNode(value, _code);
        } else if (value is FunctionExpression) {
          // provider(() => 42) is bad because a new function will always be created
          reporter.atNode(value, _code);
        } else if (value is InstanceCreationExpression && !value.isConst) {
          final instantiatedObject = value.constructorName.staticElement
              ?.applyRedirectedConstructors();

          final operatorEqual = instantiatedObject
              // ignore: deprecated_member_use, necessary to support older versions of analyzer
              ?.enclosingElement
              .recursiveGetMethod('==');

          if (operatorEqual == null) {
            // Doing `provider(new Class())` is bad if the class does not override ==
            reporter.atNode(value, _code);
          }
        }
      }
    });
  }
}

extension on ConstructorElement {
  ConstructorElement applyRedirectedConstructors() {
    final redirected = redirectedConstructor;
    if (redirected != null) return redirected.applyRedirectedConstructors();
    return this;
  }
}

extension on InterfaceElement {
  MethodElement? recursiveGetMethod(String name) {
    if (thisType.isDartCoreObject) return null;

    final thisMethod = getMethod(name);
    if (thisMethod != null) return thisMethod;

    for (final superType in allSupertypes) {
      if (superType.isDartCoreObject) continue;

      final superMethod = superType.getMethod(name);
      if (superMethod != null) return superMethod;
    }

    return null;
  }
}
