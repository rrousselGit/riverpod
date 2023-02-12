// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_parameters.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$generatorHash() => r'e76b8050c3a272ecef1985e4dc7dfe5df3270f2f';

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

typedef GeneratorRef = ProviderRef<int>;

/// See also [generator].
@ProviderFor(generator)
const generatorProvider = GeneratorFamily();

/// See also [generator].
class GeneratorFamily extends Family<int> {
  /// See also [generator].
  const GeneratorFamily();

  /// See also [generator].
  GeneratorProvider call({
    Object? value,
  }) {
    return GeneratorProvider(
      value: value,
    );
  }

  @override
  GeneratorProvider getProviderOverride(
    covariant GeneratorProvider provider,
  ) {
    return call(
      value: provider.value,
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
  String? get name => r'generatorProvider';
}

/// See also [generator].
class GeneratorProvider extends Provider<int> {
  /// See also [generator].
  GeneratorProvider({
    this.value,
  }) : super.internal(
          (ref) => generator(
            ref,
            value: value,
          ),
          from: generatorProvider,
          name: r'generatorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generatorHash,
          dependencies: GeneratorFamily._dependencies,
          allTransitiveDependencies: GeneratorFamily._allTransitiveDependencies,
        );

  final Object? value;

  @override
  bool operator ==(Object other) {
    return other is GeneratorProvider && other.value == value;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, value.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
