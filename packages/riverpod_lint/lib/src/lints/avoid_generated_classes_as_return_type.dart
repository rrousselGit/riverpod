import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

const generatedFileNames = [
  '.freezed.dart',
  '.g.dart',
];

class AvoidGeneratedClassesAsReturnType extends RiverpodLintRule {
  const AvoidGeneratedClassesAsReturnType() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_generated_classes_as_return_type',
    problemMessage:
        "riverpod_generator doesn't support generated classes well yet "
        'and instead emits InvalidType.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addFunctionalProviderDeclaration((declaration) {
      final returnType =
          declaration.node.functionExpression.declaredElement?.returnType;

      final classFileName = returnType?.element?.source?.shortName;
      if (classFileName == null ||
          !generatedFileNames.any(classFileName.endsWith)) return;

      reporter.reportErrorForNode(_code, declaration.node.returnType!);
    });

    riverpodRegistry(context).addClassBasedProviderDeclaration((declaration) {
      final buildMethod = declaration.node.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((e) => e.name.lexeme == 'build');

      final buildMethodReturnType = buildMethod?.returnType?.type;
      if (buildMethodReturnType == null) return;

      final classFileName = buildMethodReturnType.element?.source?.shortName;
      if (classFileName == null ||
          !generatedFileNames.any(classFileName.endsWith)) return;

      reporter.reportErrorForNode(_code, buildMethod!.returnType!);
    });
  }
}
