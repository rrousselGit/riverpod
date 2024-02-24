part of '../riverpod_types.dart';

/// [TypeChecker] from `Widget` from Flutter
const widgetType = TypeChecker.fromName('Widget', packageName: 'flutter');

/// [TypeChecker] from `State` from Flutter
const widgetStateType = TypeChecker.fromName('State', packageName: 'flutter');

/// [TypeChecker for `ConsumerWidget``
const statelessWidgetType = TypeChecker.fromName(
  'StatelessWidget',
  packageName: 'flutter',
);

/// [TypeChecker for `ConsumerWidget``
const statefulWidgetType = TypeChecker.fromName(
  'StatefulWidget',
  packageName: 'flutter',
);

/// [TypeChecker for `ConsumerWidget``
const stateType = TypeChecker.fromName(
  'State',
  packageName: 'flutter',
);

/// [TypeChecker for `ConsumerWidget``
const consumerWidgetType = TypeChecker.fromName(
  'ConsumerWidget',
  packageName: 'flutter_riverpod',
);

/// [TypeChecker for `ConsumerStatefulWidget`
const consumerStatefulWidgetType = TypeChecker.fromName(
  'ConsumerStatefulWidget',
  packageName: 'flutter_riverpod',
);

/// [TypeChecker for `ConsumerState`
const consumerStateType = TypeChecker.fromName(
  'ConsumerState',
  packageName: 'flutter_riverpod',
);

/// [TypeChecker for `HookConsumerWidget`
const hookConsumerWidgetType = TypeChecker.fromName(
  'HookConsumerWidget',
  packageName: 'hooks_riverpod',
);

/// [TypeChecker for `StatefulHookConsumerWidget`
const statefulHookConsumerType = TypeChecker.fromName(
  'StatefulHookConsumerWidget',
  packageName: 'hooks_riverpod',
);

/// [TypeChecker for `HookConsumerWidget`
const hookWidgetType = TypeChecker.fromName(
  'HookWidget',
  packageName: 'hooks_riverpod',
);

/// [TypeChecker for `StatefulHookConsumerWidget`
const statefulHookType = TypeChecker.fromName(
  'StatefulHookWidget',
  packageName: 'hooks_riverpod',
);
