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
class ExampleFamilyFamily extends Family<int> {
  /// Some comment
  ///
  /// Copied from [ExampleFamily].
  const ExampleFamilyFamily();

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
/// Copied from [ExampleFamily].
class ExampleFamilyProvider
    extends AutoDisposeNotifierProviderImpl<ExampleFamily, int> {
  /// Some comment
  ///
  /// Copied from [ExampleFamily].
  ExampleFamilyProvider({
    required this.a,
    this.b = '42',
  }) : super.internal(
          () => ExampleFamily()
            ..a = a
            ..b = b,
          from: exampleFamilyProvider,
          name: r'exampleFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exampleFamilyHash,
          dependencies: ExampleFamilyFamily._dependencies,
          allTransitiveDependencies:
              ExampleFamilyFamily._allTransitiveDependencies,
        );

  final int a;
  final String b;

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
  int runNotifierBuild(
    covariant ExampleFamily notifier,
  ) {
    return notifier.build(
      a: a,
      b: b,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
