// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_function_based_provider_to_class_based.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$functionBasedHash() => r'0f4933f7560dc99d8c5fae5edb62d4354317a60d';

/// Some comment
///
/// Copied from [functionBased].
@ProviderFor(functionBased)
final functionBasedProvider = AutoDisposeProvider<int>.internal(
  functionBased,
  name: r'functionBasedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$functionBasedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FunctionBasedRef = AutoDisposeProviderRef<int>;
String _$functionBasedFamilyHash() =>
    r'ca48619302e925bc5723896e3f551a006eaf434c';

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

typedef FunctionBasedFamilyRef = AutoDisposeProviderRef<int>;

/// Some comment
///
/// Copied from [functionBasedFamily].
@ProviderFor(functionBasedFamily)
const functionBasedFamilyProvider = FunctionBasedFamilyFamily();

/// Some comment
///
/// Copied from [functionBasedFamily].
class FunctionBasedFamilyFamily extends Family<int> {
  /// Some comment
  ///
  /// Copied from [functionBasedFamily].
  const FunctionBasedFamilyFamily();

  /// Some comment
  ///
  /// Copied from [functionBasedFamily].
  FunctionBasedFamilyProvider call({
    required int a,
    String b = '42',
  }) {
    return FunctionBasedFamilyProvider(
      a: a,
      b: b,
    );
  }

  @override
  FunctionBasedFamilyProvider getProviderOverride(
    covariant FunctionBasedFamilyProvider provider,
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
  String? get name => r'functionBasedFamilyProvider';
}

/// Some comment
///
/// Copied from [functionBasedFamily].
class FunctionBasedFamilyProvider extends AutoDisposeProvider<int> {
  /// Some comment
  ///
  /// Copied from [functionBasedFamily].
  FunctionBasedFamilyProvider({
    required this.a,
    this.b = '42',
  }) : super.internal(
          (ref) => functionBasedFamily(
            ref,
            a: a,
            b: b,
          ),
          from: functionBasedFamilyProvider,
          name: r'functionBasedFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$functionBasedFamilyHash,
          dependencies: FunctionBasedFamilyFamily._dependencies,
          allTransitiveDependencies:
              FunctionBasedFamilyFamily._allTransitiveDependencies,
        );

  final int a;
  final String b;

  @override
  bool operator ==(Object other) {
    return other is FunctionBasedFamilyProvider && other.a == a && other.b == b;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, a.hashCode);
    hash = _SystemHash.combine(hash, b.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
