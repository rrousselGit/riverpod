import 'type_checker.dart';

const providerBaseType =
    TypeChecker.fromName('ProviderBase', packageName: 'riverpod');
const alwaysAliveProviderListenableType = TypeChecker.any([
  TypeChecker.fromName(
    'AlwaysAliveProviderListenable',
    packageName: 'riverpod',
  ),
]);

const familyType = TypeChecker.fromName('Family', packageName: 'riverpod');
const futureType = TypeChecker.fromUrl(
  'dart:async#Future',
);
const streamType = TypeChecker.fromUrl(
  'dart:async#Stream',
);
const containerType =
    TypeChecker.fromName('ProviderContainer', packageName: 'riverpod');
const asyncNotifierType =
    TypeChecker.fromName('AsyncNotifierBase', packageName: 'riverpod');
const notifierType =
    TypeChecker.fromName('NotifierBase', packageName: 'riverpod');
const codegenNotifierType = TypeChecker.any([asyncNotifierType, notifierType]);
const providerOrFamilyType = TypeChecker.any([providerBaseType, familyType]);
const futureOrStreamType = TypeChecker.any([futureType, streamType]);

const widgetType = TypeChecker.fromName('Widget', packageName: 'flutter');
const widgetStateType = TypeChecker.fromName('State', packageName: 'flutter');

const widgetRefType =
    TypeChecker.fromName('WidgetRef', packageName: 'flutter_riverpod');
const anyRefType = TypeChecker.any([widgetRefType, refType]);

const consumerWidgetType = TypeChecker.fromName(
  'ConsumerWidget',
  packageName: 'flutter_riverpod',
);
const consumerStateType = TypeChecker.fromName(
  'ConsumerState',
  packageName: 'flutter_riverpod',
);
const refType = TypeChecker.fromName('Ref', packageName: 'riverpod');

/// `Ref` methods that can make a provider depend on another provider.
const refBinders = {'read', 'watch', 'listen'};
