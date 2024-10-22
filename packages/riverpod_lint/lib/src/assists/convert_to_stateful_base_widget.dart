import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
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

      final nodesToMove = <ClassMember>{};
      final elementsToMove = <Element>{};
      final visitor = _FieldFinder();
      for (final member in widgetClass.members) {
        if (member is ConstructorDeclaration) {
          member.accept(visitor);
        }
      }
      final fieldsAssignedInConstructors = visitor.fieldsAssignedInConstructors;

      for (final member in widgetClass.members) {
        if (member is FieldDeclaration && !member.isStatic) {
          for (final fieldNode in member.fields.variables) {
            final fieldElement = fieldNode.declaredElement as FieldElement?;
            if (fieldElement == null) continue;
            if (!fieldsAssignedInConstructors.contains(fieldElement)) {
              nodesToMove.add(member);
              elementsToMove.add(fieldElement);

              final getter = fieldElement.getter;
              if (getter != null) {
                elementsToMove.add(getter);
              }

              final setter = fieldElement.setter;
              if (setter != null) {
                elementsToMove.add(setter);
              }
            }
          }
        } else if (member is MethodDeclaration && !member.isStatic) {
          nodesToMove.add(member);
          elementsToMove.add(member.declaredElement!);
        }
      }

      for (final node in nodesToMove) {
        final visitor = _ReplacementEditBuilder(
          widgetClass.declaredElement!,
          elementsToMove,
          builder,
        );
        node.accept(visitor);
      }

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

// Original implemenation in
// package:analysis_server/lib/src/services/correction/dart/flutter_convert_to_stateful_widget.dart
class _FieldFinder extends RecursiveAstVisitor<void> {
  Set<FieldElement> fieldsAssignedInConstructors = {};

  @override
  void visitFieldFormalParameter(FieldFormalParameter node) {
    final element = node.declaredElement;
    if (element is FieldFormalParameterElement) {
      final field = element.field;
      if (field != null) {
        fieldsAssignedInConstructors.add(field);
      }
    }

    super.visitFieldFormalParameter(node);
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (node.parent is ConstructorFieldInitializer) {
      final element = node.staticElement;
      if (element is FieldElement) {
        fieldsAssignedInConstructors.add(element);
      }
    }
    if (node.inSetterContext()) {
      final element = node.writeOrReadElement;
      if (element is PropertyAccessorElement) {
        final field = element.variable2;
        if (field is FieldElement) {
          fieldsAssignedInConstructors.add(field);
        }
      }
    }
  }
}

class _ReplacementEditBuilder extends RecursiveAstVisitor<void> {
  _ReplacementEditBuilder(
    this.widgetClassElement,
    this.elementsToMove,
    this.builder,
  );

  final ClassElement widgetClassElement;
  final Set<Element> elementsToMove;
  final DartFileEditBuilder builder;

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (node.inDeclarationContext()) {
      return;
    }
    final element = node.staticElement;
    if (element is ExecutableElement &&
        element
                // ignore: deprecated_member_use, necessary to support older versions of analyzer
                .enclosingElement ==
            widgetClassElement &&
        !elementsToMove.contains(element)) {
      final offset = node.offset;
      final qualifier =
          element.isStatic ? widgetClassElement.displayName : 'widget';

      final parent = node.parent;
      if (parent is InterpolationExpression &&
          parent.leftBracket.type ==
              TokenType.STRING_INTERPOLATION_IDENTIFIER) {
        builder.addSimpleInsertion(offset, '{$qualifier.');
        builder.addSimpleInsertion(offset + node.length, '}');
      } else {
        builder.addSimpleInsertion(offset, '$qualifier.');
      }
    }
  }
}
