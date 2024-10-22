import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source.dart';
import 'package:analyzer/source/source_range.dart';
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
        builder.addDeletion(createStateMethod.sourceRange.getExpanded(1));
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
        } else if (member is MethodDeclaration) {
          if (member.isStatic) {
            return;
          }
          if (!_isDefaultOverride(member)) {
            nodesToMove.add(member);
            elementsToMove.add(member.declaredElement!);
          }
        }
      }

      final deleteRanges = <SourceRange>[];
      for (final node in nodesToMove) {
        final visitor = _ReplacementEditBuilder(
          widgetClass.declaredElement!,
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

      final outsideRange = SourceRange(
        widgetClass.sourceRange.end,
        stateClass.sourceRange.offset - widgetClass.sourceRange.end,
      );
      final outsideLines = source.contents.data.substring(
        outsideRange.offset,
        outsideRange.end,
      );
      if (outsideLines.trim().isNotEmpty) {
        builder.addSimpleInsertion(
          stateClass.sourceRange.end,
          '${outsideLines.trimRight()}\n',
        );
      }

      // ignore: prefer_foreach
      for (final range in deleteRanges) {
        builder.addDeletion(range);
      }

      builder.addDeletion(
        SourceRange(
          widgetClass.rightBracket.offset,
          stateClass.leftBracket.end - widgetClass.rightBracket.offset,
        ),
      );

      final parameterRange = _generateBuildMethodParameterRange(buildMethod);
      if (parameterRange == SourceRange.EMPTY) {
        return;
      }
      switch (targetWidget) {
        case StatelessBaseWidgetType.consumerWidget:
        case StatelessBaseWidgetType.hookConsumerWidget:
          builder.addSimpleReplacement(
            parameterRange,
            'BuildContext context, WidgetRef ref',
          );
          break;
        case StatelessBaseWidgetType.hookWidget:
        case StatelessBaseWidgetType.statelessWidget:
          builder.addSimpleReplacement(
            parameterRange,
            'BuildContext context',
          );
          break;
      }
    });
  }

  SourceRange _generateBuildMethodParameterRange(
    MethodDeclaration buildMethod,
  ) {
    final offset = buildMethod.parameters?.leftParenthesis.end ?? 0;
    final end = buildMethod.parameters?.rightParenthesis.offset ?? 0;
    return SourceRange(offset, end - offset);
  }
}

// Original implemenation in
// package:analysis_server/lib/src/services/correction/dart/flutter_convert_to_stateless_widget.dart
class _FieldFinder extends RecursiveAstVisitor<void> {
  final fieldsAssignedInConstructors = <FieldElement>{};

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (node.parent is FieldFormalParameter) {
      final element = node.staticElement;
      if (element is FieldFormalParameterElement) {
        final field = element.field;
        if (field != null) {
          fieldsAssignedInConstructors.add(field);
        }
      }
    }

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
  );

  final ClassElement widgetClassElement;
  final Set<Element> elementsToMove;

  List<SourceRange> deleteRanges = [];

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
