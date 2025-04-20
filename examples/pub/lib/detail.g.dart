// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(fetchPackageDetails)
const fetchPackageDetailsProvider = FetchPackageDetailsFamily._();

final class FetchPackageDetailsProvider
    extends $FunctionalProvider<AsyncValue<Package>, FutureOr<Package>>
    with $FutureModifier<Package>, $FutureProvider<Package> {
  const FetchPackageDetailsProvider._(
      {required FetchPackageDetailsFamily super.from,
      required String super.argument,
      FutureOr<Package> Function(
        Ref ref, {
        required String packageName,
      })? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'fetchPackageDetailsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<Package> Function(
    Ref ref, {
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
  $FutureProviderElement<Package> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  FetchPackageDetailsProvider $copyWithCreate(
    FutureOr<Package> Function(
      Ref ref,
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
  FutureOr<Package> create(Ref ref) {
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
    r'16ad07d6f69412f6d456c6d482f15dc53421df74';

final class FetchPackageDetailsFamily extends Family {
  const FetchPackageDetailsFamily._()
      : super(
          retry: null,
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
      Ref ref,
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FetchPackageDetailsProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(likedPackages)
const likedPackagesProvider = LikedPackagesProvider._();

final class LikedPackagesProvider extends $FunctionalProvider<
        AsyncValue<List<String>>, FutureOr<List<String>>>
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  const LikedPackagesProvider._(
      {FutureOr<List<String>> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'likedPackagesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<List<String>> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$likedPackagesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  LikedPackagesProvider $copyWithCreate(
    FutureOr<List<String>> Function(
      Ref ref,
    ) create,
  ) {
    return LikedPackagesProvider._(create: create);
  }

  @override
  FutureOr<List<String>> create(Ref ref) {
    final _$cb = _createCb ?? likedPackages;
    return _$cb(ref);
  }
}

String _$likedPackagesHash() => r'8debee8d8fa48334d1de21fa9bbf03224265d29d';

@ProviderFor(pubRepository)
const pubRepositoryProvider = PubRepositoryProvider._();

final class PubRepositoryProvider
    extends $FunctionalProvider<PubRepository, PubRepository>
    with $Provider<PubRepository> {
  const PubRepositoryProvider._(
      {PubRepository Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'pubRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final PubRepository Function(
    Ref ref,
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
  $ProviderElement<PubRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  PubRepositoryProvider $copyWithCreate(
    PubRepository Function(
      Ref ref,
    ) create,
  ) {
    return PubRepositoryProvider._(create: create);
  }

  @override
  PubRepository create(Ref ref) {
    final _$cb = _createCb ?? pubRepository;
    return _$cb(ref);
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
      required String super.argument,
      super.runNotifierBuildOverride,
      PackageMetrics Function()? create})
      : _createCb = create,
        super(
          retry: null,
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
      Ref,
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
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(this, pointer);

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
          retry: null,
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
      createElement: (pointer) {
        final provider = pointer.origin as PackageMetricsProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<PackageMetricsScore> Function(
            Ref ref, PackageMetrics notifier, String argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as PackageMetricsProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$PackageMetrics extends $AsyncNotifier<PackageMetricsScore> {
  late final _$args = ref.$arg as String;
  String get packageName => _$args;

  FutureOr<PackageMetricsScore> build({
    required String packageName,
  });
  @$internal
  @override
  void runBuild() {
    final created = build(
      packageName: _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<PackageMetricsScore>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<AsyncValue<PackageMetricsScore>>,
        AsyncValue<PackageMetricsScore>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
