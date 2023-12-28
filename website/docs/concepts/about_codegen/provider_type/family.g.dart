// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exampleHash() => r'c4f5a651a55bcf34b0c92d98d77436844cbdc097';

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

/// See also [example].
@ProviderFor(example)
const exampleProvider = ExampleFamily();

/// See also [example].
class ExampleFamily extends Family {
  /// See also [example].
  const ExampleFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exampleProvider';

  /// See also [example].
  ExampleProvider call(
    int param,
  ) {
    return ExampleProvider(
      param,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(String Function(ExampleRef ref) create) {
    return _$ExampleFamilyOverride(this, create);
  }

  @override
  String toString() => 'exampleProvider';
}

class _$ExampleFamilyOverride implements FamilyOverride {
  _$ExampleFamilyOverride(this.from, this.create);

  final String Function(ExampleRef ref) create;

  @override
  final ExampleFamily from;

  @override
  _ExampleProviderElement createElement(
    ProviderContainer container,
    covariant ExampleProvider provider,
  ) {
    return provider._copyWith(create).createElement(container);
  }

  @override
  String toString() => 'exampleProvider.overrideWith(...)';
}

/// See also [example].
class ExampleProvider extends AutoDisposeProvider<String> {
  /// See also [example].
  ExampleProvider(
    int param,
  ) : this._internal(
          (ref) => example(
            ref as ExampleRef,
            param,
          ),
          from: exampleProvider,
          name: r'exampleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exampleHash,
          dependencies: null,
          allTransitiveDependencies: null,
          param: param,
        );

  ExampleProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.param,
  }) : super.internal();

  final int param;

  @override
  Override overrideWith(
    String Function(ExampleRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      providerOverride: ExampleProvider._internal(
        (ref) => create(ref as ExampleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        param: param,
      ),
    );
  }

  @override
  (int,) get argument {
    return (param,);
  }

  @override
  _ExampleProviderElement createElement(
    ProviderContainer container,
  ) {
    return _ExampleProviderElement(this, container);
  }

  ExampleProvider _copyWith(
    String Function(ExampleRef ref) create,
  ) {
    return ExampleProvider._internal(
      (ref) => create(ref as ExampleRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      param: param,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExampleProvider && other.param == param;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, param.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String toString() => 'exampleProvider$argument';
}

mixin ExampleRef on AutoDisposeProviderRef<String> {
  /// The parameter `param` of this provider.
  int get param;
}

class _ExampleProviderElement extends AutoDisposeProviderElement<String>
    with ExampleRef {
  _ExampleProviderElement(super.provider, super.container);

  @override
  int get param => (origin as ExampleProvider).param;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
