import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../../riverpod_custom_lint.dart';

/// But the priority above everything else
const convertPriority = 100;

class ClassBasedToFunctionalProvider extends ResolvedCorrectionProducer {
  ClassBasedToFunctionalProvider({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  AssistKind get assistKind => const AssistKind(
    'class_based_to_functional_provider',
    convertPriority,
    'Convert to functional provider',
  );

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final visitor = _Visitor();
    node.accept(visitor);
    final declaration = visitor.classBasedProviderDeclaration;
    if (declaration == null) return;

    // Select from "class" to the opening bracket
    final classHeading = range.startStart(
      declaration.node.classKeyword,
      declaration.node.leftBracket,
    );

    if (!classHeading.intersects(range.node(node))) return;

    await builder.addDartFileEdit(file, (builder) {
      final buildTypeOrNameStartOffset =
          declaration.buildMethod.returnType?.offset ??
          declaration.buildMethod.name.offset;

      // Remove anything between the first character of the build method
      // and the start of the class.
      builder.addDeletion(
        range.startOffsetEndOffset(
          declaration.node.classKeyword.offset,
          buildTypeOrNameStartOffset,
        ),
      );

      // Rename the build method to the class name
      builder.addSimpleReplacement(
        range.token(declaration.buildMethod.name),
        declaration.node.name.lexeme.lowerFirst,
      );

      var typeParametersSource = '';
      final typeParameters = declaration.node.typeParameters;
      if (typeParameters != null) {
        // Obtain the source of type parameters
        typeParametersSource = unit.declaredFragment!.source.contents.data
            .substring(typeParameters.offset, typeParameters.end);

        // Make the function generic if the class was generic
        builder.addSimpleInsertion(
          declaration.buildMethod.name.end,
          typeParametersSource,
        );
      }

      final parameters = declaration.buildMethod.parameters!;
      final trailingRefParameter = parameters.parameters.isEmpty ? '' : ', ';
      // Add ref parameter to the build method
      builder.addSimpleInsertion(
        parameters.leftParenthesis.end,
        '${refNameFor(declaration)} ref$trailingRefParameter',
      );

      // Remove anything after the build method
      builder.addDeletion(
        range.endEnd(declaration.buildMethod, declaration.node),
      );
    });
  }
}

class _Visitor extends SimpleRiverpodAstVisitor {
  ClassBasedProviderDeclaration? classBasedProviderDeclaration;

  @override
  void visitClassBasedProviderDeclaration(
    ClassBasedProviderDeclaration declaration,
  ) {
    classBasedProviderDeclaration = declaration;
  }
}
