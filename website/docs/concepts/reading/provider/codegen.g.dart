// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef RepositoryRef = Ref<Repository>;

@ProviderFor(repository)
const repositoryProvider = RepositoryProvider._();

final class RepositoryProvider
    extends $FunctionalProvider<Repository, Repository>
    with $Provider<Repository, RepositoryRef> {
  const RepositoryProvider._(
      {Repository Function(
        RepositoryRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'repositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Repository Function(
    RepositoryRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$repositoryHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Repository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Repository>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Repository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  RepositoryProvider $copyWithCreate(
    Repository Function(
      RepositoryRef ref,
    ) create,
  ) {
    return RepositoryProvider._(create: create);
  }

  @override
  Repository create(RepositoryRef ref) {
    final _$cb = _createCb ?? repository;
    return _$cb(ref);
  }
}

String _$repositoryHash() => r'6f859a9d70c3112139aaf826ee2bd541a4c001cb';

typedef ValueRef = Ref<String>;

@ProviderFor(value)
const valueProvider = ValueProvider._();

final class ValueProvider extends $FunctionalProvider<String, String>
    with $Provider<String, ValueRef> {
  const ValueProvider._(
      {String Function(
        ValueRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'valueProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    ValueRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$valueHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  ValueProvider $copyWithCreate(
    String Function(
      ValueRef ref,
    ) create,
  ) {
    return ValueProvider._(create: create);
  }

  @override
  String create(ValueRef ref) {
    final _$cb = _createCb ?? value;
    return _$cb(ref);
  }
}

String _$valueHash() => r'fcb38a2d2c3755f3691e73cd163e8c895d1af4b5';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
