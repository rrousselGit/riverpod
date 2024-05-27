import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

extension on ClassBasedProviderDeclaration {
  /// Returns whether the value exposed by the provider is the newly created
  /// Notifier itself.
  bool get returnsSelf {
    return valueTypeNode?.type == node.declaredElement?.thisType;
  }
}

class UnsupportedProviderValue extends RiverpodLintRule {
  const UnsupportedProviderValue() : super(code: _code);

  static const _code = LintCode(
    name: 'unsupported_provider_value',
    problemMessage:
        'The riverpod_generator package does not support {0} values.',
    correctionMessage:
        'If using {0} even though riverpod_generator does not support it, '
        'you can wrap the type in "Raw" to silence the warning. For example by returning Raw<{0}>.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    void checkCreatedType(GeneratorProviderDeclaration declaration) {
      final valueType = declaration.valueTypeNode?.type;
      if (valueType == null || valueType.isRaw) return;

      String? invalidValueName;
      if (notifierBaseType.isAssignableFromType(valueType)) {
        invalidValueName = 'Notifier';
      } else if (asyncNotifierBaseType.isAssignableFromType(valueType)) {
        invalidValueName = 'AsyncNotifier';
      }

      /// If a provider returns itself, we allow it. This is to enable
      /// ChangeNotifier-like mutable state.
      if (invalidValueName != null &&
          declaration is ClassBasedProviderDeclaration &&
          declaration.returnsSelf) {
        return;
      }

      if (stateNotifierType.isAssignableFromType(valueType)) {
        invalidValueName = 'StateNotifier';
      } else if (changeNotifierType.isAssignableFromType(valueType)) {
        invalidValueName = 'ChangeNotifier';
      }

      if (invalidValueName != null) {
        reporter.atToken(
          declaration.name,
          _code,
          arguments: [invalidValueName],
        );
      }
    }

    riverpodRegistry(context)
      ..addFunctionalProviderDeclaration(checkCreatedType)
      ..addClassBasedProviderDeclaration(checkCreatedType);
  }
}
