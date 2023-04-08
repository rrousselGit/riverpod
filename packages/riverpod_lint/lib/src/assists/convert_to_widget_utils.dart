import 'package:analyzer/dart/ast/ast.dart';
// ignore: implementation_imports, somehow not exported by analyzer
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../object_utils.dart';

enum StatelessBaseWidgetType {
  consumerWidget(
    widgetName: 'ConsumerWidget',

    // But the priority above everything else
    priority: 100,
    typeChecker: TypeChecker.fromName(
      'ConsumerWidget',
      packageName: 'flutter_riverpod',
    ),
    needHooksRiverpod: false,
  ),
  hookWidget(
    widgetName: 'HookWidget',
    priority: 98,
    typeChecker: TypeChecker.fromName(
      'HookWidget',
      packageName: 'flutter_hooks',
    ),
    needHooksRiverpod: true,
  ),
  hookConsumerWidget(
    widgetName: 'HookConsumerWidget',
    priority: 96,
    typeChecker: TypeChecker.fromName(
      'HookConsumerWidget',
      packageName: 'hooks_riverpod',
    ),
    needHooksRiverpod: true,
  ),
  statelessWidget(
    widgetName: 'StatelessWidget',
    priority: 94,
    typeChecker: TypeChecker.fromName(
      'StatelessWidget',
      packageName: 'flutter',
    ),
    needHooksRiverpod: false,
  ),
  ;

  const StatelessBaseWidgetType({
    required this.widgetName,
    required this.priority,
    required this.typeChecker,
    required this.needHooksRiverpod,
  });
  final String widgetName;
  final int priority;
  final TypeChecker typeChecker;
  final bool needHooksRiverpod;
}

enum StatefulBaseWidgetType {
  consumerStatefulWidget(
    widgetName: 'ConsumerStatefulWidget',
    priority: 99,
    typeChecker: TypeChecker.fromName(
      'ConsumerStatefulWidget',
      packageName: 'flutter_riverpod',
    ),
    needHooksRiverpod: false,
  ),
  statefulHookWidget(
    widgetName: 'StatefulHookWidget',
    priority: 97,
    typeChecker: TypeChecker.fromName(
      'StatefulHookWidget',
      packageName: 'flutter_hooks',
    ),
    needHooksRiverpod: true,
  ),
  statefulHookConsumerWidget(
    widgetName: 'StatefulHookConsumerWidget',
    priority: 95,
    typeChecker: TypeChecker.fromName(
      'StatefulHookConsumerWidget',
      packageName: 'hooks_riverpod',
    ),
    needHooksRiverpod: true,
  ),
  statefulWidget(
    widgetName: 'StatefulWidget',
    priority: 93,
    typeChecker: TypeChecker.fromName(
      'StatefulWidget',
      packageName: 'flutter',
    ),
    needHooksRiverpod: false,
  ),
  ;

  const StatefulBaseWidgetType({
    required this.widgetName,
    required this.priority,
    required this.typeChecker,
    required this.needHooksRiverpod,
  });
  final String widgetName;
  final int priority;
  final TypeChecker typeChecker;
  final bool needHooksRiverpod;
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
