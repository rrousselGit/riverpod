import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

class FunctionalRef extends RiverpodLintRule {
  const FunctionalRef() : super(code: _code);

  static const _code = LintCode(
    name: 'functional_ref',
    problemMessage:
        'Functional providers must receive a ref matching the provider name as their first positional parameter.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addFunctionalProviderDeclaration((declaration) {
      // Scoped providers don't need a ref
      if (declaration.needsOverride) return;

      final parameters = declaration.node.functionExpression.parameters!;

      final refNode = parameters.parameters.firstOrNull;
      if (refNode == null) {
        // No ref parameter, underlining the function name
        reporter.atToken(declaration.name, _code);
        return;
      }

      if (!refNode.isExplicitlyTyped) {
        // No type specified. Underlining the ref name
        reporter.atToken(refNode.name!, _code);
        return;
      }

      if (refNode is! SimpleFormalParameter) {
        // Users likely forgot to specify "ref" and the provider has other parameters
        reporter.atToken(refNode.name!, _code);
        return;
      }

      final refNodeType = refNode.type;
      if (refNodeType == null) return;

      final expectedRefName = refNameFor(declaration);
      if (refNodeType.beginToken.lexeme != expectedRefName) {
        reporter.atNode(refNodeType, _code);
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

      final expectedRefType = refNameFor(declaration);
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
