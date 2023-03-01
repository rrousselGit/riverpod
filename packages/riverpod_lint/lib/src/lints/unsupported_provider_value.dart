import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class UnsupportedProviderValue extends RiverpodLintRule {
  const UnsupportedProviderValue() : super(code: _code);

  static const _code = LintCode(
    name: 'unsupported_provider_value',
    problemMessage:
        'The riverpod_generator package does not support {0} values.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    void checkCreatedType(GeneratorProviderDeclaration declaration) {
      String? invalidValueName;
      if (stateNotifierType.isAssignableFromType(declaration.valueType)) {
        invalidValueName = 'StateNotifier';
      } else if (changeNotifierType
          .isAssignableFromType(declaration.valueType)) {
        invalidValueName = 'ChangeNotifier';
      } else if (notifierBaseType.isAssignableFromType(declaration.valueType)) {
        invalidValueName = 'Notifier';
      } else if (asyncNotifierBaseType
          .isAssignableFromType(declaration.valueType)) {
        invalidValueName = 'AsyncNotifier';
      }

      if (invalidValueName != null) {
        reporter.reportErrorForToken(
          _code,
          declaration.name,
          [invalidValueName],
        );
      }
    }

    riverpodRegistry(context)
      ..addStatelessProviderDeclaration(checkCreatedType)
      ..addStatefulProviderDeclaration(checkCreatedType);
  }
}
