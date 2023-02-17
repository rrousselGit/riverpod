import 'package:custom_lint_core/custom_lint_core.dart';

/// Matches with the `Riverpod` annotation from riverpod_annotation.
const riverpodType =
    TypeChecker.fromName('Riverpod', packageName: 'riverpod_annotation');

/// [TypeChecker] for `ProviderBase`
const providerBaseType = TypeChecker.fromName(
  'ProviderBase',
  packageName: 'riverpod',
);

///  [TypeChecker] from `ProviderContainer`
const providerContainerType = TypeChecker.fromName(
  'ProviderContainer',
  packageName: 'riverpod',
);

///  [TypeChecker] from `ProviderScope`
const providerScopeType = TypeChecker.fromName(
  'ProviderScope',
  packageName: 'flutter_riverpod',
);

///  [TypeChecker] from `ProviderScope`
const uncontrolledProviderScopeType = TypeChecker.fromName(
  'UncontrolledProviderScope',
  packageName: 'flutter_riverpod',
);

/// [TypeChecker] for `AlwaysAliveProviderListenable`
const alwaysAliveProviderListenableType = TypeChecker.any([
  TypeChecker.fromName(
    'AlwaysAliveProviderListenable',
    packageName: 'riverpod',
  ),
]);

/// Either FutureProvider or AutoDisposeFutureProvider
const anyFutureProviderType = TypeChecker.any([
  TypeChecker.fromName('FutureProvider', packageName: 'riverpod'),
  TypeChecker.fromName('AutoDisposeFutureProvider', packageName: 'riverpod'),
]);

/// Either StreamProvider or AutoDisposeStreamProvider
const anyStreamProviderType = TypeChecker.any([
  TypeChecker.fromName('StreamProvider', packageName: 'riverpod'),
  TypeChecker.fromName('AutoDisposeStreamProvider', packageName: 'riverpod'),
]);

/// Either NotifierProvider or AutoDisposeNotifierProvider or their family form
const anyNotifierProviderType = TypeChecker.any([
  TypeChecker.fromName('NotifierProviderImpl', packageName: 'riverpod'),
  TypeChecker.fromName('FamilyNotifierProviderImpl', packageName: 'riverpod'),
  TypeChecker.fromName(
    'AutoDisposeNotifierProviderImpl',
    packageName: 'riverpod',
  ),
  TypeChecker.fromName(
    'AutoDisposeFamilyNotifierProviderImpl',
    packageName: 'riverpod',
  ),
]);

/// Either AsyncNotifierProvider or AutoDisposeAsyncNotifierProvider or their family form
const anyAsyncNotifierProviderType = TypeChecker.any([
  TypeChecker.fromName('AsyncNotifierProviderImpl', packageName: 'riverpod'),
  TypeChecker.fromName(
    'FamilyAsyncNotifierProviderImpl',
    packageName: 'riverpod',
  ),
  TypeChecker.fromName(
    'AutoDisposeAsyncNotifierProviderImpl',
    packageName: 'riverpod',
  ),
  TypeChecker.fromName(
    'AutoDisposeFamilyAsyncNotifierProviderImpl',
    packageName: 'riverpod',
  ),
]);

/// Either ChangeNotifierProvider or AutoDisposeChangeNotifierProvider
const anyChangeNotifierProviderType = TypeChecker.any([
  TypeChecker.fromName(
    'ChangeNotifierProvider',
    packageName: 'flutter_riverpod',
  ),
  TypeChecker.fromName(
    'AutoDisposeChangeNotifierProvider',
    packageName: 'flutter_riverpod',
  ),
]);

/// Either StateNotifierProvider or AutoDisposeStateNotifierProvider
const anyStateNotifierProviderType = TypeChecker.any([
  TypeChecker.fromName('StateNotifierProvider', packageName: 'riverpod'),
  TypeChecker.fromName(
    'AutoDisposeStateNotifierProvider',
    packageName: 'riverpod',
  ),
]);

/// Either StateProvider or AutoDisposeStateProvider
const anyStateProviderType = TypeChecker.any([
  TypeChecker.fromName('StateProvider', packageName: 'riverpod'),
  TypeChecker.fromName('AutoDisposeStateProvider', packageName: 'riverpod'),
]);

/// Either Provider or AutoDisposeProvider
const anyProviderType = TypeChecker.any([
  TypeChecker.fromName('Provider', packageName: 'riverpod'),
  TypeChecker.fromName('AutoDisposeProvider', packageName: 'riverpod'),
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

/// Checks that the value is coming from a `package:riverpod` package
const isFromRiverpod = TypeChecker.fromPackage('riverpod');

/// Checks that the value is coming from a `package:riverpod` package
const isFromFlutterRiverpod = TypeChecker.fromPackage('flutter_riverpod');

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
