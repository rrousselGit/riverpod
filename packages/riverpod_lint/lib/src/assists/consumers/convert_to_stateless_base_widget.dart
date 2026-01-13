import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:collection/collection.dart';

import '../../imports.dart';
import 'convert_to_widget_utils.dart';

/// Base class for converting to stateless base widgets
abstract class ConvertToStatelessBaseWidget extends ResolvedCorrectionProducer {
  ConvertToStatelessBaseWidget({required super.context});

  StatelessBaseWidgetType get targetWidget;
  late final statelessBaseType = getStatelessBaseType(exclude: targetWidget);
  late final statefulBaseType = getStatefulBaseType(
    exclude:
        targetWidget == StatelessBaseWidgetType.statelessWidget
            ? StatefulBaseWidgetType.statefulWidget
            : null,
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  AssistKind get assistKind => AssistKind(
    'convert_to_${targetWidget.name}',
    targetWidget.priority,
    'Convert to ${targetWidget.assistName}',
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
      await _convertStatelessToStatelessWidget(builder, extendsClause);
      return;
    }

    if (statefulBaseType.isExactlyType(type)) {
      final isExactlyStatefulWidget = StatefulBaseWidgetType
          .statefulWidget
          .typeChecker
          .isExactlyType(type);

      await _convertStatefulToStatelessWidget(
        builder,
        extendsClause,
        // This adjustment assumes that the priority of the standard "Convert to StatelessWidget" is 30.
        priorityAdjustment: isExactlyStatefulWidget ? -4 : 0,
      );
      return;
    }
  }

  Future<void> _convertStatelessToStatelessWidget(
    ChangeBuilder builder,
    ExtendsClause node,
  ) async {
    await builder.addDartFileEdit(file, (builder) {
      // Change the extended base class
      builder.addSimpleReplacement(
        range.node(node.superclass),
        targetWidget.widgetName(builder),
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
          final widgetRef = builder.importWidgetRef();

          // If the build method has not a ref, add it
          if (buildParams.parameters.length == 1) {
            builder.addSimpleInsertion(
              buildParams.parameters.last.end,
              ', $widgetRef ref',
            );
          }
        case StatelessBaseWidgetType.hookWidget:
        case StatelessBaseWidgetType.statelessWidget:
          // If the build method has a ref, remove it
          if (buildParams.parameters.length == 2) {
            builder.addDeletion(
              range.endStart(
                buildParams.parameters.first,
                buildParams.rightParenthesis,
              ),
            );
          }
      }
    });
  }

  Future<void> _convertStatefulToStatelessWidget(
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

      // Remove createState method
      final createStateMethod = widgetClass.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((element) => element.name.lexeme == 'createState');
      if (createStateMethod != null) {
        builder.addDeletion(
          range.startOffsetEndOffset(
            createStateMethod.offset - 1,
            createStateMethod.end + 1,
          ),
        );
      }

      // Search for the associated State class
      final stateClass = findStateClass(widgetClass);
      if (stateClass == null) return;

      final fieldFinder = _FieldFinder();

      for (final member in stateClass.members) {
        if (member is ConstructorDeclaration) {
          member.accept(fieldFinder);
        }
      }

      final fieldsAssignedInConstructors =
          fieldFinder.fieldsAssignedInConstructors;

      // Prepare nodes to move.
      final nodesToMove = <ClassMember>[];
      final elementsToMove = <Element>{};
      for (final member in stateClass.members) {
        if (member is FieldDeclaration) {
          if (member.isStatic) {
            return;
          }
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
        } else if (member is MethodDeclaration) {
          if (member.isStatic) {
            return;
          }
          if (!_isDefaultOverride(member)) {
            nodesToMove.add(member);
            elementsToMove.add(member.declaredFragment!.element);
          }
        }
      }

      final deleteRanges = <SourceRange>[];
      for (final node in nodesToMove) {
        final visitor = _ReplacementEditBuilder(
          widgetClass.declaredFragment!.element,
          elementsToMove,
        );
        node.accept(visitor);
        deleteRanges.addAll(visitor.deleteRanges);
      }

      // Move the build method to the widget class
      final buildMethod = stateClass.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((element) => element.name.lexeme == 'build');
      if (buildMethod == null) return;

      final source = unit.declaredFragment!.source;
      final outsideRange = SourceRange(
        widgetClass.end,
        stateClass.offset - widgetClass.end,
      );
      final outsideLines = source.contents.data.substring(
        outsideRange.offset,
        outsideRange.end,
      );
      if (outsideLines.trim().isNotEmpty) {
        builder.addSimpleInsertion(
          stateClass.end,
          '${outsideLines.trimRight()}\n',
        );
      }

      // ignore: prefer_foreach
      for (final range in deleteRanges) {
        builder.addDeletion(range);
      }

      builder.addDeletion(
        range.startEnd(widgetClass.rightBracket, stateClass.leftBracket),
      );

      final parameterRange = _generateBuildMethodParameterRange(buildMethod);
      if (parameterRange == SourceRange.EMPTY) {
        return;
      }
      switch (targetWidget) {
        case StatelessBaseWidgetType.consumerWidget:
        case StatelessBaseWidgetType.hookConsumerWidget:
          final widgetRef = builder.importWidgetRef();
          builder.addSimpleReplacement(
            parameterRange,
            'BuildContext context, $widgetRef ref',
          );
        case StatelessBaseWidgetType.hookWidget:
        case StatelessBaseWidgetType.statelessWidget:
          builder.addSimpleReplacement(parameterRange, 'BuildContext context');
      }
    });
  }

  SourceRange _generateBuildMethodParameterRange(
    MethodDeclaration buildMethod,
  ) {
    final params = buildMethod.parameters;
    if (params == null) return SourceRange.EMPTY;
    final offset = params.leftParenthesis.end;
    final end = params.rightParenthesis.offset;
    return SourceRange(offset, end - offset);
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
// package:analysis_server/lib/src/services/correction/dart/flutter_convert_to_stateless_widget.dart
class _FieldFinder extends RecursiveAstVisitor<void> {
  final fieldsAssignedInConstructors = <FieldElement>{};

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (node.parent is FieldFormalParameter) {
      final element = node.element;
      if (element is FieldFormalParameterElement) {
        final field = element.field;
        if (field != null) {
          fieldsAssignedInConstructors.add(field);
        }
      }
    }

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
  _ReplacementEditBuilder(this.widgetClassElement, this.elementsToMove);

  final ClassElement widgetClassElement;
  final Set<Element> elementsToMove;

  List<SourceRange> deleteRanges = [];

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (node.inDeclarationContext()) {
      return;
    }
    final element = node.element;
    if (element is ExecutableElement &&
        element.enclosingElement == widgetClassElement &&
        !elementsToMove.contains(element)) {
      final parent = node.parent;
      if (parent is PrefixedIdentifier) {
        final grandParent = parent.parent;

        if (!node.name.contains(r'$') &&
            grandParent is InterpolationExpression &&
            grandParent.leftBracket.type ==
                TokenType.STRING_INTERPOLATION_EXPRESSION) {
          final offset = grandParent.rightBracket?.offset;

          if (offset != null) {
            deleteRanges.add(SourceRange(offset, 1));
          }
          deleteRanges.add(SourceRange(grandParent.leftBracket.end - 1, 1));
        }
        final offset = parent.prefix.offset;
        final length = parent.period.end - offset;
        deleteRanges.add(SourceRange(offset, length));
      } else if (parent is MethodInvocation) {
        final target = parent.target;
        final operator = parent.operator;
        if (target != null && operator != null) {
          final offset = target.offset;
          final length = operator.end - offset;
          deleteRanges.add(SourceRange(offset, length));
        }
      } else if (parent is PropertyAccess) {
        final target = parent.target;
        final operator = parent.operator;
        if (target != null) {
          final offset = target.offset;
          final length = operator.end - offset;
          deleteRanges.add(SourceRange(offset, length));
        }
      }
    }
  }
}

bool _isDefaultOverride(MethodDeclaration? methodDeclaration) {
  final body = methodDeclaration?.body;
  if (body != null) {
    Expression expression;
    if (body is BlockFunctionBody) {
      final statements = body.block.statements;
      if (statements.isEmpty) return true;
      if (statements.length > 1) return false;
      final first = statements.first;
      if (first is! ExpressionStatement) return false;
      expression = first.expression;
    } else if (body is ExpressionFunctionBody) {
      expression = body.expression;
    } else {
      return false;
    }
    if (expression is MethodInvocation &&
        expression.target is SuperExpression &&
        methodDeclaration!.name.lexeme == expression.methodName.name) {
      return true;
    }
  }
  return false;
}

// Concrete implementations for each widget type
class ConvertToHookConsumerWidget extends ConvertToStatelessBaseWidget {
  ConvertToHookConsumerWidget({required super.context});

  @override
  StatelessBaseWidgetType get targetWidget =>
      StatelessBaseWidgetType.hookConsumerWidget;
}

class ConvertToHookWidget extends ConvertToStatelessBaseWidget {
  ConvertToHookWidget({required super.context});

  @override
  StatelessBaseWidgetType get targetWidget =>
      StatelessBaseWidgetType.hookWidget;
}

class ConvertToConsumerWidget extends ConvertToStatelessBaseWidget {
  ConvertToConsumerWidget({required super.context});

  @override
  StatelessBaseWidgetType get targetWidget =>
      StatelessBaseWidgetType.consumerWidget;
}

class ConvertToStatelessWidget extends ConvertToStatelessBaseWidget {
  ConvertToStatelessWidget({required super.context});

  @override
  StatelessBaseWidgetType get targetWidget =>
      StatelessBaseWidgetType.statelessWidget;
}
