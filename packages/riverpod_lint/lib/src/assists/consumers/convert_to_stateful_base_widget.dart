import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../../imports.dart';
import 'convert_to_widget_utils.dart';

/// Base class for converting to stateful base widgets
abstract class ConvertToStatefulBaseWidget extends ResolvedCorrectionProducer {
  ConvertToStatefulBaseWidget({required super.context});

  StatefulBaseWidgetType get targetWidget;
  late final statelessBaseType = getStatelessBaseType(
    exclude:
        targetWidget == StatefulBaseWidgetType.statefulWidget
            ? StatelessBaseWidgetType.statelessWidget
            : null,
  );
  late final statefulBaseType = getStatefulBaseType(exclude: targetWidget);

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  AssistKind get assistKind => AssistKind(
    'convert_to_${targetWidget.name}',
    targetWidget.priority,
    'Convert to ${targetWidget.widgetAssistName}',
  );

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final visitor = _ExtendsClauseVisitor();
    node.accept(visitor);
    final extendsClause = visitor.extendsClause;
    if (extendsClause == null) return;

    final type = extendsClause.superclass.type;
    if (type == null) return;

    if (statelessBaseType.isExactlyType(type)) {
      await _convertStatelessToStatefulWidget(builder, extendsClause);
      return;
    }

    if (statefulBaseType.isExactlyType(type)) {
      final isExactlyStatefulWidget = StatefulBaseWidgetType
          .statefulWidget
          .typeChecker
          .isExactlyType(type);

      await _convertStatefulToStatefulWidget(
        builder,
        extendsClause,
        // This adjustment assumes that the priority of the standard "Convert to StatelessWidget" is 30.
        priorityAdjustment: isExactlyStatefulWidget ? -4 : 0,
      );
      return;
    }
  }

  Future<void> _convertStatelessToStatefulWidget(
    ChangeBuilder builder,
    ExtendsClause node,
  ) async {
    await builder.addDartFileEdit(file, (builder) {
      // Change the extended base class
      builder.addSimpleReplacement(
        range.node(node.superclass),
        targetWidget.widgetName(builder),
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
            final fieldElement = fieldNode.declaredFragment?.element as FieldElement?;
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
          elementsToMove.add(member.declaredFragment!.element);
        }
      }

      for (final node in nodesToMove) {
        final visitor = _ReplacementEditBuilder(
          widgetClass.declaredFragment!.element,
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
          baseStateName = builder.importConsumerState();
        case StatefulBaseWidgetType.statefulHookWidget:
        case StatefulBaseWidgetType.statefulWidget:
          baseStateName = builder.importState();
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
          range.endStart(
            buildParams.parameters.first,
            buildParams.rightParenthesis,
          ),
        );
      }
    });
  }

  Future<void> _convertStatefulToStatefulWidget(
    ChangeBuilder builder,
    ExtendsClause node, {
    required int priorityAdjustment,
  }) async {
    await builder.addDartFileEdit(file, (builder) {
      // Change the extended base class
      builder.addSimpleReplacement(
        range.node(node.superclass),
        targetWidget.widgetName(builder),
      );

      final widgetClass = node.thisOrAncestorOfType<ClassDeclaration>();
      if (widgetClass == null) return;

      final stateClass = findStateClass(widgetClass);
      if (stateClass == null) return;

      final String baseStateName;
      switch (targetWidget) {
        case StatefulBaseWidgetType.consumerStatefulWidget:
        case StatefulBaseWidgetType.statefulHookConsumerWidget:
          baseStateName = builder.importConsumerState();
        case StatefulBaseWidgetType.statefulHookWidget:
        case StatefulBaseWidgetType.statefulWidget:
          baseStateName = builder.importState();
      }

      final createStateMethod = widgetClass.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((element) => element.name.lexeme == 'createState');
      if (createStateMethod != null) {
        final returnTypeString = createStateMethod.returnType?.toSource() ?? '';
        if (returnTypeString != stateClass.name.lexeme) {
          // Replace State
          builder.addSimpleReplacement(
            range.node(createStateMethod.returnType!),
            '$baseStateName<${widgetClass.name}>',
          );
        }
      }

      final stateExtends = stateClass.extendsClause;
      if (stateExtends != null) {
        // Replace State
        builder.addSimpleReplacement(
          range.node(stateExtends.superclass),
          '$baseStateName<${widgetClass.name}>',
        );
      }
    });
  }
}

class _ExtendsClauseVisitor extends RecursiveAstVisitor<void> {
  ExtendsClause? extendsClause;

  @override
  void visitExtendsClause(ExtendsClause node) {
    extendsClause = node;
  }
}

// Original implementation in
// package:analysis_server/lib/src/services/correction/dart/flutter_convert_to_stateful_widget.dart
class _FieldFinder extends RecursiveAstVisitor<void> {
  Set<FieldElement> fieldsAssignedInConstructors = {};

  @override
  void visitFieldFormalParameter(FieldFormalParameter node) {
    final element = node.declaredFragment?.element;
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
      final element = node.element;
      if (element is FieldElement) {
        fieldsAssignedInConstructors.add(element);
      }
    }
    if (node.inSetterContext()) {
      final element = node.writeOrReadElement;
      if (element is PropertyAccessorElement) {
        final field = element.variable;
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
    final element = node.element;
    if (element is ExecutableElement &&
        element.enclosingElement == widgetClassElement &&
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

// Concrete implementations for each widget type
class ConvertToStatefulHookConsumerWidget extends ConvertToStatefulBaseWidget {
  ConvertToStatefulHookConsumerWidget({required super.context});

  @override
  StatefulBaseWidgetType get targetWidget =>
      StatefulBaseWidgetType.statefulHookConsumerWidget;
}

class ConvertToStatefulHookWidget extends ConvertToStatefulBaseWidget {
  ConvertToStatefulHookWidget({required super.context});

  @override
  StatefulBaseWidgetType get targetWidget =>
      StatefulBaseWidgetType.statefulHookWidget;
}

class ConvertToConsumerStatefulWidget extends ConvertToStatefulBaseWidget {
  ConvertToConsumerStatefulWidget({required super.context});

  @override
  StatefulBaseWidgetType get targetWidget =>
      StatefulBaseWidgetType.consumerStatefulWidget;
}

class ConvertToStatefulWidget extends ConvertToStatefulBaseWidget {
  ConvertToStatefulWidget({required super.context});

  @override
  StatefulBaseWidgetType get targetWidget =>
      StatefulBaseWidgetType.statefulWidget;
}
