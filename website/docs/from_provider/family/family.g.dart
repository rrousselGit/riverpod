// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

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

typedef RandomRef = AutoDisposeProviderRef<int>;

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
    required this.seed,
    required this.max,
  }) : super.internal(
          (ref) => random(
            ref,
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
        );

  final int seed;
  final int max;

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
