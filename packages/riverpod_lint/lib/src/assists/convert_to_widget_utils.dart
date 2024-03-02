import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
// ignore: implementation_imports, somehow not exported by analyzer
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../object_utils.dart';

enum StatelessBaseWidgetType {
  hookConsumerWidget(
    widgetName: 'HookConsumerWidget',
    priority: 37,
    typeChecker: TypeChecker.fromName(
      'HookConsumerWidget',
      packageName: 'hooks_riverpod',
    ),
    requiredPackage: 'hooks_riverpod',
  ),
  hookWidget(
    widgetName: 'HookWidget',
    priority: 36,
    typeChecker: TypeChecker.fromName(
      'HookWidget',
      packageName: 'flutter_hooks',
    ),
    requiredPackage: 'flutter_hooks',
  ),
  consumerWidget(
    widgetName: 'ConsumerWidget',
    priority: 35,
    typeChecker: TypeChecker.fromName(
      'ConsumerWidget',
      packageName: 'flutter_riverpod',
    ),
  ),
  statelessWidget(
    widgetName: 'StatelessWidget',
    priority: 34,
    typeChecker: TypeChecker.fromName(
      'StatelessWidget',
      packageName: 'flutter',
    ),
  ),
  ;

  const StatelessBaseWidgetType({
    required this.widgetName,
    required this.priority,
    required this.typeChecker,
    this.requiredPackage,
  });
  final String widgetName;
  final int priority;
  final TypeChecker typeChecker;
  final String? requiredPackage;
}

enum StatefulBaseWidgetType {
  statefulHookConsumerWidget(
    widgetName: 'StatefulHookConsumerWidget',
    priority: 33,
    typeChecker: TypeChecker.fromName(
      'StatefulHookConsumerWidget',
      packageName: 'hooks_riverpod',
    ),
    requiredPackage: 'hooks_riverpod',
  ),
  statefulHookWidget(
    widgetName: 'StatefulHookWidget',
    priority: 32,
    typeChecker: TypeChecker.fromName(
      'StatefulHookWidget',
      packageName: 'flutter_hooks',
    ),
    requiredPackage: 'flutter_hooks',
  ),
  consumerStatefulWidget(
    widgetName: 'ConsumerStatefulWidget',
    priority: 31,
    typeChecker: TypeChecker.fromName(
      'ConsumerStatefulWidget',
      packageName: 'flutter_riverpod',
    ),
  ),
  statefulWidget(
    widgetName: 'StatefulWidget',
    priority: 30,
    typeChecker: TypeChecker.fromName(
      'StatefulWidget',
      packageName: 'flutter',
    ),
  ),
  ;

  const StatefulBaseWidgetType({
    required this.widgetName,
    required this.priority,
    required this.typeChecker,
    this.requiredPackage,
  });
  final String widgetName;
  final int priority;
  final TypeChecker typeChecker;
  final String? requiredPackage;
}

TypeChecker getStatelessBaseType({
  required StatelessBaseWidgetType? exclude,
}) {
  return TypeChecker.any(
    StatelessBaseWidgetType.values
        .where((e) => e != exclude)
        .map((e) => e.typeChecker),
  );
}

TypeChecker getStatefulBaseType({
  required StatefulBaseWidgetType? exclude,
}) {
  return TypeChecker.any(
    StatefulBaseWidgetType.values
        .where((e) => e != exclude)
        .map((e) => e.typeChecker),
  );
}

const _stateType = TypeChecker.fromName('State', packageName: 'flutter');

ClassDeclaration? findStateClass(ClassDeclaration widgetClass) {
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
    final stateWidgetType =
        e.extendsClause?.superclass.typeArguments?.arguments.firstOrNull?.type;
    if (stateWidgetType == null) return false;

    final checker = TypeChecker.fromStatic(widgetType);
    return checker.isExactlyType(stateWidgetType);
  });
}

// Original implemenation in package:analyzer/lib/src/dart/ast/extensions.dart
extension IdentifierExtension on Identifier {
  Element? get writeOrReadElement {
    return _writeElement(this) ?? staticElement;
  }
}

Element? _writeElement(AstNode node) {
  final parent = node.parent;

  if (parent is AssignmentExpression && parent.leftHandSide == node) {
    return parent.writeElement;
  }
  if (parent is PostfixExpression && parent.operand == node) {
    return parent.writeElement;
  }
  if (parent is PrefixExpression && parent.operand == node) {
    return parent.writeElement;
  }

  if (parent is PrefixedIdentifier && parent.identifier == node) {
    return _writeElement(parent);
  }
  if (parent is PropertyAccess && parent.propertyName == node) {
    return _writeElement(parent);
  }
  return null;
}
