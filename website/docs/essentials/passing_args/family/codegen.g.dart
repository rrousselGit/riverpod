// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

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
class ActivityFamily extends Family<AsyncValue<Activity>> {
  /// See also [activity].
  const ActivityFamily();

  /// See also [activity].
  ActivityProvider call(
    String activityType,
  ) {
    return ActivityProvider(
      activityType,
    );
  }

  @override
  ActivityProvider getProviderOverride(
    covariant ActivityProvider provider,
  ) {
    return call(
      provider.activityType,
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
  String? get name => r'activityProvider';
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
    super._createNotifier, {
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
    FutureOr<Activity> Function(ActivityRef provider) create,
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
  AutoDisposeFutureProviderElement<Activity> createElement() {
    return _ActivityProviderElement(this);
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

String _$activityNotifier2Hash() => r'9e67c655d53a9f98c3b012a0534421385dde0339';

abstract class _$ActivityNotifier2
    extends BuildlessAutoDisposeAsyncNotifier<Activity> {
  late final String activityType;

  FutureOr<Activity> build(
    String activityType,
  );
}

/// See also [ActivityNotifier2].
@ProviderFor(ActivityNotifier2)
const activityNotifier2Provider = ActivityNotifier2Family();

/// See also [ActivityNotifier2].
class ActivityNotifier2Family extends Family<AsyncValue<Activity>> {
  /// See also [ActivityNotifier2].
  const ActivityNotifier2Family();

  /// See also [ActivityNotifier2].
  ActivityNotifier2Provider call(
    String activityType,
  ) {
    return ActivityNotifier2Provider(
      activityType,
    );
  }

  @override
  ActivityNotifier2Provider getProviderOverride(
    covariant ActivityNotifier2Provider provider,
  ) {
    return call(
      provider.activityType,
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
  String? get name => r'activityNotifier2Provider';
}

/// See also [ActivityNotifier2].
class ActivityNotifier2Provider
    extends AutoDisposeAsyncNotifierProviderImpl<ActivityNotifier2, Activity> {
  /// See also [ActivityNotifier2].
  ActivityNotifier2Provider(
    String activityType,
  ) : this._internal(
          () => ActivityNotifier2()..activityType = activityType,
          from: activityNotifier2Provider,
          name: r'activityNotifier2Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activityNotifier2Hash,
          dependencies: ActivityNotifier2Family._dependencies,
          allTransitiveDependencies:
              ActivityNotifier2Family._allTransitiveDependencies,
          activityType: activityType,
        );

  ActivityNotifier2Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.activityType,
  }) : super.internal();

  final String activityType;

  @override
  FutureOr<Activity> runNotifierBuild(
    covariant ActivityNotifier2 notifier,
  ) {
    return notifier.build(
      activityType,
    );
  }

  @override
  Override overrideWith(ActivityNotifier2 Function() create) {
    return ProviderOverride(
      origin: this,
      override: ActivityNotifier2Provider._internal(
        () => create()..activityType = activityType,
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
  AutoDisposeAsyncNotifierProviderElement<ActivityNotifier2, Activity>
      createElement() {
    return _ActivityNotifier2ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityNotifier2Provider &&
        other.activityType == activityType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, activityType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ActivityNotifier2Ref on AutoDisposeAsyncNotifierProviderRef<Activity> {
  /// The parameter `activityType` of this provider.
  String get activityType;
}

class _ActivityNotifier2ProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ActivityNotifier2, Activity>
    with ActivityNotifier2Ref {
  _ActivityNotifier2ProviderElement(super.provider);

  @override
  String get activityType => (origin as ActivityNotifier2Provider).activityType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
