import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../../riverpod_custom_lint.dart';
import 'class_based_to_functional_provider.dart';

class FunctionalToClassBasedProvider extends ResolvedCorrectionProducer {
  FunctionalToClassBasedProvider({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  AssistKind get assistKind => const AssistKind(
    'riverpod.functional_to_class_based_provider',
    convertPriority,
    'Convert to class-based provider',
  );

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final visitor = _Visitor();
    node.accept(visitor);
    final declaration = visitor.functionalProviderDeclaration;
    if (declaration == null) return;

    // The first character of the function
    final functionStartOffset =
        declaration.node.returnType?.offset ?? declaration.node.name.offset;
    final parameters = declaration.node.functionExpression.parameters!;

    // The function prototype, from the first character to the opening parenthesis
    final functionHeading = sourceRangeFrom(
      start: functionStartOffset,
      end: parameters.leftParenthesis.end,
    );
    if (!functionHeading.intersects(range.node(node))) return;

    await builder.addDartFileEdit(file, (builder) {
      var typeParametersSource = '';
      final typeParameters = declaration.node.functionExpression.typeParameters;
      if (typeParameters != null) {
        // Remove type arguments, if any
        builder.addDeletion(
          sourceRangeFrom(
            start: typeParameters.offset,
            end: typeParameters.end,
          ),
        );

        typeParametersSource = unit.declaredFragment!.source.contents.data
            .substring(typeParameters.offset, typeParameters.end);
      }

      // Add the class name
      builder.addSimpleInsertion(functionStartOffset, '''
class ${classNameFor(declaration)}$typeParametersSource extends ${generatedClassNameFor(declaration)}$typeParametersSource {
  @override
  ''');

      // Rename the function name to build
      builder.addSimpleReplacement(range.token(declaration.node.name), 'build');

      if (parameters.parameters.isNotEmpty) {
        int refEnd;
        if (parameters.parameters.length > 1) {
          // There is a second parameter, so we need to remove the comma
          final secondParameter = parameters.parameters[1];
          if (secondParameter.isNamed || secondParameter.isOptionalPositional) {
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
          sourceRangeFrom(start: parameters.leftParenthesis.end, end: refEnd),
        );
      }

      builder.addSimpleInsertion(declaration.node.end, '\n}');
    });
  }
}

class _Visitor extends SimpleRiverpodAstVisitor {
  FunctionalProviderDeclaration? functionalProviderDeclaration;

  @override
  void visitFunctionalProviderDeclaration(
    FunctionalProviderDeclaration declaration,
  ) {
    functionalProviderDeclaration = declaration;
  }
}
