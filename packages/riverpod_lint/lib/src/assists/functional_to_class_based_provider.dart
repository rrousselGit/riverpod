import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';
import 'class_based_to_functional_provider.dart';

class FunctionalToClassBasedProvider extends RiverpodAssist {
  FunctionalToClassBasedProvider();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    riverpodRegistry(context).addFunctionalProviderDeclaration((declaration) {
      // The first character of the function
      final functionStartOffset =
          declaration.node.returnType?.offset ?? declaration.node.name.offset;
      final parameters = declaration.node.functionExpression.parameters!;

      // The function prototype, from the first character to the opening parenthesis
      final functionHeading = sourceRangeFrom(
        start: functionStartOffset,
        end: parameters.leftParenthesis.end,
      );
      if (!functionHeading.intersects(target)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Convert to class-based provider',
        priority: convertPriority,
      );

      changeBuilder.addDartFileEdit((builder) {
        // Add the class name
        builder.addSimpleInsertion(
          functionStartOffset,
          '''
class ${classNameFor(declaration)} extends ${generatedClassNameFor(declaration)} {
  @override
  ''',
        );

        // Rename the function name to build
        builder.addSimpleReplacement(
          declaration.node.name.sourceRange,
          'build',
        );

        if (parameters.parameters.isNotEmpty) {
          int refEnd;
          if (parameters.parameters.length > 1) {
            // There is a second parameter, so we need to remove the comma
            final secondParameter = parameters.parameters[1];
            if (secondParameter.isNamed ||
                secondParameter.isOptionalPositional) {
              // The second parameter introduces either {} or [], so the comma
              // is placed before those.
              refEnd = parameters.leftDelimiter!.offset;
            } else {
              refEnd = secondParameter.offset;
            }
          } else {
            // The function has only the ref as parameter, so there's no comma
            refEnd = parameters.rightParenthesis.offset;
          }

          // Remove the ref parameter
          builder.addDeletion(
            sourceRangeFrom(
              start: parameters.leftParenthesis.end,
              end: refEnd,
            ),
          );
        }

        builder.addSimpleInsertion(declaration.node.end, '\n}');
      });
    });
  }
}
