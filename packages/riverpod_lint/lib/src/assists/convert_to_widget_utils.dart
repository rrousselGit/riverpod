import 'package:custom_lint_builder/custom_lint_builder.dart';

enum ConvertToWidget {
  consumerWidget(
    widgetName: 'ConsumerWidget',

    /// But the priority above everything else
    priority: 100,
    typeChecker: TypeChecker.fromName(
      'ConsumerWidget',
      packageName: 'flutter_riverpod',
    ),
    isStateless: true,
  ),
  consumerStatefulWidget(
    widgetName: 'ConsumerStatefulWidget',
    priority: 99,
    typeChecker: TypeChecker.fromName(
      'ConsumerStatefulWidget',
      packageName: 'flutter_riverpod',
    ),
    isStateless: false,
  ),
  hookWidget(
    widgetName: 'HookWidget',
    priority: 98,
    typeChecker: TypeChecker.fromName(
      'HookWidget',
      packageName: 'flutter_hooks',
    ),
    isStateless: true,
  ),
  statefulHookWidget(
    widgetName: 'StatefulHookWidget',
    priority: 97,
    typeChecker: TypeChecker.fromName(
      'StatefulHookWidget',
      packageName: 'flutter_hooks',
    ),
    isStateless: false,
  ),
  hookConsumerWidget(
    widgetName: 'HookConsumerWidget',
    priority: 96,
    typeChecker: TypeChecker.fromName(
      'HookConsumerWidget',
      packageName: 'hooks_riverpod',
    ),
    isStateless: true,
  ),
  statefulHookConsumerWidget(
    widgetName: 'StatefulHookConsumerWidget',
    priority: 95,
    typeChecker: TypeChecker.fromName(
      'StatefulHookConsumerWidget',
      packageName: 'hooks_riverpod',
    ),
    isStateless: false,
  ),
  statelessWidget(
    widgetName: 'StatelessWidget',
    priority: 94,
    typeChecker: TypeChecker.fromName(
      'StatelessWidget',
      packageName: 'flutter',
    ),
    isStateless: true,
  ),
  statefulWidget(
    widgetName: 'StatefulWidget',
    priority: 93,
    typeChecker: TypeChecker.fromName(
      'StatefulWidget',
      packageName: 'flutter',
    ),
    isStateless: false,
  ),
  ;

  const ConvertToWidget({
    required this.widgetName,
    required this.priority,
    required this.typeChecker,
    required this.isStateless,
  });
  final String widgetName;
  final int priority;
  final TypeChecker typeChecker;
  final bool isStateless;
}

TypeChecker getStatelessBaseType({
  required List<ConvertToWidget> excludes,
}) {
  return TypeChecker.any(
    ConvertToWidget.values
        .where((e) => e.isStateless)
        .where((e) => !excludes.contains(e))
        .map((e) => e.typeChecker)
        .toList(),
  );
}

TypeChecker getStatefulBaseType({
  required List<ConvertToWidget> excludes,
}) {
  return TypeChecker.any(
    ConvertToWidget.values
        .where((e) => !e.isStateless)
        .where((e) => !excludes.contains(e))
        .map((e) => e.typeChecker)
        .toList(),
  );
}
