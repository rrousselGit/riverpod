// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_parameters.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$generatorHash() => r'd7d1733f8884b6702f363ddb178ae57797d0034f';

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
    Object? value,
  }) : this._internal(
          (ref) => generator(
            ref as GeneratorRef,
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
          value: value,
        );

  GeneratorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.value,
  }) : super.internal();

  final Object? value;

  @override
  Override overrideWith(
    int Function(GeneratorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GeneratorProvider._internal(
        (ref) => create(ref as GeneratorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        value: value,
      ),
    );
  }

  @override
  ProviderElement<int> createElement() {
    return _GeneratorProviderElement(this);
  }

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GeneratorRef on ProviderRef<int> {
  /// The parameter `value` of this provider.
  Object? get value;
}

class _GeneratorProviderElement extends ProviderElement<int> with GeneratorRef {
  _GeneratorProviderElement(super.provider);

  @override
  Object? get value => (origin as GeneratorProvider).value;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
