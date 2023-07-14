import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

/// But the priority above everything else
const convertPriority = 100;

class ClassBasedToFunctionalProvider extends RiverpodAssist {
  ClassBasedToFunctionalProvider();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    riverpodRegistry(context).addClassBasedProviderDeclaration((declaration) {
      // Select from "class" to the opening bracket
      final classHeading = sourceRangeFrom(
        start: declaration.node.classKeyword.offset,
        end: declaration.node.leftBracket.offset,
      );

      if (!classHeading.intersects(target)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Convert to functional provider',
        priority: convertPriority,
      );

      changeBuilder.addDartFileEdit((builder) {
        final buildTypeOrNameStartOffset =
            declaration.buildMethod.returnType?.offset ??
                declaration.buildMethod.name.offset;

        // Remove anything between the first character of the build method
        // and the start of the class.
        builder.addDeletion(
          sourceRangeFrom(
            start: declaration.node.classKeyword.offset,
            end: buildTypeOrNameStartOffset,
          ),
        );

        // Rename the build method to the class name
        builder.addSimpleReplacement(
          declaration.buildMethod.name.sourceRange,
          declaration.node.name.lexeme.lowerFirst,
        );

        final parameters = declaration.buildMethod.parameters!;
        final trailingRefParameter = parameters.parameters.isEmpty ? '' : ', ';
        // Add ref parameter to the build method
        builder.addSimpleInsertion(
          parameters.leftParenthesis.end,
          '${refNameFor(declaration)} ref$trailingRefParameter',
        );

        // Remove anything after the build method
        builder.addDeletion(
          sourceRangeFrom(
            start: declaration.buildMethod.end,
            end: declaration.node.end,
          ),
        );
      });
    });
  }
}
