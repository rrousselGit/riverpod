// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$randomHash() => r'517b12aad4df7b31f8872b89af74e7880377b2ea';

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

/// See also [random].
@ProviderFor(random)
const randomProvider = RandomFamily();

/// See also [random].
class RandomFamily extends Family<int> {
  /// See also [random].
  const RandomFamily();

  /// See also [random].
  RandomProvider call({
    required int seed,
    required int max,
  }) {
    return RandomProvider(
      seed: seed,
      max: max,
    );
  }

  @override
  RandomProvider getProviderOverride(
    covariant RandomProvider provider,
  ) {
    return call(
      seed: provider.seed,
      max: provider.max,
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
  String? get name => r'randomProvider';
}

/// See also [random].
class RandomProvider extends AutoDisposeProvider<int> {
  /// See also [random].
  RandomProvider({
    required int seed,
    required int max,
  }) : this._internal(
          (ref) => random(
            ref as RandomRef,
            seed: seed,
            max: max,
          ),
          from: randomProvider,
          name: r'randomProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$randomHash,
          dependencies: RandomFamily._dependencies,
          allTransitiveDependencies: RandomFamily._allTransitiveDependencies,
          seed: seed,
          max: max,
        );

  RandomProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.seed,
    required this.max,
  }) : super.internal();

  final int seed;
  final int max;

  @override
  Override overrideWith(
    int Function(RandomRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RandomProvider._internal(
        (ref) => create(ref as RandomRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        seed: seed,
        max: max,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _RandomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RandomProvider && other.seed == seed && other.max == max;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, seed.hashCode);
    hash = _SystemHash.combine(hash, max.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RandomRef on AutoDisposeProviderRef<int> {
  /// The parameter `seed` of this provider.
  int get seed;

  /// The parameter `max` of this provider.
  int get max;
}

class _RandomProviderElement extends AutoDisposeProviderElement<int>
    with RandomRef {
  _RandomProviderElement(super.provider);

  @override
  int get seed => (origin as RandomProvider).seed;
  @override
  int get max => (origin as RandomProvider).max;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
