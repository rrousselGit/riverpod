import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../object_utils.dart';
import '../riverpod_custom_lint.dart';

/// But the priority above everything else
const convertPriority = 100;

const _statelessBaseType = TypeChecker.any([
  TypeChecker.fromName('StatelessWidget', packageName: 'flutter'),
  TypeChecker.fromName('HookConsumerWidget', packageName: 'hooks_riverpod'),
  TypeChecker.fromName('HookWidget', packageName: 'flutter_hooks'),
]);

const _statefulBaseType = TypeChecker.any([
  TypeChecker.fromName('StatefulWidget', packageName: 'flutter'),
  TypeChecker.fromName(
    'ConsumerStatefulWidget',
    packageName: 'flutter_riverpod',
  ),
  TypeChecker.fromName(
    'StatefulHookConsumerWidget',
    packageName: 'hooks_riverpod',
  ),
  TypeChecker.fromName('StatefulHookWidget', packageName: 'flutter_hooks'),
]);

const _stateType = TypeChecker.fromName('State', packageName: 'flutter');

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
        _convertStatelessToConsumerWidget(reporter, node);
        return;
      }

      if (_statefulBaseType.isExactlyType(type)) {
        _convertStatefulToConsumerWidget(reporter, node, resolver.source);
        return;
      }
    });
  }

  void _convertStatefulToConsumerWidget(
    ChangeReporter reporter,
    ExtendsClause node,
    Source source,
  ) {
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

      final newBuildMethod = _buildMethodWithRef(buildMethod, source);
      if (newBuildMethod == null) return;
      builder.addSimpleInsertion(
        widgetClass.rightBracket.offset,
        newBuildMethod,
      );

      // Delete the state class
      builder.addDeletion(stateClass.sourceRange);
    });
  }

  String? _buildMethodWithRef(
    MethodDeclaration buildMethod,
    Source source,
  ) {
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

  void _convertStatelessToConsumerWidget(
    ChangeReporter reporter,
    ExtendsClause node,
  ) {
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
}
