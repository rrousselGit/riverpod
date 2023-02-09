import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

class AvoidGlobalProviderContainer extends DartLintRule {
  const AvoidGlobalProviderContainer() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_global_provider_container',
    problemMessage:
        'ProviderContainer instances should not be accessible globally.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      // If there is a parameterElement it means we are not declaring a variable
      if (node.staticParameterElement != null) return;

      // Check that the object created is indeed a ProviderContainer
      final type = node.staticType;
      if (type == null || !providerContainerType.isExactlyType(type)) {
        return;
      }
    });
  }
}
