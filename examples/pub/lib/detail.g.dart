// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(fetchPackageDetails)
const fetchPackageDetailsProvider = FetchPackageDetailsFamily._();

final class FetchPackageDetailsProvider
    extends $FunctionalProvider<AsyncValue<Package>, Package, FutureOr<Package>>
    with $FutureModifier<Package>, $FutureProvider<Package> {
  const FetchPackageDetailsProvider._(
      {required FetchPackageDetailsFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'fetchPackageDetailsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fetchPackageDetailsHash();

  @override
  String toString() {
    return r'fetchPackageDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Package> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Package> create(Ref ref) {
    final argument = this.argument as String;
    return fetchPackageDetails(
      ref,
      packageName: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPackageDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchPackageDetailsHash() =>
    r'16ad07d6f69412f6d456c6d482f15dc53421df74';

final class FetchPackageDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Package>, String> {
  const FetchPackageDetailsFamily._()
      : super(
          retry: null,
          name: r'fetchPackageDetailsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FetchPackageDetailsProvider call({
    required String packageName,
  }) =>
      FetchPackageDetailsProvider._(argument: packageName, from: this);

  @override
  String toString() => r'fetchPackageDetailsProvider';
}

@ProviderFor(likedPackages)
const likedPackagesProvider = LikedPackagesProvider._();

final class LikedPackagesProvider extends $FunctionalProvider<
        AsyncValue<List<String>>, List<String>, FutureOr<List<String>>>
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  const LikedPackagesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'likedPackagesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$likedPackagesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return likedPackages(ref);
  }
}

String _$likedPackagesHash() => r'8debee8d8fa48334d1de21fa9bbf03224265d29d';

@ProviderFor(pubRepository)
const pubRepositoryProvider = PubRepositoryProvider._();

final class PubRepositoryProvider
    extends $FunctionalProvider<PubRepository, PubRepository, PubRepository>
    with $Provider<PubRepository> {
  const PubRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pubRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pubRepositoryHash();

  @$internal
  @override
  $ProviderElement<PubRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PubRepository create(Ref ref) {
    return pubRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PubRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PubRepository>(value),
    );
  }
}

String _$pubRepositoryHash() => r'fd358feb202d2c34ad507ebf0a40bddbebc8ea98';

/// A provider that fetches the likes count, popularity score and pub points
/// for a given package.
///
/// It also exposes utilities to like/unlike a package, assuming the user
/// is logged-in.
@ProviderFor(PackageMetrics)
const packageMetricsProvider = PackageMetricsFamily._();

/// A provider that fetches the likes count, popularity score and pub points
/// for a given package.
///
/// It also exposes utilities to like/unlike a package, assuming the user
/// is logged-in.
final class PackageMetricsProvider
    extends $AsyncNotifierProvider<PackageMetrics, PackageMetricsScore> {
  /// A provider that fetches the likes count, popularity score and pub points
  /// for a given package.
  ///
  /// It also exposes utilities to like/unlike a package, assuming the user
  /// is logged-in.
  const PackageMetricsProvider._(
      {required PackageMetricsFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'packageMetricsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$packageMetricsHash();

  @override
  String toString() {
    return r'packageMetricsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PackageMetrics create() => PackageMetrics();

  @$internal
  @override
  $AsyncNotifierProviderElement<PackageMetrics, PackageMetricsScore>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is PackageMetricsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$packageMetricsHash() => r'67cd25e50357e6e970d432c1d255085a23b856ac';

/// A provider that fetches the likes count, popularity score and pub points
/// for a given package.
///
/// It also exposes utilities to like/unlike a package, assuming the user
/// is logged-in.
final class PackageMetricsFamily extends $Family
    with
        $ClassFamilyOverride<PackageMetrics, AsyncValue<PackageMetricsScore>,
            PackageMetricsScore, FutureOr<PackageMetricsScore>, String> {
  const PackageMetricsFamily._()
      : super(
          retry: null,
          name: r'packageMetricsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// A provider that fetches the likes count, popularity score and pub points
  /// for a given package.
  ///
  /// It also exposes utilities to like/unlike a package, assuming the user
  /// is logged-in.
  PackageMetricsProvider call({
    required String packageName,
  }) =>
      PackageMetricsProvider._(argument: packageName, from: this);

  @override
  String toString() => r'packageMetricsProvider';
}

abstract class _$PackageMetrics extends $AsyncNotifier<PackageMetricsScore> {
  late final _$args = ref.$arg as String;
  String get packageName => _$args;

  FutureOr<PackageMetricsScore> build({
    required String packageName,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      packageName: _$args,
    );
    final ref =
        this.ref as $Ref<AsyncValue<PackageMetricsScore>, PackageMetricsScore>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<PackageMetricsScore>, PackageMetricsScore>,
        AsyncValue<PackageMetricsScore>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
