import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

class StatelessRef extends RiverpodLintRule {
  const StatelessRef() : super(code: _code);

  static const _code = LintCode(
    name: 'stateless_ref',
    problemMessage:
        'Stateless providers must receive a ref matching the provider name as their first positional parameter.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addStatelessProviderDeclaration((declaration) {
      // Scoped providers don't need a ref
      if (declaration.needsOverride) return;

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

      refNode as SimpleFormalParameter;
      final refNodeType = refNode.type;
      if (refNodeType == null) return;

      final expectedRefName = refNameFor(declaration);
      if (refNodeType.beginToken.lexeme != expectedRefName) {
        reporter.reportErrorForNode(_code, refNodeType);
      }
    });
  }

  @override
  List<Fix> getFixes() => [StatelessRefFix()];
}

class StatelessRefFix extends RiverpodFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    riverpodRegistry(context).addStatelessProviderDeclaration((declaration) {
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
