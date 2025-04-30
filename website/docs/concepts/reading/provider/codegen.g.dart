// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(repository)
const repositoryProvider = RepositoryProvider._();

final class RepositoryProvider
    extends $FunctionalProvider<Repository, Repository>
    with $Provider<Repository> {
  const RepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'repositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$repositoryHash();

  @$internal
  @override
  $ProviderElement<Repository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Repository create(Ref ref) {
    return repository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Repository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Repository>(value),
    );
  }
}

String _$repositoryHash() => r'6f859a9d70c3112139aaf826ee2bd541a4c001cb';

@ProviderFor(value)
const valueProvider = ValueProvider._();

final class ValueProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const ValueProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'valueProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$valueHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return value(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }
}

String _$valueHash() => r'fcb38a2d2c3755f3691e73cd163e8c895d1af4b5';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
