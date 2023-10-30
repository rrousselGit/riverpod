// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPackageDetailsHash() =>
    r'e65ba332cb8397cc5a1aca6e656233dff698391a';

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

/// See also [fetchPackageDetails].
@ProviderFor(fetchPackageDetails)
const fetchPackageDetailsProvider = FetchPackageDetailsFamily();

/// See also [fetchPackageDetails].
class FetchPackageDetailsFamily extends Family<AsyncValue<Package>> {
  /// See also [fetchPackageDetails].
  const FetchPackageDetailsFamily();

  /// See also [fetchPackageDetails].
  FetchPackageDetailsProvider call({
    required String packageName,
  }) {
    return FetchPackageDetailsProvider(
      packageName: packageName,
    );
  }

  @override
  FetchPackageDetailsProvider getProviderOverride(
    covariant FetchPackageDetailsProvider provider,
  ) {
    return call(
      packageName: provider.packageName,
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
  String? get name => r'fetchPackageDetailsProvider';
}

/// See also [fetchPackageDetails].
class FetchPackageDetailsProvider extends AutoDisposeFutureProvider<Package> {
  /// See also [fetchPackageDetails].
  FetchPackageDetailsProvider({
    required String packageName,
  }) : this._internal(
          (ref) => fetchPackageDetails(
            ref as FetchPackageDetailsRef,
            packageName: packageName,
          ),
          from: fetchPackageDetailsProvider,
          name: r'fetchPackageDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchPackageDetailsHash,
          dependencies: FetchPackageDetailsFamily._dependencies,
          allTransitiveDependencies:
              FetchPackageDetailsFamily._allTransitiveDependencies,
          packageName: packageName,
        );

  FetchPackageDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.packageName,
  }) : super.internal();

  final String packageName;

  @override
  Override overrideWith(
    FutureOr<Package> Function(FetchPackageDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchPackageDetailsProvider._internal(
        (ref) => create(ref as FetchPackageDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        packageName: packageName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Package> createElement() {
    return _FetchPackageDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPackageDetailsProvider &&
        other.packageName == packageName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, packageName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchPackageDetailsRef on AutoDisposeFutureProviderRef<Package> {
  /// The parameter `packageName` of this provider.
  String get packageName;
}

class _FetchPackageDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Package>
    with FetchPackageDetailsRef {
  _FetchPackageDetailsProviderElement(super.provider);

  @override
  String get packageName => (origin as FetchPackageDetailsProvider).packageName;
}

String _$likedPackagesHash() => r'304a4def167e245812638cba776e8d5eb66d8844';

/// See also [likedPackages].
@ProviderFor(likedPackages)
final likedPackagesProvider = AutoDisposeFutureProvider<List<String>>.internal(
  likedPackages,
  name: r'likedPackagesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$likedPackagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LikedPackagesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$pubRepositoryHash() => r'1f4dbfa0911f6467067fab244677acbcb8c7ad4e';

/// See also [pubRepository].
@ProviderFor(pubRepository)
final pubRepositoryProvider = AutoDisposeProvider<PubRepository>.internal(
  pubRepository,
  name: r'pubRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pubRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PubRepositoryRef = AutoDisposeProviderRef<PubRepository>;
String _$packageMetricsHash() => r'67cd25e50357e6e970d432c1d255085a23b856ac';

abstract class _$PackageMetrics
    extends BuildlessAutoDisposeAsyncNotifier<PackageMetricsScore> {
  late final String packageName;

  FutureOr<PackageMetricsScore> build({
    required String packageName,
  });
}

/// A provider that fetches the likes count, popularity score and pub points
/// for a given package.
///
/// It also exposes utilities to like/unlike a package, assuming the user
/// is logged-in.
///
/// Copied from [PackageMetrics].
@ProviderFor(PackageMetrics)
const packageMetricsProvider = PackageMetricsFamily();

/// A provider that fetches the likes count, popularity score and pub points
/// for a given package.
///
/// It also exposes utilities to like/unlike a package, assuming the user
/// is logged-in.
///
/// Copied from [PackageMetrics].
class PackageMetricsFamily extends Family<AsyncValue<PackageMetricsScore>> {
  /// A provider that fetches the likes count, popularity score and pub points
  /// for a given package.
  ///
  /// It also exposes utilities to like/unlike a package, assuming the user
  /// is logged-in.
  ///
  /// Copied from [PackageMetrics].
  const PackageMetricsFamily();

  /// A provider that fetches the likes count, popularity score and pub points
  /// for a given package.
  ///
  /// It also exposes utilities to like/unlike a package, assuming the user
  /// is logged-in.
  ///
  /// Copied from [PackageMetrics].
  PackageMetricsProvider call({
    required String packageName,
  }) {
    return PackageMetricsProvider(
      packageName: packageName,
    );
  }

  @override
  PackageMetricsProvider getProviderOverride(
    covariant PackageMetricsProvider provider,
  ) {
    return call(
      packageName: provider.packageName,
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
  String? get name => r'packageMetricsProvider';
}

/// A provider that fetches the likes count, popularity score and pub points
/// for a given package.
///
/// It also exposes utilities to like/unlike a package, assuming the user
/// is logged-in.
///
/// Copied from [PackageMetrics].
class PackageMetricsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PackageMetrics, PackageMetricsScore> {
  /// A provider that fetches the likes count, popularity score and pub points
  /// for a given package.
  ///
  /// It also exposes utilities to like/unlike a package, assuming the user
  /// is logged-in.
  ///
  /// Copied from [PackageMetrics].
  PackageMetricsProvider({
    required String packageName,
  }) : this._internal(
          () => PackageMetrics()..packageName = packageName,
          from: packageMetricsProvider,
          name: r'packageMetricsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$packageMetricsHash,
          dependencies: PackageMetricsFamily._dependencies,
          allTransitiveDependencies:
              PackageMetricsFamily._allTransitiveDependencies,
          packageName: packageName,
        );

  PackageMetricsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.packageName,
  }) : super.internal();

  final String packageName;

  @override
  FutureOr<PackageMetricsScore> runNotifierBuild(
    covariant PackageMetrics notifier,
  ) {
    return notifier.build(
      packageName: packageName,
    );
  }

  @override
  Override overrideWith(PackageMetrics Function() create) {
    return ProviderOverride(
      origin: this,
      override: PackageMetricsProvider._internal(
        () => create()..packageName = packageName,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        packageName: packageName,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PackageMetrics, PackageMetricsScore>
      createElement() {
    return _PackageMetricsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PackageMetricsProvider && other.packageName == packageName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, packageName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PackageMetricsRef
    on AutoDisposeAsyncNotifierProviderRef<PackageMetricsScore> {
  /// The parameter `packageName` of this provider.
  String get packageName;
}

class _PackageMetricsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PackageMetrics,
        PackageMetricsScore> with PackageMetricsRef {
  _PackageMetricsProviderElement(super.provider);

  @override
  String get packageName => (origin as PackageMetricsProvider).packageName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
