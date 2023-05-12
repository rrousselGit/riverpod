import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

String _generatedClassName(ProviderDeclaration declaration) {
  return '_\$${declaration.name.lexeme.public}';
}

class GeneratorClassExtends extends RiverpodLintRule {
  const GeneratorClassExtends() : super(code: _code);

  static const _code = LintCode(
    name: 'generator_class_extends',
    problemMessage: r'Classes annotated by @riverpod must extend _$ClassName',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addStatefulProviderDeclaration((declaration) {
      final extendsClause = declaration.node.extendsClause;

      if (extendsClause == null) {
        // No ref parameter, underlining the function name
        reporter.reportErrorForToken(_code, declaration.name);
        return;
      }

      final expectedClassName = _generatedClassName(declaration);
      if (extendsClause.superclass.name2.lexeme != expectedClassName) {
        // No type specified. Underlining the ref name
        reporter.reportErrorForNode(_code, extendsClause.superclass);
        return;
      }
    });
  }

  @override
  List<Fix> getFixes() => [GeneratorClassExtendsFix()];
}

class GeneratorClassExtendsFix extends RiverpodFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    riverpodRegistry(context).addStatefulProviderDeclaration((declaration) {
      // This provider is not the one that triggered the error
      if (!analysisError.sourceRange.intersects(declaration.node.sourceRange)) {
        return;
      }

      final expectedClassName = _generatedClassName(declaration);
      final extendsClause = declaration.node.extendsClause;
      final changeBuilder = reporter.createChangeBuilder(
        message: 'Extend $expectedClassName',
        priority: 90,
      );

      changeBuilder.addDartFileEdit((builder) {
        if (extendsClause == null) {
          // No "extends" clause
          builder.addSimpleInsertion(
            declaration.name.end,
            ' extends $expectedClassName',
          );
          return;
        }

        // There is an "extends" clause but the extended type is wrong
        builder.addSimpleReplacement(
          extendsClause.superclass.sourceRange,
          expectedClassName,
        );
      });
    });
  }
}
