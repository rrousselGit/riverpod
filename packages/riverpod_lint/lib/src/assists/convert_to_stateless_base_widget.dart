import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
// ignore: implementation_imports, somehow not exported by analyzer
import 'package:analyzer/src/generated/source.dart' show Source;
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';
import 'convert_to_widget_utils.dart';

class ConvertToStatelessBaseWidget extends RiverpodAssist {
  ConvertToStatelessBaseWidget({
    required this.targetWidget,
  });
  final StatelessBaseWidgetType targetWidget;
  late final statelessBaseType = getStatelessBaseType(
    exclude: targetWidget,
  );
  late final statefulBaseType = getStatefulBaseType(
    exclude: targetWidget == StatelessBaseWidgetType.statelessWidget
        ? StatefulBaseWidgetType.statefulWidget
        : null,
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
        _convertStatelessToStatelessWidget(
          reporter,
          node,
        );
        return;
      }

      if (statefulBaseType.isExactlyType(type)) {
        final isExactlyStatefulWidget = StatefulBaseWidgetType
            .statefulWidget.typeChecker
            .isExactlyType(type);

        _convertStatefulToStatelessWidget(
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

  void _convertStatelessToStatelessWidget(
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

      final buildMethod = node
          .thisOrAncestorOfType<ClassDeclaration>()
          ?.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((element) => element.name.lexeme == 'build');

      if (buildMethod == null) return;
      final buildParams = buildMethod.parameters;

      if (buildParams == null) return;

      switch (targetWidget) {
        case StatelessBaseWidgetType.consumerWidget:
        case StatelessBaseWidgetType.hookConsumerWidget:
          // If the build method has not a ref, add it
          if (buildParams.parameters.length == 1) {
            builder.addSimpleInsertion(
              buildParams.parameters.last.end,
              ', WidgetRef ref',
            );
          }
          break;
        case StatelessBaseWidgetType.hookWidget:
        case StatelessBaseWidgetType.statelessWidget:
          // If the build method has a ref, remove it
          if (buildParams.parameters.length == 2) {
            builder.addDeletion(
              sourceRangeFrom(
                start: buildParams.parameters.first.end,
                end: buildParams.rightParenthesis.offset,
              ),
            );
          }
          break;
      }
    });
  }

  void _convertStatefulToStatelessWidget(
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

      // Remove createState method
      final createStateMethod = widgetClass.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((element) => element.name.lexeme == 'createState');
      if (createStateMethod != null) {
        builder.addDeletion(createStateMethod.sourceRange);
      }

      // Search for the associated State class
      final stateClass = findStateClass(widgetClass);
      if (stateClass == null) return;

      // Move the build method to the widget class
      final buildMethod = stateClass.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((element) => element.name.lexeme == 'build');
      if (buildMethod == null) return;

      final String? newBuildMethod;
      switch (targetWidget) {
        case StatelessBaseWidgetType.consumerWidget:
        case StatelessBaseWidgetType.hookConsumerWidget:
          newBuildMethod = _buildMethodWithRef(buildMethod, source);
          break;
        case StatelessBaseWidgetType.hookWidget:
        case StatelessBaseWidgetType.statelessWidget:
          newBuildMethod = _buildMethodWithoutRef(buildMethod, source);
          break;
      }

      if (newBuildMethod == null) return;
      builder.addSimpleInsertion(
        widgetClass.rightBracket.offset,
        newBuildMethod,
      );

      // Delete the state class
      builder.addDeletion(stateClass.sourceRange);
    });
  }

  String? _buildMethodWithRef(MethodDeclaration buildMethod, Source source) {
    final parameters = buildMethod.parameters;
    if (parameters == null) return null;

    if (parameters.parameters.length == 2) {
      // The build method already has a ref parameter, nothing to change
      return '${source.contents.data.substring(buildMethod.offset, buildMethod.end)}\n';
    }

    final buffer = StringBuffer();
    final refParamStartOffset = parameters.parameters.firstOrNull?.end ??
        parameters.leftParenthesis.offset + 1;

    buffer
      ..write(
        source.contents.data.substring(buildMethod.offset, refParamStartOffset),
      )
      ..write(', WidgetRef ref')
      ..writeln(
        source.contents.data.substring(refParamStartOffset, buildMethod.end),
      );

    return buffer.toString();
  }

  String? _buildMethodWithoutRef(MethodDeclaration buildMethod, Source source) {
    final parameters = buildMethod.parameters;
    if (parameters == null) return null;

    if (parameters.parameters.length == 1) {
      // The build method already has not a ref parameter, nothing to change
      return '${source.contents.data.substring(buildMethod.offset, buildMethod.end)}\n';
    }

    final buffer = StringBuffer();
    final contextEndOffset = parameters.parameters.firstOrNull?.end ??
        parameters.leftParenthesis.offset + 1;
    final refParamStartOffset = parameters.parameters.last.offset;

    buffer
      ..write(
        source.contents.data.substring(buildMethod.offset, contextEndOffset),
      )
      ..writeln(
        source.contents.data.substring(refParamStartOffset, buildMethod.end),
      );

    return buffer.toString();
  }
}
