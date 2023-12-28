// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_class_based_provider_to_functional.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exampleHash() => r'081776126bafed3e1583bba9c1fadef798215ad7';

/// Some comment
///
/// Copied from [Example].
@ProviderFor(Example)
final exampleProvider = AutoDisposeNotifierProvider<Example, int>.internal(
  Example.new,
  name: r'exampleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$exampleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Example = AutoDisposeNotifier<int>;
String _$exampleFamilyHash() => r'37d4a4fd66999562cd92051f91266270d5a1e5ea';

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

abstract class _$ExampleFamily extends BuildlessAutoDisposeNotifier<int> {
  late final int a;
  late final String b;

  int build({
    required int a,
    String b = '42',
  });
}

/// Some comment
///
/// Copied from [ExampleFamily].
@ProviderFor(ExampleFamily)
const exampleFamilyProvider = ExampleFamilyFamily();

/// Some comment
///
/// Copied from [ExampleFamily].
class ExampleFamilyFamily extends Family {
  /// Some comment
  ///
  /// Copied from [ExampleFamily].
  const ExampleFamilyFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exampleFamilyProvider';

  /// Some comment
  ///
  /// Copied from [ExampleFamily].
  ExampleFamilyProvider call({
    required int a,
    String b = '42',
  }) {
    return ExampleFamilyProvider(
      a: a,
      b: b,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(ExampleFamily Function() create) {
    return _$ExampleFamilyFamilyOverride(this, create);
  }

  @override
  String toString() => 'exampleFamilyProvider';
}

class _$ExampleFamilyFamilyOverride implements FamilyOverride {
  _$ExampleFamilyFamilyOverride(this.from, this.create);

  final ExampleFamily Function() create;

  @override
  final ExampleFamilyFamily from;

  @override
  _ExampleFamilyProviderElement createElement(
    ProviderContainer container,
    covariant ExampleFamilyProvider provider,
  ) {
    return provider._copyWith(create).createElement(container);
  }

  @override
  String toString() => 'exampleFamilyProvider.overrideWith(...)';
}

/// Some comment
///
/// Copied from [ExampleFamily].
class ExampleFamilyProvider
    extends AutoDisposeNotifierProviderImpl<ExampleFamily, int> {
  /// Some comment
  ///
  /// Copied from [ExampleFamily].
  ExampleFamilyProvider({
    required int a,
    String b = '42',
  }) : this._internal(
          () => ExampleFamily()
            ..a = a
            ..b = b,
          from: exampleFamilyProvider,
          name: r'exampleFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exampleFamilyHash,
          dependencies: null,
          allTransitiveDependencies: null,
          a: a,
          b: b,
        );

  ExampleFamilyProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.a,
    required this.b,
  }) : super.internal();

  final int a;
  final String b;

  @override
  int runNotifierBuild(
    covariant ExampleFamily notifier,
  ) {
    return notifier.build(
      a: a,
      b: b,
    );
  }

  @override
  Override overrideWith(ExampleFamily Function() create) {
    return ProviderOverride(
      origin: this,
      providerOverride: ExampleFamilyProvider._internal(
        () => create()
          ..a = a
          ..b = b,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        a: a,
        b: b,
      ),
    );
  }

  @override
  ({
    int a,
    String b,
  }) get argument {
    return (
      a: a,
      b: b,
    );
  }

  @override
  _ExampleFamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _ExampleFamilyProviderElement(this, container);
  }

  ExampleFamilyProvider _copyWith(
    ExampleFamily Function() create,
  ) {
    return ExampleFamilyProvider._internal(
      () => create()
        ..a = a
        ..b = b,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      a: a,
      b: b,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExampleFamilyProvider && other.a == a && other.b == b;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, a.hashCode);
    hash = _SystemHash.combine(hash, b.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String toString() => 'exampleFamilyProvider$argument';
}

mixin ExampleFamilyRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `a` of this provider.
  int get a;

  /// The parameter `b` of this provider.
  String get b;
}

class _ExampleFamilyProviderElement
    extends AutoDisposeNotifierProviderElement<ExampleFamily, int>
    with ExampleFamilyRef {
  _ExampleFamilyProviderElement(super.provider, super.container);

  @override
  int get a => (origin as ExampleFamilyProvider).a;
  @override
  String get b => (origin as ExampleFamilyProvider).b;
}

String _$genericHash() => r'0a3792d7b59723aebd92715eef2c74d2f267cbd2';

abstract class _$Generic<A, B> extends BuildlessAutoDisposeNotifier<int> {
  int build();
}

/// See also [Generic].
@ProviderFor(Generic)
const genericProvider = GenericFamily();

/// See also [Generic].
class GenericFamily extends Family {
  /// See also [Generic].
  const GenericFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'genericProvider';

  /// See also [Generic].
  GenericProvider<A, B> call<A, B>() {
    return GenericProvider<A, B>();
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(Generic Function() create) {
    return _$GenericFamilyOverride(this, create);
  }

  @override
  String toString() => 'genericProvider';
}

class _$GenericFamilyOverride implements FamilyOverride {
  _$GenericFamilyOverride(this.from, this.create);

  final Generic Function() create;

  @override
  final GenericFamily from;

  @override
  _GenericProviderElement createElement(
    ProviderContainer container,
    covariant GenericProvider provider,
  ) {
    return provider._copyWith(create).createElement(container);
  }

  @override
  String toString() => 'genericProvider.overrideWith(...)';
}

/// See also [Generic].
class GenericProvider<A, B>
    extends AutoDisposeNotifierProviderImpl<Generic<A, B>, int> {
  /// See also [Generic].
  GenericProvider()
      : this._internal(
          Generic<A, B>.new,
          from: genericProvider,
          name: r'genericProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericHash,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  GenericProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  int runNotifierBuild(
    covariant Generic<A, B> notifier,
  ) {
    return notifier.build();
  }

  @override
  Override overrideWith(Generic<A, B> Function() create) {
    return ProviderOverride(
      origin: this,
      providerOverride: GenericProvider<A, B>._internal(
        () => create(),
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
  _GenericProviderElement<A, B> createElement(
    ProviderContainer container,
  ) {
    return _GenericProviderElement(this, container);
  }

  GenericProvider _copyWith(
    Generic Function() create,
  ) {
    return GenericProvider._internal(
      () => create(),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenericProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, A.hashCode);
    hash = _SystemHash.combine(hash, B.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String toString() => 'genericProvider<$A,$B>$argument';
}

mixin GenericRef<A, B> on AutoDisposeNotifierProviderRef<int> {}

class _GenericProviderElement<A, B>
    extends AutoDisposeNotifierProviderElement<Generic<A, B>, int>
    with GenericRef<A, B> {
  _GenericProviderElement(super.provider, super.container);
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
