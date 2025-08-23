part of '../riverpod_types.dart';

/// [TypeChecker] for `Override`
const overrideType = TypeChecker.fromName('Override', packageName: 'riverpod');

/// [TypeChecker] for `ProviderBase`
const providerBaseType = TypeChecker.fromName(
  'ProviderBase',
  packageName: 'riverpod',
);

/// [TypeChecker] for `ProviderListenable`
const providerListenableType = TypeChecker.fromName(
  'ProviderListenable',
  packageName: 'riverpod',
);

/// [TypeChecker] from `ProviderContainer`
const providerContainerType = TypeChecker.fromName(
  'ProviderContainer',
  packageName: 'riverpod',
);

/// [TypeChecker] from `ProviderSubscription`
const providerSubscriptionType = TypeChecker.fromName(
  'ProviderSubscription',
  packageName: 'riverpod',
);

/// [TypeChecker] from `ProviderScope`
const providerScopeType = TypeChecker.fromName(
  'ProviderScope',
  packageName: 'flutter_riverpod',
);

/// [TypeChecker] from `ProviderScope`
const uncontrolledProviderScopeType = TypeChecker.fromName(
  'UncontrolledProviderScope',
  packageName: 'flutter_riverpod',
);

/// [TypeChecker] from `WidgetRef`
const widgetRefType = TypeChecker.fromName(
  'WidgetRef',
  packageName: 'flutter_riverpod',
);

/// Checks that the value is coming from a `package:riverpod` package
const isFromRiverpod = TypeChecker.fromPackage('riverpod');

/// Checks that the value is coming from a `package:riverpod_annotation` package
const isFromRiverpodAnnotation = TypeChecker.fromPackage('riverpod_annotation');

/// Checks that the value is coming from a `package:riverpod` package
const isFromFlutterRiverpod = TypeChecker.fromPackage('flutter_riverpod');

/// Checks that the value is coming from a `package:riverpod` package
const isFromHooksRiverpod = TypeChecker.fromPackage('hooks_riverpod');

/// [TypeChecker for `Ref`
const refType = TypeChecker.fromName('Ref', packageName: 'riverpod');

bool _isBuiltInRef(DartType targetType) {
  // Since Ref is sealed, checking that the function is from the package:riverpod
  // before checking its type skips iterating over the superclasses of an element
  // if it's not from Riverpod.
  return isFromRiverpod.isExactlyType(targetType) &&
      refType.isAssignableFromType(targetType);
}

bool isRiverpodRef(DartType targetType) {
  final isBuiltInRef = _isBuiltInRef(targetType);
  if (isBuiltInRef) return true;

  final targetElement = targetType.element3;

  // Not a built-in ref. Might be a generated ref, let's check that.
  if (targetElement is! MixinElement2) return false;
  final constraints = targetElement.superclassConstraints.singleOrNull;
  if (constraints == null) return false;

  return _isBuiltInRef(constraints);
}

/// Either `WidgetRef` or `Ref`
const anyRefType = TypeChecker.any([widgetRefType, refType]);

/// [TypeChecker for `AsyncData`
const asyncDataType = TypeChecker.fromName(
  'AsyncData',
  packageName: 'riverpod',
);

/// [TypeChecker for `AsyncError`
const asyncErrorType = TypeChecker.fromName(
  'AsyncError',
  packageName: 'riverpod',
);

/// [TypeChecker for `AsyncLoading`
const asyncLoadingType = TypeChecker.fromName(
  'AsyncLoading',
  packageName: 'riverpod',
);

/// [TypeChecker for `AsyncValue`
const asyncValueType = TypeChecker.fromName(
  'AsyncValue',
  packageName: 'riverpod',
);
const asyncValueCode = '#{{riverpod|AsyncValue}}';

/// [TypeChecker] for `ProviderContainer`
const containerType = TypeChecker.fromName(
  'ProviderContainer',
  packageName: 'riverpod',
);

/// Either `ProviderBase` or `Family`
const providerOrFamilyType = TypeChecker.any([providerBaseType, familyType]);

/// [TypeChecker] for `Family`
const familyType = TypeChecker.fromName('Family', packageName: 'riverpod');
