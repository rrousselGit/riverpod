part of '../riverpod_types.dart';

/// FutureProvider
const futureProviderType = TypeChecker.fromName(
  'FutureProvider',
  packageName: 'riverpod',
);

/// StreamProvider
const streamProviderType = TypeChecker.fromName(
  'StreamProvider',
  packageName: 'riverpod',
);

/// NotifierProvider
const anyNotifierProviderType = TypeChecker.fromName(
  r'$NotifierProvider',
  packageName: 'riverpod',
);

/// Either AsyncNotifierProvider or AutoDisposeAsyncNotifierProvider or their family form
const anyAsyncNotifierProviderType = TypeChecker.any([
  TypeChecker.fromName(r'$AsyncNotifierProvider', packageName: 'riverpod'),
  TypeChecker.fromName(r'$StreamNotifierProvider', packageName: 'riverpod'),
]);

/// Either Provider or AutoDisposeProvider
const providerType = TypeChecker.fromName(
  'Provider',
  packageName: 'riverpod',
);
