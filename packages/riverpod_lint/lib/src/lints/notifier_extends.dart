import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

String _generatedClassName(ProviderDeclaration declaration) {
  return '_\$${declaration.name.lexeme.public}';
}

/// Check that a generic type definition matches with a generic type usage.
///
/// This is a strict check based on names, such that `<A extends num, B>` will
/// match with `<A, B>` but not `<B, A>` or `<int, B>` or cases with extra/fewer
/// type arguments.
bool areGenericTypeArgumentsMatching(
  List<TypeParameter> expectedTypeArguments,
  List<TypeAnnotation> actualTypeArguments,
) {
  // Are type arguments specified in the correct order?
  var i = 0;
  for (;
      i < expectedTypeArguments.length && i < actualTypeArguments.length;
      i++) {
    final expectedType = expectedTypeArguments[i].name.lexeme;
    final actualType = actualTypeArguments[i].toSource();

    if (expectedType != actualType) {
      return false;
    }
  }

  // Is a type argument missing?
  if (i != expectedTypeArguments.length || i != actualTypeArguments.length) {
    return false;
  }

  return true;
}

/// Convert a [TypeParameterList] to a string.
String genericsDisplayStringFor(TypeParameterList? typeParameters) {
  if (typeParameters == null) return '';

  return '<${typeParameters.typeParameters.map((e) => e.name).join(', ')}>';
}

class NotifierExtends extends RiverpodLintRule {
  const NotifierExtends() : super(code: _code);

  static const _code = LintCode(
    name: 'notifier_extends',
    problemMessage: r'Classes annotated by @riverpod must extend _$ClassName',
    // TODO changelog: notifier_extends is now a WARNING.
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addClassBasedProviderDeclaration((declaration) {
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

      final expectedTypeArguments =
          declaration.node.typeParameters?.typeParameters ??
              const <TypeParameter>[];
      final actualTypeArguments =
          extendsClause.superclass.typeArguments?.arguments ??
              const <TypeAnnotation>[];
      if (!areGenericTypeArgumentsMatching(
        expectedTypeArguments,
        actualTypeArguments,
      )) {
        // No type specified. Underlining the ref name
        reporter.reportErrorForNode(_code, extendsClause.superclass);
        return;
      }
    });
  }

  @override
  List<Fix> getFixes() => [NotifierExtendsFix()];
}

class NotifierExtendsFix extends RiverpodFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    riverpodRegistry(context).addClassBasedProviderDeclaration((declaration) {
      // This provider is not the one that triggered the error
      if (!analysisError.sourceRange.intersects(declaration.node.sourceRange)) {
        return;
      }

      final expectedGenerics = genericsDisplayStringFor(
        declaration.node.typeParameters,
      );
      final expectedClassName = _generatedClassName(declaration);
      final expectedExtends = '$expectedClassName$expectedGenerics';

      final extendsClause = declaration.node.extendsClause;
      final changeBuilder = reporter.createChangeBuilder(
        message: 'Extend $expectedExtends',
        priority: 90,
      );

      changeBuilder.addDartFileEdit((builder) {
        if (extendsClause == null) {
          // No "extends" clause
          builder.addSimpleInsertion(
            declaration.name.end,
            ' extends $expectedExtends',
          );
          return;
        }

        // There is an "extends" clause but the extended type is wrong
        builder.addSimpleReplacement(
          extendsClause.superclass.sourceRange,
          expectedExtends,
        );
      });
    });
  }
}
