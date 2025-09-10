import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../imports.dart';
import '../../object_utils.dart';

enum StatelessBaseWidgetType {
  hookConsumerWidget(
    priority: 37,
    typeChecker: TypeChecker.fromName(
      'HookConsumerWidget',
      packageName: 'hooks_riverpod',
    ),
    requiredPackage: 'hooks_riverpod',
  ),
  hookWidget(
    priority: 36,
    typeChecker: TypeChecker.fromName(
      'HookWidget',
      packageName: 'flutter_hooks',
    ),
    requiredPackage: 'flutter_hooks',
  ),
  consumerWidget(
    priority: 35,
    typeChecker: TypeChecker.fromName(
      'ConsumerWidget',
      packageName: 'flutter_riverpod',
    ),
  ),
  statelessWidget(
    priority: 34,
    typeChecker: TypeChecker.fromName(
      'StatelessWidget',
      packageName: 'flutter',
    ),
  );

  const StatelessBaseWidgetType({
    required this.priority,
    required this.typeChecker,
    this.requiredPackage,
  });

  final int priority;
  final TypeChecker typeChecker;
  final String? requiredPackage;

  String widgetName(DartFileEditBuilder builder) {
    return switch (this) {
      StatelessBaseWidgetType.hookConsumerWidget =>
        builder.importHookConsumerWidget(),
      StatelessBaseWidgetType.hookWidget => builder.importHookWidget(),
      StatelessBaseWidgetType.consumerWidget => builder.importConsumerWidget(),
      StatelessBaseWidgetType.statelessWidget =>
        builder.importStatelessWidget(),
    };
  }

  String get assistName {
    return switch (this) {
      StatelessBaseWidgetType.hookConsumerWidget => 'HookConsumerWidget',
      StatelessBaseWidgetType.hookWidget => 'HookWidget',
      StatelessBaseWidgetType.consumerWidget => 'ConsumerWidget',
      StatelessBaseWidgetType.statelessWidget => 'StatelessWidget',
    };
  }
}

enum StatefulBaseWidgetType {
  statefulHookConsumerWidget(
    widgetAssistName: 'StatefulHookConsumerWidget',
    priority: 33,
    typeChecker: TypeChecker.fromName(
      'StatefulHookConsumerWidget',
      packageName: 'hooks_riverpod',
    ),
    requiredPackage: 'hooks_riverpod',
  ),
  statefulHookWidget(
    widgetAssistName: 'StatefulHookWidget',
    priority: 32,
    typeChecker: TypeChecker.fromName(
      'StatefulHookWidget',
      packageName: 'flutter_hooks',
    ),
    requiredPackage: 'flutter_hooks',
  ),
  consumerStatefulWidget(
    widgetAssistName: 'ConsumerStatefulWidget',
    priority: 31,
    typeChecker: TypeChecker.fromName(
      'ConsumerStatefulWidget',
      packageName: 'flutter_riverpod',
    ),
  ),
  statefulWidget(
    widgetAssistName: 'StatefulWidget',
    priority: 30,
    typeChecker: TypeChecker.fromName('StatefulWidget', packageName: 'flutter'),
  );

  const StatefulBaseWidgetType({
    required this.widgetAssistName,
    required this.priority,
    required this.typeChecker,
    this.requiredPackage,
  });

  final String widgetAssistName;
  final int priority;
  final TypeChecker typeChecker;
  final String? requiredPackage;

  String widgetName(DartFileEditBuilder builder) {
    return switch (this) {
      StatefulBaseWidgetType.statefulHookConsumerWidget =>
        builder.importStatefulHookConsumerWidget(),
      StatefulBaseWidgetType.statefulHookWidget =>
        builder.importStatefulHookWidget(),
      StatefulBaseWidgetType.consumerStatefulWidget =>
        builder.importConsumerStatefulWidget(),
      StatefulBaseWidgetType.statefulWidget => builder.importStatefulWidget(),
    };
  }
}

TypeChecker getStatelessBaseType({required StatelessBaseWidgetType? exclude}) {
  return TypeChecker.any(
    StatelessBaseWidgetType.values
        .where((e) => e != exclude)
        .map((e) => e.typeChecker),
  );
}

TypeChecker getStatefulBaseType({required StatefulBaseWidgetType? exclude}) {
  return TypeChecker.any(
    StatefulBaseWidgetType.values
        .where((e) => e != exclude)
        .map((e) => e.typeChecker),
  );
}

const _stateType = TypeChecker.fromName('State', packageName: 'flutter');

ClassDeclaration? findStateClass(ClassDeclaration widgetClass) {
  final widgetType = widgetClass.declaredFragment?.element.thisType;
  if (widgetType == null) return null;

  return widgetClass
      .thisOrAncestorOfType<CompilationUnit>()
      ?.declarations
      .whereType<ClassDeclaration>()
      .where(
        // Is the class a state class?
        (e) =>
            e.extendsClause?.superclass.type.let(
              _stateType.isAssignableFromType,
            ) ??
            false,
      )
      .firstWhereOrNull((e) {
        final stateWidgetType = e
            .extendsClause
            ?.superclass
            .typeArguments
            ?.arguments
            .firstOrNull
            ?.type;
        if (stateWidgetType == null) return false;

        final checker = TypeChecker.fromStatic(widgetType);
        return checker.isExactlyType(stateWidgetType);
      });
}

// Original implementation in package:analyzer/lib/src/dart/ast/extensions.dart
extension IdentifierExtension on Identifier {
  Element2? get writeOrReadElement {
    return _writeElement(this) ?? element;
  }
}

Element2? _writeElement(AstNode node) {
  final parent = node.parent;

  if (parent is AssignmentExpression && parent.leftHandSide == node) {
    return parent.writeElement2;
  }
  if (parent is PostfixExpression && parent.operand == node) {
    return parent.writeElement2;
  }
  if (parent is PrefixExpression && parent.operand == node) {
    return parent.writeElement2;
  }

  if (parent is PrefixedIdentifier && parent.identifier == node) {
    return _writeElement(parent);
  }
  if (parent is PropertyAccess && parent.propertyName == node) {
    return _writeElement(parent);
  }
  return null;
}
