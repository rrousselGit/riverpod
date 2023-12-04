// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPackagesHash() => r'eebf7d838a57f493fffebfd2c8d8ab76d3233165';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [fetchPackages].
@ProviderFor(fetchPackages)
const fetchPackagesProvider = FetchPackagesFamily();

/// See also [fetchPackages].
class FetchPackagesFamily extends Family {
  /// See also [fetchPackages].
  const FetchPackagesFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchPackagesProvider';

  /// See also [fetchPackages].
  FetchPackagesProvider call({
    required int page,
    String search = '',
  }) {
    return FetchPackagesProvider(
      page: page,
      search: search,
    );
  }

  @visibleForOverriding
  @override
  FetchPackagesProvider getProviderOverride(
    covariant FetchPackagesProvider provider,
  ) {
    return call(
      page: provider.page,
      search: provider.search,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<List<Package>> Function(FetchPackagesRef ref) create) {
    return _$FetchPackagesFamilyOverride(this, create);
  }
}

class _$FetchPackagesFamilyOverride implements FamilyOverride {
  _$FetchPackagesFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<List<Package>> Function(FetchPackagesRef ref) create;

  @override
  final FetchPackagesFamily overriddenFamily;

  @override
  FetchPackagesProvider getProviderOverride(
    covariant FetchPackagesProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [fetchPackages].
class FetchPackagesProvider extends AutoDisposeFutureProvider<List<Package>> {
  /// See also [fetchPackages].
  FetchPackagesProvider({
    required int page,
    String search = '',
  }) : this._internal(
          (ref) => fetchPackages(
            ref as FetchPackagesRef,
            page: page,
            search: search,
          ),
          from: fetchPackagesProvider,
          name: r'fetchPackagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchPackagesHash,
          dependencies: FetchPackagesFamily._dependencies,
          allTransitiveDependencies:
              FetchPackagesFamily._allTransitiveDependencies,
          page: page,
          search: search,
        );

  FetchPackagesProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.search,
  }) : super.internal();

  final int page;
  final String search;

  @override
  Override overrideWith(
    FutureOr<List<Package>> Function(FetchPackagesRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchPackagesProvider._internal(
        (ref) => create(ref as FetchPackagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        search: search,
      ),
    );
  }

  @override
  ({
    int page,
    String search,
  }) get argument {
    return (
      page: page,
      search: search,
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Package>> createElement() {
    return _FetchPackagesProviderElement(this);
  }

  FetchPackagesProvider _copyWith(
    FutureOr<List<Package>> Function(FetchPackagesRef ref) create,
  ) {
    return FetchPackagesProvider._internal(
      (ref) => create(ref as FetchPackagesRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      page: page,
      search: search,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPackagesProvider &&
        other.page == page &&
        other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchPackagesRef on AutoDisposeFutureProviderRef<List<Package>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `search` of this provider.
  String get search;
}

class _FetchPackagesProviderElement
    extends AutoDisposeFutureProviderElement<List<Package>>
    with FetchPackagesRef {
  _FetchPackagesProviderElement(super.provider);

  @override
  int get page => (origin as FetchPackagesProvider).page;
  @override
  String get search => (origin as FetchPackagesProvider).search;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
