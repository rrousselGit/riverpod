part of '../riverpod_types.dart';

/// Either ChangeNotifierProvider or AutoDisposeChangeNotifierProvider
const changeNotifierProviderType = TypeChecker.fromName(
  'ChangeNotifierProvider',
  packageName: 'flutter_riverpod',
);

/// Either StateNotifierProvider or AutoDisposeStateNotifierProvider
const stateNotifierProviderType = TypeChecker.fromName(
  'StateNotifierProvider',
  packageName: 'riverpod',
);

/// [TypeChecker] for `StateNotifier`
const stateNotifierType = TypeChecker.fromName(
  'StateNotifier',
  packageName: 'state_notifier',
);

/// [TypeChecker] for `ChangeNotifier`
const changeNotifierType = TypeChecker.fromName(
  'ChangeNotifier',
  packageName: 'flutter',
);

/// Either StateProvider or AutoDisposeStateProvider
const stateProviderType = TypeChecker.fromName(
  'StateProvider',
  packageName: 'riverpod',
);

/// [TypeChecker] for `AsyncNotifierBase`
const asyncNotifierBaseType = TypeChecker.fromName(
  r'$AsyncNotifier',
  packageName: 'riverpod',
);

/// [TypeChecker] for `AsyncNotifierBase`
const streamNotifierBaseType = TypeChecker.fromName(
  r'$StreamNotifier',
  packageName: 'riverpod',
);

/// [TypeChecker] for `NotifierBase`
const notifierBaseType = TypeChecker.fromName(
  r'$Notifier',
  packageName: 'riverpod',
);

/// Either `NotifierBase` or `AsyncNotifierBase`
const anyNotifierType = TypeChecker.any([
  asyncNotifierBaseType,
  streamNotifierBaseType,
  notifierBaseType,
]);
