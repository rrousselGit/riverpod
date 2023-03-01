import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import '../riverpod_custom_lint.dart';


class AvoidBuildContextInProviders extends RiverpodLintRule {
  const AvoidBuildContextInProviders() : super(code: _code);

  static const _code = LintCode(
    name: "avoid_buildContext_in_providers",
    problemMessage: "Avoid passing BuildContext to providers",
  );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter,
      CustomLintContext context) {
    riverpodRegistry(context).addProviderListenableExpression((expression) {
      final arguments = expression.familyArguments;
      if (arguments == null ) return;
      for (final argument in arguments.arguments){
        Expression value;
        value = argument is NamedExpression ? argument.expression : argument;
        if (value is BuildContext) {
          // still in progress, looking for a way to check if the argument type is BuildContext
          reporter.reportErrorForNode(_code, value);
        }
      }
    });
  }
}
