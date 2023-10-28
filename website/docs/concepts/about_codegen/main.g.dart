// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchUserHash() => r'ff427bbb4130a8a6994fa623ae70997f7b0f6bdb';

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

/// See also [fetchUser].
@ProviderFor(fetchUser)
const fetchUserProvider = FetchUserFamily();

/// See also [fetchUser].
class FetchUserFamily extends Family {
  /// See also [fetchUser].
  const FetchUserFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchUserProvider';

  /// See also [fetchUser].
  FetchUserProvider call({
    required int userId,
  }) {
    return FetchUserProvider(
      userId: userId,
    );
  }

  @visibleForOverriding
  @override
  FetchUserProvider getProviderOverride(
    covariant FetchUserProvider provider,
  ) {
    return call(
      userId: provider.userId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<User> Function(FetchUserRef ref) create) {
    return _$FetchUserFamilyOverride(this, create);
  }
}

class _$FetchUserFamilyOverride implements FamilyOverride {
  _$FetchUserFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<User> Function(FetchUserRef ref) create;

  @override
  final FetchUserFamily overriddenFamily;

  @override
  FetchUserProvider getProviderOverride(
    covariant FetchUserProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [fetchUser].
class FetchUserProvider extends AutoDisposeFutureProvider<User> {
  /// See also [fetchUser].
  FetchUserProvider({
    required int userId,
  }) : this._internal(
          (ref) => fetchUser(
            ref as FetchUserRef,
            userId: userId,
          ),
          from: fetchUserProvider,
          name: r'fetchUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUserHash,
          dependencies: FetchUserFamily._dependencies,
          allTransitiveDependencies: FetchUserFamily._allTransitiveDependencies,
          userId: userId,
        );

  FetchUserProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  Override overrideWith(
    FutureOr<User> Function(FetchUserRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUserProvider._internal(
        (ref) => create(ref as FetchUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  ({
    int userId,
  }) get argument {
    return (userId: userId,);
  }

  @override
  AutoDisposeFutureProviderElement<User> createElement() {
    return _FetchUserProviderElement(this);
  }

  FetchUserProvider _copyWith(
    FutureOr<User> Function(FetchUserRef ref) create,
  ) {
    return FetchUserProvider._internal(
      (ref) => create(ref as FetchUserRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      userId: userId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchUserRef on AutoDisposeFutureProviderRef<User> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _FetchUserProviderElement extends AutoDisposeFutureProviderElement<User>
    with FetchUserRef {
  _FetchUserProviderElement(super.provider);

  @override
  int get userId => (origin as FetchUserProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
