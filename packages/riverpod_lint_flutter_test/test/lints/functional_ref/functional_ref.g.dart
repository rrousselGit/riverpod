// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'functional_ref.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$namelessHash() => r'1a2aa61445a64c65301051820b159c5998195606';

/// See also [nameless].
@ProviderFor(nameless)
final namelessProvider = AutoDisposeProvider<int>.internal(
  nameless,
  name: r'namelessProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$namelessHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NamelessRef = AutoDisposeProviderRef<int>;
String _$scopedHash() => r'590f1a203323105e732397a2616fbd7dac65f0cc';

/// See also [scoped].
@ProviderFor(scoped)
final scopedProvider = AutoDisposeProvider<int>.internal(
  (_) => throw UnsupportedError(
    'The provider "scopedProvider" is expected to get overridden/scoped, '
    'but was accessed without an override.',
  ),
  name: r'scopedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scopedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ScopedRef = AutoDisposeProviderRef<int>;
String _$genericsHash() => r'b5813cf6a00581bafea48d8ab66f7d5468fff0e4';

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

/// See also [generics].
@ProviderFor(generics)
const genericsProvider = GenericsFamily();

/// See also [generics].
class GenericsFamily extends Family {
  /// See also [generics].
  const GenericsFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'genericsProvider';

  /// See also [generics].
  GenericsProvider<A, B> call<A extends num, B>() {
    return GenericsProvider<A, B>();
  }

  @visibleForOverriding
  @override
  GenericsProvider<num, Object?> getProviderOverride(
    covariant GenericsProvider<num, Object?> provider,
  ) {
    return call();
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      int Function<A extends num, B>(GenericsRef ref) create) {
    return _$GenericsFamilyOverride(this, create);
  }
}

class _$GenericsFamilyOverride implements FamilyOverride {
  _$GenericsFamilyOverride(this.overriddenFamily, this.create);

  final int Function<A extends num, B>(GenericsRef ref) create;

  @override
  final GenericsFamily overriddenFamily;

  @override
  GenericsProvider getProviderOverride(
    covariant GenericsProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [generics].
class GenericsProvider<A extends num, B> extends AutoDisposeProvider<int> {
  /// See also [generics].
  GenericsProvider()
      : this._internal(
          (ref) => generics<A, B>(
            ref as GenericsRef<A, B>,
          ),
          from: genericsProvider,
          name: r'genericsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericsHash,
          dependencies: GenericsFamily._dependencies,
          allTransitiveDependencies: GenericsFamily._allTransitiveDependencies,
        );

  GenericsProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  Override overrideWith(
    int Function(GenericsRef<A, B> ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GenericsProvider<A, B>._internal(
        (ref) => create(ref as GenericsRef<A, B>),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }

  @override
  () get argument {
    return ();
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _GenericsProviderElement(this);
  }

  GenericsProvider _copyWith(
    int Function<A extends num, B>(GenericsRef ref) create,
  ) {
    return GenericsProvider._internal(
      (ref) => create(ref as GenericsRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenericsProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, A.hashCode);
    hash = _SystemHash.combine(hash, B.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GenericsRef<A extends num, B> on AutoDisposeProviderRef<int> {}

class _GenericsProviderElement<A extends num, B>
    extends AutoDisposeProviderElement<int> with GenericsRef<A, B> {
  _GenericsProviderElement(super.provider);
}

String _$noGenericsHash() => r'449264e25990bc14ad811c0940117c8cde4d730a';

/// See also [noGenerics].
@ProviderFor(noGenerics)
const noGenericsProvider = NoGenericsFamily();

/// See also [noGenerics].
class NoGenericsFamily extends Family {
  /// See also [noGenerics].
  const NoGenericsFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'noGenericsProvider';

  /// See also [noGenerics].
  NoGenericsProvider<A, B> call<A extends num, B>() {
    return NoGenericsProvider<A, B>();
  }

  @visibleForOverriding
  @override
  NoGenericsProvider<num, Object?> getProviderOverride(
    covariant NoGenericsProvider<num, Object?> provider,
  ) {
    return call();
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      int Function<A extends num, B>(NoGenericsRef ref) create) {
    return _$NoGenericsFamilyOverride(this, create);
  }
}

class _$NoGenericsFamilyOverride implements FamilyOverride {
  _$NoGenericsFamilyOverride(this.overriddenFamily, this.create);

  final int Function<A extends num, B>(NoGenericsRef ref) create;

  @override
  final NoGenericsFamily overriddenFamily;

  @override
  NoGenericsProvider getProviderOverride(
    covariant NoGenericsProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [noGenerics].
class NoGenericsProvider<A extends num, B> extends AutoDisposeProvider<int> {
  /// See also [noGenerics].
  NoGenericsProvider()
      : this._internal(
          (ref) => noGenerics<A, B>(
            ref as NoGenericsRef<A, B>,
          ),
          from: noGenericsProvider,
          name: r'noGenericsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noGenericsHash,
          dependencies: NoGenericsFamily._dependencies,
          allTransitiveDependencies:
              NoGenericsFamily._allTransitiveDependencies,
        );

  NoGenericsProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  Override overrideWith(
    int Function(NoGenericsRef<A, B> ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NoGenericsProvider<A, B>._internal(
        (ref) => create(ref as NoGenericsRef<A, B>),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }

  @override
  () get argument {
    return ();
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _NoGenericsProviderElement(this);
  }

  NoGenericsProvider _copyWith(
    int Function<A extends num, B>(NoGenericsRef ref) create,
  ) {
    return NoGenericsProvider._internal(
      (ref) => create(ref as NoGenericsRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NoGenericsProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, A.hashCode);
    hash = _SystemHash.combine(hash, B.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoGenericsRef<A extends num, B> on AutoDisposeProviderRef<int> {}

class _NoGenericsProviderElement<A extends num, B>
    extends AutoDisposeProviderElement<int> with NoGenericsRef<A, B> {
  _NoGenericsProviderElement(super.provider);
}

String _$missingGenericsHash() => r'7d8bc49e4f1e466260fbf6a61a3f9e62b4aef28f';

/// See also [missingGenerics].
@ProviderFor(missingGenerics)
const missingGenericsProvider = MissingGenericsFamily();

/// See also [missingGenerics].
class MissingGenericsFamily extends Family {
  /// See also [missingGenerics].
  const MissingGenericsFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'missingGenericsProvider';

  /// See also [missingGenerics].
  MissingGenericsProvider<A, B> call<A, B>() {
    return MissingGenericsProvider<A, B>();
  }

  @visibleForOverriding
  @override
  MissingGenericsProvider<Object?, Object?> getProviderOverride(
    covariant MissingGenericsProvider<Object?, Object?> provider,
  ) {
    return call();
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(int Function<A, B>(MissingGenericsRef ref) create) {
    return _$MissingGenericsFamilyOverride(this, create);
  }
}

class _$MissingGenericsFamilyOverride implements FamilyOverride {
  _$MissingGenericsFamilyOverride(this.overriddenFamily, this.create);

  final int Function<A, B>(MissingGenericsRef ref) create;

  @override
  final MissingGenericsFamily overriddenFamily;

  @override
  MissingGenericsProvider getProviderOverride(
    covariant MissingGenericsProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [missingGenerics].
class MissingGenericsProvider<A, B> extends AutoDisposeProvider<int> {
  /// See also [missingGenerics].
  MissingGenericsProvider()
      : this._internal(
          (ref) => missingGenerics<A, B>(
            ref as MissingGenericsRef<A, B>,
          ),
          from: missingGenericsProvider,
          name: r'missingGenericsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$missingGenericsHash,
          dependencies: MissingGenericsFamily._dependencies,
          allTransitiveDependencies:
              MissingGenericsFamily._allTransitiveDependencies,
        );

  MissingGenericsProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  Override overrideWith(
    int Function(MissingGenericsRef<A, B> ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MissingGenericsProvider<A, B>._internal(
        (ref) => create(ref as MissingGenericsRef<A, B>),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }

  @override
  () get argument {
    return ();
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _MissingGenericsProviderElement(this);
  }

  MissingGenericsProvider _copyWith(
    int Function<A, B>(MissingGenericsRef ref) create,
  ) {
    return MissingGenericsProvider._internal(
      (ref) => create(ref as MissingGenericsRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MissingGenericsProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, A.hashCode);
    hash = _SystemHash.combine(hash, B.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MissingGenericsRef<A, B> on AutoDisposeProviderRef<int> {}

class _MissingGenericsProviderElement<A, B>
    extends AutoDisposeProviderElement<int> with MissingGenericsRef<A, B> {
  _MissingGenericsProviderElement(super.provider);
}

String _$wrongOrderHash() => r'6732863e85b220c07f82c2d13be15c1e6f08192d';

/// See also [wrongOrder].
@ProviderFor(wrongOrder)
const wrongOrderProvider = WrongOrderFamily();

/// See also [wrongOrder].
class WrongOrderFamily extends Family {
  /// See also [wrongOrder].
  const WrongOrderFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'wrongOrderProvider';

  /// See also [wrongOrder].
  WrongOrderProvider<B, A> call<B, A>() {
    return WrongOrderProvider<B, A>();
  }

  @visibleForOverriding
  @override
  WrongOrderProvider<Object?, Object?> getProviderOverride(
    covariant WrongOrderProvider<Object?, Object?> provider,
  ) {
    return call();
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(int Function<B, A>(WrongOrderRef ref) create) {
    return _$WrongOrderFamilyOverride(this, create);
  }
}

class _$WrongOrderFamilyOverride implements FamilyOverride {
  _$WrongOrderFamilyOverride(this.overriddenFamily, this.create);

  final int Function<B, A>(WrongOrderRef ref) create;

  @override
  final WrongOrderFamily overriddenFamily;

  @override
  WrongOrderProvider getProviderOverride(
    covariant WrongOrderProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [wrongOrder].
class WrongOrderProvider<B, A> extends AutoDisposeProvider<int> {
  /// See also [wrongOrder].
  WrongOrderProvider()
      : this._internal(
          (ref) => wrongOrder<B, A>(
            ref as WrongOrderRef<B, A>,
          ),
          from: wrongOrderProvider,
          name: r'wrongOrderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$wrongOrderHash,
          dependencies: WrongOrderFamily._dependencies,
          allTransitiveDependencies:
              WrongOrderFamily._allTransitiveDependencies,
        );

  WrongOrderProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  Override overrideWith(
    int Function(WrongOrderRef<B, A> ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WrongOrderProvider<B, A>._internal(
        (ref) => create(ref as WrongOrderRef<B, A>),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }

  @override
  () get argument {
    return ();
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _WrongOrderProviderElement(this);
  }

  WrongOrderProvider _copyWith(
    int Function<B, A>(WrongOrderRef ref) create,
  ) {
    return WrongOrderProvider._internal(
      (ref) => create(ref as WrongOrderRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WrongOrderProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, B.hashCode);
    hash = _SystemHash.combine(hash, A.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WrongOrderRef<B, A> on AutoDisposeProviderRef<int> {}

class _WrongOrderProviderElement<B, A> extends AutoDisposeProviderElement<int>
    with WrongOrderRef<B, A> {
  _WrongOrderProviderElement(super.provider);
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
