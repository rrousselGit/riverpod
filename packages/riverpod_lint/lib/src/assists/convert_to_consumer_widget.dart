import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';

/// But the priority above everything else
const convertPriority = 100;

const _statelessBaseType = TypeChecker.any([
  TypeChecker.fromName('StatelessWidget', packageName: 'flutter'),
  TypeChecker.fromName('HookConsumerWidget', packageName: 'hooks_riverpod'),
  TypeChecker.fromName('HookWidget', packageName: 'flutter_hooks'),
]);

class ConvertToConsumerWidget extends RiverpodAssist {
  ConvertToConsumerWidget();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    context.registry.addExtendsClause((node) {
      // Only offer the assist if hovering the extended type
      if (!node.superclass.sourceRange.intersects(target)) return;

      final type = node.superclass.type;
      if (type == null) return;

      if (_statelessBaseType.isExactlyType(type)) {
        final changeBuilder = reporter.createChangeBuilder(
          message: 'Convert to ConsumerWidget',
          priority: convertPriority,
        );

        changeBuilder.addDartFileEdit((builder) {
          // Change the extended base class
          builder.addSimpleReplacement(
            node.superclass.sourceRange,
            'ConsumerWidget',
          );

          // Now update "build" to take a "ref" parameter
          final buildMethod = node
              .thisOrAncestorOfType<ClassDeclaration>()
              ?.members
              .whereType<MethodDeclaration>()
              .firstWhereOrNull((element) => element.name.lexeme == 'build');

          if (buildMethod == null) return;
          final buildParams = buildMethod.parameters;
          // If there is more than one parameter, the build method already has the "ref"
          if (buildParams == null || buildParams.parameters.length != 1) return;

          builder.addSimpleInsertion(
            buildParams.parameters.last.end,
            ', WidgetRef ref',
          );
        });
      }
    });
  }
}
