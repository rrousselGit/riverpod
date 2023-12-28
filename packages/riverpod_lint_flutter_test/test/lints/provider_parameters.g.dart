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

/// See also [generator].
@ProviderFor(generator)
const generatorProvider = GeneratorFamily();

/// See also [generator].
class GeneratorFamily extends Family {
  /// See also [generator].
  const GeneratorFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'generatorProvider';

  /// See also [generator].
  GeneratorProvider call({
    Object? value,
  }) {
    return GeneratorProvider(
      value: value,
    );
  }

  @visibleForOverriding
  @override
  GeneratorProvider getProviderOverride(
    covariant GeneratorProvider provider,
  ) {
    return call(
      value: provider.value,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(int Function(GeneratorRef ref) create) {
    return _$GeneratorFamilyOverride(this, create);
  }

  @override
  String toString() => 'generatorProvider';
}

class _$GeneratorFamilyOverride implements FamilyOverride {
  _$GeneratorFamilyOverride(this.from, this.create);

  final int Function(GeneratorRef ref) create;

  @override
  final GeneratorFamily from;

  @override
  GeneratorProvider getProviderOverride(
    covariant GeneratorProvider provider,
  ) {
    return provider._copyWith(create);
  }

  @override
  String toString() => 'generatorProvider.overrideWith($create)';
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
    super.create, {
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
    int Function(GeneratorRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      providerOverride: GeneratorProvider._internal(
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
  ({
    Object? value,
  }) get argument {
    return (value: value,);
  }

  @override
  ProviderElement<int> createElement(
    ProviderContainer container,
  ) {
    return _GeneratorProviderElement(this, container);
  }

  GeneratorProvider _copyWith(
    int Function(GeneratorRef ref) create,
  ) {
    return GeneratorProvider._internal(
      (ref) => create(ref as GeneratorRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      value: value,
    );
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

  @override
  String toString() => 'generatorProvider$argument';
}

mixin GeneratorRef on ProviderRef<int> {
  /// The parameter `value` of this provider.
  Object? get value;
}

class _GeneratorProviderElement extends ProviderElement<int> with GeneratorRef {
  _GeneratorProviderElement(super.provider, super.container);

  @override
  Object? get value => (origin as GeneratorProvider).value;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
