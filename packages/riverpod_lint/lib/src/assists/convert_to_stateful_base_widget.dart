import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
// ignore: implementation_imports, somehow not exported by analyzer
import 'package:analyzer/src/generated/source.dart' show Source;
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';
import 'convert_to_widget_utils.dart';

class ConvertToStatefulBaseWidget extends RiverpodAssist {
  ConvertToStatefulBaseWidget({
    required this.targetWidget,
  });
  final StatefulBaseWidgetType targetWidget;
  late final statelessBaseType = getStatelessBaseType(
    exclude: targetWidget == StatefulBaseWidgetType.statefulWidget
        ? StatelessBaseWidgetType.statelessWidget
        : null,
  );
  late final statefulBaseType = getStatefulBaseType(
    exclude: targetWidget,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    if (targetWidget.requiredPackage != null &&
        !context.pubspec.dependencies.keys
            .contains(targetWidget.requiredPackage)) {
      return;
    }

    context.registry.addExtendsClause((node) {
      // Only offer the assist if hovering the extended type
      if (!node.superclass.sourceRange.intersects(target)) return;

      final type = node.superclass.type;
      if (type == null) return;

      if (statelessBaseType.isExactlyType(type)) {
        _convertStatelessToStatefulWidget(reporter, node);
        return;
      }

      if (statefulBaseType.isExactlyType(type)) {
        final isExactlyStatefulWidget = StatefulBaseWidgetType
            .statefulWidget.typeChecker
            .isExactlyType(type);

        _convertStatefulToStatefulWidget(
          reporter,
          node,
          resolver.source,
          // This adjustment assumes that the priority of the standard "Convert to StatelessWidget" is 30.
          priorityAdjustment: isExactlyStatefulWidget ? -4 : 0,
        );
        return;
      }
    });
  }

  void _convertStatelessToStatefulWidget(
    ChangeReporter reporter,
    ExtendsClause node,
  ) {
    final changeBuilder = reporter.createChangeBuilder(
      message: 'Convert to ${targetWidget.widgetName}',
      priority: targetWidget.priority,
    );

    changeBuilder.addDartFileEdit((builder) {
      // Change the extended base class
      builder.addSimpleReplacement(
        node.superclass.sourceRange,
        targetWidget.widgetName,
      );

      final widgetClass = node.thisOrAncestorOfType<ClassDeclaration>();
      if (widgetClass == null) return;

      final buildMethod = node
          .thisOrAncestorOfType<ClassDeclaration>()
          ?.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((element) => element.name.lexeme == 'build');
      if (buildMethod == null) return;

      final createdStateClassName = '_${widgetClass.name.lexeme.public}State';
      final String baseStateName;
      switch (targetWidget) {
        case StatefulBaseWidgetType.consumerStatefulWidget:
        case StatefulBaseWidgetType.statefulHookConsumerWidget:
          baseStateName = 'ConsumerState';
          break;
        case StatefulBaseWidgetType.statefulHookWidget:
        case StatefulBaseWidgetType.statefulWidget:
          baseStateName = 'State';
          break;
      }

      // Split the class into two classes right before the build method
      builder.addSimpleInsertion(buildMethod.offset, '''
@override
  $baseStateName<${widgetClass.name.lexeme}> createState() => $createdStateClassName();
}

class $createdStateClassName extends $baseStateName<${widgetClass.name}> {
''');

      final buildParams = buildMethod.parameters;
      // If the build method has a ref, remove it
      if (buildParams != null && buildParams.parameters.length == 2) {
        builder.addDeletion(
          sourceRangeFrom(
            start: buildParams.parameters.first.end,
            end: buildParams.rightParenthesis.offset,
          ),
        );
      }
    });
  }

  void _convertStatefulToStatefulWidget(
    ChangeReporter reporter,
    ExtendsClause node,
    Source source, {
    required int priorityAdjustment,
  }) {
    final changeBuilder = reporter.createChangeBuilder(
      message: 'Convert to ${targetWidget.widgetName}',
      priority: targetWidget.priority + priorityAdjustment,
    );

    changeBuilder.addDartFileEdit((builder) {
      // Change the extended base class
      builder.addSimpleReplacement(
        node.superclass.sourceRange,
        targetWidget.widgetName,
      );

      final widgetClass = node.thisOrAncestorOfType<ClassDeclaration>();
      if (widgetClass == null) return;

      final stateClass = findStateClass(widgetClass);
      if (stateClass == null) return;

      final String baseStateName;
      switch (targetWidget) {
        case StatefulBaseWidgetType.consumerStatefulWidget:
        case StatefulBaseWidgetType.statefulHookConsumerWidget:
          baseStateName = 'ConsumerState';
          break;
        case StatefulBaseWidgetType.statefulHookWidget:
        case StatefulBaseWidgetType.statefulWidget:
          baseStateName = 'State';
          break;
      }

      final createStateMethod = widgetClass.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((element) => element.name.lexeme == 'createState');
      if (createStateMethod != null) {
        final returnTypeString = createStateMethod.returnType?.toSource() ?? '';
        if (returnTypeString != stateClass.name.lexeme) {
          // Replace State
          builder.addSimpleReplacement(
            createStateMethod.returnType!.sourceRange,
            '$baseStateName<${widgetClass.name}>',
          );
        }
      }

      final stateExtends = stateClass.extendsClause;
      if (stateExtends != null) {
        // Replace State
        builder.addSimpleReplacement(
          stateExtends.superclass.sourceRange,
          '$baseStateName<${widgetClass.name}>',
        );
      }
    });
  }
}
