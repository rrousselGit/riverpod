// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityHash() => r'cb76e67cd45f1823d3ed497a235be53819ce2eaf';

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

/// See also [activity].
@ProviderFor(activity)
const activityProvider = ActivityFamily();

/// See also [activity].
class ActivityFamily extends Family {
  /// See also [activity].
  const ActivityFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'activityProvider';

  /// See also [activity].
  ActivityProvider call(
    String activityType,
  ) {
    return ActivityProvider(
      activityType,
    );
  }

  @visibleForOverriding
  @override
  ActivityProvider getProviderOverride(
    covariant ActivityProvider provider,
  ) {
    return call(
      provider.activityType,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<Activity> Function(ActivityRef ref) create) {
    return _$ActivityFamilyOverride(this, create);
  }
}

class _$ActivityFamilyOverride implements FamilyOverride {
  _$ActivityFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<Activity> Function(ActivityRef ref) create;

  @override
  final ActivityFamily overriddenFamily;

  @override
  ActivityProvider getProviderOverride(
    covariant ActivityProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [activity].
class ActivityProvider extends AutoDisposeFutureProvider<Activity> {
  /// See also [activity].
  ActivityProvider(
    String activityType,
  ) : this._internal(
          (ref) => activity(
            ref as ActivityRef,
            activityType,
          ),
          from: activityProvider,
          name: r'activityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activityHash,
          dependencies: ActivityFamily._dependencies,
          allTransitiveDependencies: ActivityFamily._allTransitiveDependencies,
          activityType: activityType,
        );

  ActivityProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.activityType,
  }) : super.internal();

  final String activityType;

  @override
  Override overrideWith(
    FutureOr<Activity> Function(ActivityRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActivityProvider._internal(
        (ref) => create(ref as ActivityRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        activityType: activityType,
      ),
    );
  }

  @override
  (String,) get argument {
    return (activityType,);
  }

  @override
  AutoDisposeFutureProviderElement<Activity> createElement() {
    return _ActivityProviderElement(this);
  }

  ActivityProvider _copyWith(
    FutureOr<Activity> Function(ActivityRef ref) create,
  ) {
    return ActivityProvider._internal(
      (ref) => create(ref as ActivityRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      activityType: activityType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityProvider && other.activityType == activityType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, activityType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ActivityRef on AutoDisposeFutureProviderRef<Activity> {
  /// The parameter `activityType` of this provider.
  String get activityType;
}

class _ActivityProviderElement
    extends AutoDisposeFutureProviderElement<Activity> with ActivityRef {
  _ActivityProviderElement(super.provider);

  @override
  String get activityType => (origin as ActivityProvider).activityType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
