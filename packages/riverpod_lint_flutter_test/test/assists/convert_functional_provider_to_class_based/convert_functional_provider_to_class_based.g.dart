// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_functional_provider_to_class_based.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exampleHash() => r'638d7db2be22eaad0f51ea0b3ae38e0483d43725';

/// Some comment
///
/// Copied from [example].
@ProviderFor(example)
final exampleProvider = AutoDisposeProvider<int>.internal(
  example,
  name: r'exampleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$exampleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ExampleRef = AutoDisposeProviderRef<int>;
String _$exampleFamilyHash() => r'f5547d3d88c42b135db5efea7dfaa542b3db9cc1';

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

/// Some comment
///
/// Copied from [exampleFamily].
@ProviderFor(exampleFamily)
const exampleFamilyProvider = ExampleFamilyFamily();

/// Some comment
///
/// Copied from [exampleFamily].
class ExampleFamilyFamily extends Family<int> {
  /// Some comment
  ///
  /// Copied from [exampleFamily].
  const ExampleFamilyFamily();

  /// Some comment
  ///
  /// Copied from [exampleFamily].
  ExampleFamilyProvider call({
    required int a,
    String b = '42',
  }) {
    return ExampleFamilyProvider(
      a: a,
      b: b,
    );
  }

  @override
  ExampleFamilyProvider getProviderOverride(
    covariant ExampleFamilyProvider provider,
  ) {
    return call(
      a: provider.a,
      b: provider.b,
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
  String? get name => r'exampleFamilyProvider';
}

/// Some comment
///
/// Copied from [exampleFamily].
class ExampleFamilyProvider extends AutoDisposeProvider<int> {
  /// Some comment
  ///
  /// Copied from [exampleFamily].
  ExampleFamilyProvider({
    required int a,
    String b = '42',
  }) : this._internal(
          (ref) => exampleFamily(
            ref as ExampleFamilyRef,
            a: a,
            b: b,
          ),
          from: exampleFamilyProvider,
          name: r'exampleFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exampleFamilyHash,
          dependencies: ExampleFamilyFamily._dependencies,
          allTransitiveDependencies:
              ExampleFamilyFamily._allTransitiveDependencies,
          a: a,
          b: b,
        );

  ExampleFamilyProvider._internal(
    super._createNotifier, {
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
  Override overrideWith(
    int Function(ExampleFamilyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExampleFamilyProvider._internal(
        (ref) => create(ref as ExampleFamilyRef),
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
  AutoDisposeProviderElement<int> createElement() {
    return _ExampleFamilyProviderElement(this);
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
}

mixin ExampleFamilyRef on AutoDisposeProviderRef<int> {
  /// The parameter `a` of this provider.
  int get a;

  /// The parameter `b` of this provider.
  String get b;
}

class _ExampleFamilyProviderElement extends AutoDisposeProviderElement<int>
    with ExampleFamilyRef {
  _ExampleFamilyProviderElement(super.provider);

  @override
  int get a => (origin as ExampleFamilyProvider).a;
  @override
  String get b => (origin as ExampleFamilyProvider).b;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
