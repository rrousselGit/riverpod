import 'type_checker.dart';

/// [TypeChecker] for `ProviderBase`
const providerBaseType =
    TypeChecker.fromName('ProviderBase', packageName: 'riverpod');

/// [TypeChecker] for `AlwaysAliveProviderListenable`
const alwaysAliveProviderListenableType = TypeChecker.any([
  TypeChecker.fromName(
    'AlwaysAliveProviderListenable',
    packageName: 'riverpod',
  ),
]);

/// [TypeChecker] for `Family`
const familyType = TypeChecker.fromName('Family', packageName: 'riverpod');

/// [TypeChecker] for `Future`
const futureType = TypeChecker.fromUrl('dart:async#Future');

/// [TypeChecker] for `Stream`
const streamType = TypeChecker.fromUrl('dart:async#Stream');

/// [TypeChecker] for `ProviderContainer`
const containerType =
    TypeChecker.fromName('ProviderContainer', packageName: 'riverpod');

/// [TypeChecker] for `AsyncNotifierBase`
const asyncNotifierBaseType =
    TypeChecker.fromName('AsyncNotifierBase', packageName: 'riverpod');

/// [TypeChecker] for `NotifierBase`
const notifierBaseType =
    TypeChecker.fromName('NotifierBase', packageName: 'riverpod');

/// Either `NotifierBase` or `AsyncNotifierBase`
const anyNotifierType =
    TypeChecker.any([asyncNotifierBaseType, notifierBaseType]);

/// Either `ProviderBase` or `Family`
const providerOrFamilyType = TypeChecker.any([providerBaseType, familyType]);

/// Either `FutureOr` or `Stream`
const futureOrStreamType = TypeChecker.any([futureType, streamType]);

/// [TypeChecker] from `Widget` from Flutter
const widgetType = TypeChecker.fromName('Widget', packageName: 'flutter');

/// [TypeChecker] from `State` from Flutter
const widgetStateType = TypeChecker.fromName('State', packageName: 'flutter');

/// [TypeChecker] from `WidgetRef`
const widgetRefType =
    TypeChecker.fromName('WidgetRef', packageName: 'flutter_riverpod');

/// [TypeChecker for `Ref`
const refType = TypeChecker.fromName('Ref', packageName: 'riverpod');

/// Either `WidgetRef` or `Ref`
const anyRefType = TypeChecker.any([widgetRefType, refType]);

/// [TypeChecker for `ConsumerWidget``
const consumerWidgetType = TypeChecker.fromName(
  'ConsumerWidget',
  packageName: 'flutter_riverpod',
);

/// [TypeChecker for `ConsumerState`
const consumerStateType = TypeChecker.fromName(
  'ConsumerState',
  packageName: 'flutter_riverpod',
);

/// `Ref` methods that can make a provider depend on another provider.
const refBinders = {'read', 'watch', 'listen'};
