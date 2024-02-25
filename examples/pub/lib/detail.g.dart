// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef FetchPackageDetailsRef = Ref<AsyncValue<Package>>;

@ProviderFor(fetchPackageDetails)
const fetchPackageDetailsProvider = FetchPackageDetailsFamily._();

final class FetchPackageDetailsProvider extends $FunctionalProvider<
        AsyncValue<Package>, FutureOr<Package>, FetchPackageDetailsRef>
    with
        $FutureModifier<Package>,
        $FutureProvider<Package, FetchPackageDetailsRef> {
  const FetchPackageDetailsProvider._(
      {required FetchPackageDetailsFamily super.from,
      required String super.argument,
      FutureOr<Package> Function(
        FetchPackageDetailsRef ref, {
        required String packageName,
      })? create})
      : _createCb = create,
        super(
          name: r'fetchPackageDetailsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<Package> Function(
    FetchPackageDetailsRef ref, {
    required String packageName,
  })? _createCb;

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
  $FutureProviderElement<Package> $createElement(ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  FetchPackageDetailsProvider $copyWithCreate(
    FutureOr<Package> Function(
      FetchPackageDetailsRef ref,
    ) create,
  ) {
    return FetchPackageDetailsProvider._(
        argument: argument as String,
        from: from! as FetchPackageDetailsFamily,
        create: (
          ref, {
          required String packageName,
        }) =>
            create(ref));
  }

  @override
  FutureOr<Package> create(FetchPackageDetailsRef ref) {
    final _$cb = _createCb ?? fetchPackageDetails;
    final argument = this.argument as String;
    return _$cb(
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
    r'e65ba332cb8397cc5a1aca6e656233dff698391a';

final class FetchPackageDetailsFamily extends Family {
  const FetchPackageDetailsFamily._()
      : super(
          name: r'fetchPackageDetailsProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FetchPackageDetailsProvider call({
    required String packageName,
  }) =>
      FetchPackageDetailsProvider._(argument: packageName, from: this);

  @override
  String debugGetCreateSourceHash() => _$fetchPackageDetailsHash();

  @override
  String toString() => r'fetchPackageDetailsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    FutureOr<Package> Function(
      FetchPackageDetailsRef ref,
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as FetchPackageDetailsProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(container);
      },
    );
  }
}

typedef LikedPackagesRef = Ref<AsyncValue<List<String>>>;

@ProviderFor(likedPackages)
const likedPackagesProvider = LikedPackagesProvider._();

final class LikedPackagesProvider extends $FunctionalProvider<
        AsyncValue<List<String>>, FutureOr<List<String>>, LikedPackagesRef>
    with
        $FutureModifier<List<String>>,
        $FutureProvider<List<String>, LikedPackagesRef> {
  const LikedPackagesProvider._(
      {FutureOr<List<String>> Function(
        LikedPackagesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'likedPackagesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<List<String>> Function(
    LikedPackagesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$likedPackagesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
          ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  LikedPackagesProvider $copyWithCreate(
    FutureOr<List<String>> Function(
      LikedPackagesRef ref,
    ) create,
  ) {
    return LikedPackagesProvider._(create: create);
  }

  @override
  FutureOr<List<String>> create(LikedPackagesRef ref) {
    final _$cb = _createCb ?? likedPackages;
    return _$cb(ref);
  }
}

String _$likedPackagesHash() => r'304a4def167e245812638cba776e8d5eb66d8844';

typedef PubRepositoryRef = Ref<PubRepository>;

@ProviderFor(pubRepository)
const pubRepositoryProvider = PubRepositoryProvider._();

final class PubRepositoryProvider
    extends $FunctionalProvider<PubRepository, PubRepository, PubRepositoryRef>
    with $Provider<PubRepository, PubRepositoryRef> {
  const PubRepositoryProvider._(
      {PubRepository Function(
        PubRepositoryRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'pubRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final PubRepository Function(
    PubRepositoryRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$pubRepositoryHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PubRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<PubRepository>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<PubRepository> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  PubRepositoryProvider $copyWithCreate(
    PubRepository Function(
      PubRepositoryRef ref,
    ) create,
  ) {
    return PubRepositoryProvider._(create: create);
  }

  @override
  PubRepository create(PubRepositoryRef ref) {
    final _$cb = _createCb ?? pubRepository;
    return _$cb(ref);
  }
}

String _$pubRepositoryHash() => r'1f4dbfa0911f6467067fab244677acbcb8c7ad4e';

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
      required String super.argument,
      super.runNotifierBuildOverride,
      PackageMetrics Function()? create})
      : _createCb = create,
        super(
          name: r'packageMetricsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final PackageMetrics Function()? _createCb;

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
  PackageMetrics create() => _createCb?.call() ?? PackageMetrics();

  @$internal
  @override
  PackageMetricsProvider $copyWithCreate(
    PackageMetrics Function() create,
  ) {
    return PackageMetricsProvider._(
        argument: argument as String,
        from: from! as PackageMetricsFamily,
        create: create);
  }

  @$internal
  @override
  PackageMetricsProvider $copyWithBuild(
    FutureOr<PackageMetricsScore> Function(
      Ref<AsyncValue<PackageMetricsScore>>,
      PackageMetrics,
    ) build,
  ) {
    return PackageMetricsProvider._(
        argument: argument as String,
        from: from! as PackageMetricsFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<PackageMetrics, PackageMetricsScore>
      $createElement(ProviderContainer container) =>
          $AsyncNotifierProviderElement(this, container);

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
final class PackageMetricsFamily extends Family {
  const PackageMetricsFamily._()
      : super(
          name: r'packageMetricsProvider',
          dependencies: null,
          allTransitiveDependencies: null,
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
  String debugGetCreateSourceHash() => _$packageMetricsHash();

  @override
  String toString() => r'packageMetricsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    PackageMetrics Function(
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as PackageMetricsProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<PackageMetricsScore> Function(
            Ref<AsyncValue<PackageMetricsScore>> ref,
            PackageMetrics notifier,
            String argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as PackageMetricsProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$PackageMetrics extends $AsyncNotifier<PackageMetricsScore> {
  late final _$args =
      (ref as $AsyncNotifierProviderElement).origin.argument as String;
  String get packageName => _$args;

  FutureOr<PackageMetricsScore> build({
    required String packageName,
  });
  @$internal
  @override
  FutureOr<PackageMetricsScore> runBuild() => build(
        packageName: _$args,
      );
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
