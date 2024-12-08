part of '../riverpod_types.dart';

/// TypeChecker for the `ProviderFor` annotation
const providerForType = TypeChecker.fromName(
  'ProviderFor',
  packageName: 'riverpod_annotation',
);

/// Matches with the `Dependencies` annotation from riverpod_annotation.
const dependenciesType = TypeChecker.fromName(
  'Dependencies',
  packageName: 'riverpod_annotation',
);

/// Matches with the `Riverpod` annotation from riverpod_annotation.
const riverpodType = TypeChecker.fromName(
  'Riverpod',
  packageName: 'riverpod_annotation',
);

/// Matches with the `Mutation` annotation from riverpod_annotation.
const mutationType = TypeChecker.fromName(
  'Mutation',
  packageName: 'riverpod',
);
