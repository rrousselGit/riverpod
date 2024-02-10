// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family_and_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bugsEncounteredNotifierHash() =>
    r'c76e924f84db91c57d226896b062d9f4e8ab79e5';

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
class BugsEncounteredNotifierFamily extends Family {
  /// See also [BugsEncounteredNotifier].
  const BugsEncounteredNotifierFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bugsEncounteredNotifierProvider';

  /// See also [BugsEncounteredNotifier].
  BugsEncounteredNotifierProvider call(
    String featureId,
  ) {
    return BugsEncounteredNotifierProvider(
      featureId,
    );
  }

  @visibleForOverriding
  @override
  BugsEncounteredNotifierProvider getProviderOverride(
    covariant BugsEncounteredNotifierProvider provider,
  ) {
    return call(
      provider.featureId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(BugsEncounteredNotifier Function() create) {
    return _$BugsEncounteredNotifierFamilyOverride(this, create);
  }
}

class _$BugsEncounteredNotifierFamilyOverride implements FamilyOverride {
  _$BugsEncounteredNotifierFamilyOverride(this.overriddenFamily, this.create);

  final BugsEncounteredNotifier Function() create;

  @override
  final BugsEncounteredNotifierFamily overriddenFamily;

  @override
  BugsEncounteredNotifierProvider getProviderOverride(
    covariant BugsEncounteredNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [BugsEncounteredNotifier].
class BugsEncounteredNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BugsEncounteredNotifier, int> {
  /// See also [BugsEncounteredNotifier].
  BugsEncounteredNotifierProvider(
    String featureId,
  ) : this._internal(
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
          featureId: featureId,
        );

  BugsEncounteredNotifierProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.featureId,
  }) : super.internal();

  final String featureId;

  @override
  FutureOr<int> runNotifierBuild(
    covariant BugsEncounteredNotifier notifier,
  ) {
    return notifier.build(
      featureId,
    );
  }

  @override
  Override overrideWith(BugsEncounteredNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BugsEncounteredNotifierProvider._internal(
        () => create()..featureId = featureId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        featureId: featureId,
      ),
    );
  }

  @override
  (String,) get argument {
    return (featureId,);
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BugsEncounteredNotifier, int>
      createElement() {
    return _BugsEncounteredNotifierProviderElement(this);
  }

  BugsEncounteredNotifierProvider _copyWith(
    BugsEncounteredNotifier Function() create,
  ) {
    return BugsEncounteredNotifierProvider._internal(
      () => create()..featureId = featureId,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      featureId: featureId,
    );
  }

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
}

mixin BugsEncounteredNotifierRef on AutoDisposeAsyncNotifierProviderRef<int> {
  /// The parameter `featureId` of this provider.
  String get featureId;
}

class _BugsEncounteredNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BugsEncounteredNotifier,
        int> with BugsEncounteredNotifierRef {
  _BugsEncounteredNotifierProviderElement(super.provider);

  @override
  String get featureId => (origin as BugsEncounteredNotifierProvider).featureId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
