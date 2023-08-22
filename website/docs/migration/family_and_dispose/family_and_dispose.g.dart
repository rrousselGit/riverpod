// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family_and_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bugsEncounteredNotifierHash() =>
    r'f45903bf1c7a2b38cad33907afcdce86901b738b';

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

abstract class _$BugsEncounteredNotifier
    extends BuildlessAutoDisposeAsyncNotifier<int> {
  late final String featureId;

  FutureOr<int> build(
    String featureId,
  );
}

/// See also [BugsEncounteredNotifier].
@ProviderFor(BugsEncounteredNotifier)
const bugsEncounteredNotifierProvider = BugsEncounteredNotifierFamily();

/// See also [BugsEncounteredNotifier].
class BugsEncounteredNotifierFamily extends Family<AsyncValue<int>> {
  /// See also [BugsEncounteredNotifier].
  const BugsEncounteredNotifierFamily();

  /// See also [BugsEncounteredNotifier].
  BugsEncounteredNotifierProvider call(
    String featureId,
  ) {
    return BugsEncounteredNotifierProvider(
      featureId,
    );
  }

  @override
  BugsEncounteredNotifierProvider getProviderOverride(
    covariant BugsEncounteredNotifierProvider provider,
  ) {
    return call(
      provider.featureId,
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
  String? get name => r'bugsEncounteredNotifierProvider';
}

/// See also [BugsEncounteredNotifier].
class BugsEncounteredNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BugsEncounteredNotifier, int> {
  /// See also [BugsEncounteredNotifier].
  BugsEncounteredNotifierProvider(
    this.featureId,
  ) : super.internal(
          () => BugsEncounteredNotifier()..featureId = featureId,
          from: bugsEncounteredNotifierProvider,
          name: r'bugsEncounteredNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bugsEncounteredNotifierHash,
          dependencies: BugsEncounteredNotifierFamily._dependencies,
          allTransitiveDependencies:
              BugsEncounteredNotifierFamily._allTransitiveDependencies,
        );

  final String featureId;

  @override
  bool operator ==(Object other) {
    return other is BugsEncounteredNotifierProvider &&
        other.featureId == featureId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, featureId.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<int> runNotifierBuild(
    covariant BugsEncounteredNotifier notifier,
  ) {
    return notifier.build(
      featureId,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
