// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPackagesHash() => r'3637226080ea667823875a135a6c4cf002cb0329';

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

typedef FetchPackagesRef = AutoDisposeFutureProviderRef<List<Package>>;

/// See also [fetchPackages].
@ProviderFor(fetchPackages)
const fetchPackagesProvider = FetchPackagesFamily();

/// See also [fetchPackages].
class FetchPackagesFamily extends Family<AsyncValue<List<Package>>> {
  /// See also [fetchPackages].
  const FetchPackagesFamily();

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

  @override
  FetchPackagesProvider getProviderOverride(
    covariant FetchPackagesProvider provider,
  ) {
    return call(
      page: provider.page,
      search: provider.search,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchPackagesProvider';
}

/// See also [fetchPackages].
class FetchPackagesProvider extends AutoDisposeFutureProvider<List<Package>> {
  /// See also [fetchPackages].
  FetchPackagesProvider({
    required this.page,
    this.search = '',
  }) : super.internal(
          (ref) => fetchPackages(
            ref,
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
        );

  final int page;
  final String search;

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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
