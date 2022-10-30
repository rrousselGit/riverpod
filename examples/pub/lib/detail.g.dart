// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

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

String $PackageMetricsHash() => r'912bc2073d072ecad280fb971eaa0bfaf8f3f72b';

/// A provider that fetches the likes count, popularity score and pub points
/// for a given package.
///
/// It also exposes utilities to like/unlike a package, assuming the user
/// is logged-in.
///
/// Copied from [PackageMetrics].
class PackageMetricsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PackageMetrics, PackageMetricsScore> {
  PackageMetricsProvider({
    required this.packageName,
  }) : super(
          () => PackageMetrics()..packageName = packageName,
          from: packageMetricsProvider,
          name: r'packageMetricsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $PackageMetricsHash,
          cacheTime: 3000,
        );

  final String packageName;

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

  @override
  FutureOr<PackageMetricsScore> runNotifierBuild(
    covariant _$PackageMetrics notifier,
  ) {
    return notifier.build(
      packageName: packageName,
    );
  }
}

typedef PackageMetricsRef
    = AutoDisposeAsyncNotifierProviderRef<PackageMetricsScore>;

/// A provider that fetches the likes count, popularity score and pub points
/// for a given package.
///
/// It also exposes utilities to like/unlike a package, assuming the user
/// is logged-in.
///
/// Copied from [PackageMetrics].
final packageMetricsProvider = PackageMetricsFamily();

class PackageMetricsFamily extends Family<AsyncValue<PackageMetricsScore>> {
  PackageMetricsFamily();

  PackageMetricsProvider call({
    required String packageName,
  }) {
    return PackageMetricsProvider(
      packageName: packageName,
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderImpl<PackageMetrics, PackageMetricsScore>
      getProviderOverride(
    covariant PackageMetricsProvider provider,
  ) {
    return call(
      packageName: provider.packageName,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies =>
      throw UnimplementedError();

  @override
  int? get disposeDelay => null;

  @override
  int? get cacheTime => 3000;

  @override
  List<ProviderOrFamily>? get dependencies => throw UnimplementedError();

  @override
  String? get name => r'packageMetricsProvider';
}

abstract class _$PackageMetrics
    extends BuildlessAutoDisposeAsyncNotifier<PackageMetricsScore> {
  late final String packageName;

  FutureOr<PackageMetricsScore> build({
    required String packageName,
  });
}

String $fetchPackageDetailsHash() =>
    r'8566403156408d56498f8644e3f719e0d5daeade';

/// See also [fetchPackageDetails].
class FetchPackageDetailsProvider extends AutoDisposeFutureProvider<Package> {
  FetchPackageDetailsProvider({
    required this.packageName,
  }) : super(
          (ref) => fetchPackageDetails(
            ref,
            packageName: packageName,
          ),
          from: fetchPackageDetailsProvider,
          name: r'fetchPackageDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $fetchPackageDetailsHash,
          cacheTime: 3000,
        );

  final String packageName;

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

typedef FetchPackageDetailsRef = AutoDisposeFutureProviderRef<Package>;

/// See also [fetchPackageDetails].
final fetchPackageDetailsProvider = FetchPackageDetailsFamily();

class FetchPackageDetailsFamily extends Family<AsyncValue<Package>> {
  FetchPackageDetailsFamily();

  FetchPackageDetailsProvider call({
    required String packageName,
  }) {
    return FetchPackageDetailsProvider(
      packageName: packageName,
    );
  }

  @override
  AutoDisposeFutureProvider<Package> getProviderOverride(
    covariant FetchPackageDetailsProvider provider,
  ) {
    return call(
      packageName: provider.packageName,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies =>
      throw UnimplementedError();

  @override
  int? get disposeDelay => null;

  @override
  int? get cacheTime => 3000;

  @override
  List<ProviderOrFamily>? get dependencies => throw UnimplementedError();

  @override
  String? get name => r'fetchPackageDetailsProvider';
}

String $likedPackagesHash() => r'304a4def167e245812638cba776e8d5eb66d8844';

/// See also [likedPackages].
final likedPackagesProvider = AutoDisposeFutureProvider<List<String>>(
  likedPackages,
  name: r'likedPackagesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $likedPackagesHash,
);
typedef LikedPackagesRef = AutoDisposeFutureProviderRef<List<String>>;
String $pubRepositoryHash() => r'1f4dbfa0911f6467067fab244677acbcb8c7ad4e';

/// See also [pubRepository].
final pubRepositoryProvider = AutoDisposeProvider<PubRepository>(
  pubRepository,
  name: r'pubRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $pubRepositoryHash,
);
typedef PubRepositoryRef = AutoDisposeProviderRef<PubRepository>;
