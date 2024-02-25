import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';
import 'notifier_extends.dart';

class FunctionalRef extends RiverpodLintRule {
  const FunctionalRef() : super(code: _code);

  static const _code = LintCode(
    name: 'functional_ref',
    problemMessage:
        'Functional providers must receive a ref matching the provider name as their first positional parameter.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addFunctionalProviderDeclaration((declaration) {
      final parameters = declaration.node.functionExpression.parameters!;

      final refNode = parameters.parameters.firstOrNull;
      if (refNode == null) {
        // No ref parameter, underlining the function name
        reporter.reportErrorForToken(_code, declaration.name);
        return;
      }

      if (!refNode.isExplicitlyTyped) {
        // No type specified. Underlining the ref name
        reporter.reportErrorForToken(_code, refNode.name!);
        return;
      }

      if (refNode is! SimpleFormalParameter) {
        // Users likely forgot to specify "ref" and the provider has other parameters
        reporter.reportErrorForToken(_code, refNode.name!);
        return;
      }

      final refNodeType = refNode.type;
      if (refNodeType == null) return;

      final expectedRefName = refNameFor(declaration);
      if (refNodeType.beginToken.lexeme != expectedRefName) {
        reporter.reportErrorForNode(_code, refNodeType);
      }

      final expectedTypeArguments =
          declaration.node.functionExpression.typeParameters?.typeParameters ??
              const <TypeParameter>[];

      final currentRefType = refNode.type;
      if (currentRefType is! NamedType) {
        reporter.reportErrorForNode(_code, refNodeType);
        return;
      }
      final actualTypeArguments =
          currentRefType.typeArguments?.arguments ?? const <TypeAnnotation>[];

      if (!areGenericTypeArgumentsMatching(
        expectedTypeArguments,
        actualTypeArguments,
      )) {
        reporter.reportErrorForNode(_code, refNodeType);
        return;
      }
    });
  }

  @override
  List<Fix> getFixes() => [FunctionalRefFix()];
}

class FunctionalRefFix extends RiverpodFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    riverpodRegistry(context).addFunctionalProviderDeclaration((declaration) {
      // This provider is not the one that triggered the error
      if (!analysisError.sourceRange.intersects(declaration.node.sourceRange)) {
        return;
      }

      final expectedGenerics = genericsDisplayStringFor(
        declaration.node.functionExpression.typeParameters,
      );
      final expectedRefType = '${refNameFor(declaration)}$expectedGenerics';

      final refNode = declaration
          .node.functionExpression.parameters!.parameters.firstOrNull;
      if (refNode == null) {
        // No ref parameter, adding one
        final changeBuilder = reporter.createChangeBuilder(
          message: 'Add ref parameter',
          priority: 90,
        );

        changeBuilder.addDartFileEdit((builder) {
          builder.addSimpleInsertion(
            declaration.node.functionExpression.parameters!.leftParenthesis.end,
            '$expectedRefType ref',
          );
        });
        return;
      }

      // No type specified, adding it.
      final changeBuilder = reporter.createChangeBuilder(
        message: 'Type as $expectedRefType',
        priority: 90,
      );

      changeBuilder.addDartFileEdit((builder) {
        if (!refNode.isExplicitlyTyped) {
          builder.addSimpleInsertion(refNode.name!.offset, '$expectedRefType ');
          return;
        }

        refNode as SimpleFormalParameter;
        builder.addSimpleReplacement(
          sourceRangeFrom(
            start: refNode.type!.offset,
            end: refNode.name!.offset,
          ),
          '$expectedRefType ',
        );
      });
    });
  }
}
