import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
// ignore: implementation_imports, somehow not exported by analyzer
import 'package:analyzer/src/generated/source.dart' show Source;
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../object_utils.dart';
import '../riverpod_custom_lint.dart';
import 'convert_to_widget_utils.dart';

const _convertTarget = ConvertToWidget.statelessWidget;

final _statelessBaseType = getStatelessBaseType(excludes: [_convertTarget]);
final _statefulBaseType = getStatefulBaseType(
  excludes: [_convertTarget, ConvertToWidget.statefulWidget],
);

const _stateType = TypeChecker.fromName('State', packageName: 'flutter');

class ConvertToStatelessWidget extends RiverpodAssist {
  ConvertToStatelessWidget();

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
        _convertStatelessToStatelessWidget(reporter, node);
        return;
      }

      if (_statefulBaseType.isExactlyType(type)) {
        _convertStatefulToStatelessWidget(reporter, node, resolver.source);
        return;
      }
    });
  }

  void _convertStatelessToStatelessWidget(
    ChangeReporter reporter,
    ExtendsClause node,
  ) {
    final changeBuilder = reporter.createChangeBuilder(
      message: 'Convert to ${_convertTarget.widgetName}',
      priority: _convertTarget.priority,
    );

    changeBuilder.addDartFileEdit((builder) {
      // Change the extended base class
      builder.addSimpleReplacement(
        node.superclass.sourceRange,
        _convertTarget.widgetName,
      );

      final buildMethod = node
          .thisOrAncestorOfType<ClassDeclaration>()
          ?.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((element) => element.name.lexeme == 'build');

      if (buildMethod == null) return;
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

  void _convertStatefulToStatelessWidget(
    ChangeReporter reporter,
    ExtendsClause node,
    Source source,
  ) {
    final changeBuilder = reporter.createChangeBuilder(
      message: 'Convert to ${_convertTarget.widgetName}',
      priority: _convertTarget.priority,
    );

    changeBuilder.addDartFileEdit((builder) {
      // Change the extended base class
      builder.addSimpleReplacement(
        node.superclass.sourceRange,
        _convertTarget.widgetName,
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
      final stateClass = _findStateClass(widgetClass);
      if (stateClass == null) return;

      // Move the build method to the widget class
      final buildMethod = stateClass.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((element) => element.name.lexeme == 'build');
      if (buildMethod == null) return;

      final newBuildMethod = _buildMethodWithoutRef(buildMethod, source);
      if (newBuildMethod == null) return;
      builder.addSimpleInsertion(
        widgetClass.rightBracket.offset,
        newBuildMethod,
      );

      // Delete the state class
      builder.addDeletion(stateClass.sourceRange);
    });
  }

  // TODO: standardization
  ClassDeclaration? _findStateClass(ClassDeclaration widgetClass) {
    final widgetType = widgetClass.declaredElement?.thisType;
    if (widgetType == null) return null;

    return widgetClass
        .thisOrAncestorOfType<CompilationUnit>()
        ?.declarations
        .whereType<ClassDeclaration>()
        .where(
          // Is the class a state class?
          (e) =>
              e.extendsClause?.superclass.type
                  .let(_stateType.isAssignableFromType) ??
              false,
        )
        .firstWhereOrNull((e) {
      final stateWidgetType = e
          .extendsClause?.superclass.typeArguments?.arguments.firstOrNull?.type;
      if (stateWidgetType == null) return false;

      final checker = TypeChecker.fromStatic(widgetType);
      return checker.isExactlyType(stateWidgetType);
    });
  }

  // TODO: standardization
  String? _buildMethodWithoutRef(
    MethodDeclaration buildMethod,
    Source source,
  ) {
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
