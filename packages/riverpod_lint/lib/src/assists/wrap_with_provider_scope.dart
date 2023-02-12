import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';
import 'wrap_with_consumer.dart';

class WrapWithProviderScope extends RiverpodAssist {
  WrapWithProviderScope();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      // Select from "new" to the opening bracket
      if (!target.intersects(node.constructorName.sourceRange)) return;

      final createdType = node.constructorName.type.type;
      if (createdType == null ||
          !widgetType.isAssignableFromType(createdType)) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Wrap with ProviderScope',
        priority: wrapPriority - 1,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(
          node.offset,
          'ProviderScope(child: ',
        );
        builder.addSimpleInsertion(node.end, ',)');
      });
    });
  }
}
