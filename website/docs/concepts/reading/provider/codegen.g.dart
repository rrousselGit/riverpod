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
    extends $FunctionalProvider<Repository, Repository, RepositoryRef>
    with $Provider<Repository, RepositoryRef> {
  const RepositoryProvider._(
      {Repository Function(
        RepositoryRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
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

  @override
  $ProviderElement<Repository> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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

String _$repositoryHash() => r'c6dc3b5b727028966b5b850b27ffc7294b485273';

typedef ValueRef = Ref<String>;

@ProviderFor(value)
const valueProvider = ValueProvider._();

final class ValueProvider extends $FunctionalProvider<String, String, ValueRef>
    with $Provider<String, ValueRef> {
  const ValueProvider._(
      {String Function(
        ValueRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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

String _$valueHash() => r'8c26f7aaa911af815cff9e513a18e4d8dcc6d1df';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
