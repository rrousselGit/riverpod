import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart'
    hide
        // ignore: undefined_hidden_name, necessary to support lower analyzer version
        LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import 'scoped_providers_should_specify_dependencies.dart';

class MissingProviderScope extends DartLintRule {
  const MissingProviderScope() : super(code: _code);

  static const _code = LintCode(
    name: 'missing_provider_scope',
    problemMessage: 'Flutter applications should have a ProviderScope widget '
        'at the top of the widget tree.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      if (!node.methodName.isFlutterRunApp) return;
      final function = node.function;
      if (function is! SimpleIdentifier) return;
      final functionElement = function.staticElement;
      if (functionElement is! FunctionElement) return;

      // runApp call detected, now checking if if the first widget is a ProviderScope
      final firstArgument = node.argumentList.arguments.firstOrNull?.staticType;
      if (firstArgument == null) return;

      // There is correctly a ProviderScope at the top of the widget tree
      if (providerScopeType.isExactlyType(firstArgument) ||
          uncontrolledProviderScopeType.isExactlyType(firstArgument)) {
        return;
      }

      reporter.atNode(node.methodName, _code);
    });
  }

  @override
  List<Fix> getFixes() => [AddProviderScope()];
}

class AddProviderScope extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addMethodInvocation((node) {
      // The method is not impacte by this analysis error
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Add ProviderScope',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        final firstArgument = node.argumentList.arguments.firstOrNull;
        if (firstArgument == null) return;

        builder.addSimpleInsertion(
          firstArgument.offset,
          'ProviderScope(child: ',
        );
        builder.addSimpleInsertion(firstArgument.end, ')');
      });
    });
  }
}
