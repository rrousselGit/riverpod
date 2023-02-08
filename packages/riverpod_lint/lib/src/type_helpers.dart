import 'package:custom_lint_builder/custom_lint_builder.dart';

const providerBase = TypeChecker.fromName(
  'ProviderBase',
  packageName: 'riverpod',
);
const alwaysAliveProviderListenable = TypeChecker.any([
  TypeChecker.fromName(
    'AlwaysAliveProviderListenable',
    packageName: 'riverpod',
  ),
]);

const family = TypeChecker.fromName('Family', packageName: 'riverpod');
const future = TypeChecker.fromUrl(
  'dart:async#Future',
);
const stream = TypeChecker.fromUrl(
  'dart:async#Stream',
);
const container = TypeChecker.fromName(
  'ProviderContainer',
  packageName: 'riverpod',
);
const asyncNotifier = TypeChecker.fromName(
  'AsyncNotifierBase',
  packageName: 'riverpod',
);
const notifier = TypeChecker.fromName('NotifierBase', packageName: 'riverpod');
const codegenNotifier = TypeChecker.any([asyncNotifier, notifier]);
const providerOrFamily = TypeChecker.any([providerBase, family]);
const futureOrStream = TypeChecker.any([future, stream]);

const widget = TypeChecker.fromName('Widget', packageName: 'flutter');
const widgetState = TypeChecker.fromName('State', packageName: 'flutter');

const widgetRef = TypeChecker.fromName(
  'WidgetRef',
  packageName: 'flutter_riverpod',
);
const anyRef = TypeChecker.any([widgetRef, ref]);

const consumerWidget = TypeChecker.fromName(
  'ConsumerWidget',
  packageName: 'flutter_riverpod',
);
const consumerState = TypeChecker.fromName(
  'ConsumerState',
  packageName: 'flutter_riverpod',
);
const ref = TypeChecker.fromName('Ref', packageName: 'riverpod');

const riverpod = TypeChecker.fromName(
  'Riverpod',
  packageName: 'riverpod_annotation',
);

const refBinders = {'read', 'watch', 'listen'};
