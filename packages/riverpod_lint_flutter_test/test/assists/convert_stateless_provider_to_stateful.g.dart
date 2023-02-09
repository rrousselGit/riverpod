// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_stateless_provider_to_stateful.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$statelessHash() => r'be6619f112495a6ba3b6f76af9a8324058f6387a';

/// Some comment
///
/// Copied from [stateless].
@ProviderFor(stateless)
final statelessProvider = AutoDisposeProvider<int>.internal(
  stateless,
  name: r'statelessProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$statelessHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StatelessRef = AutoDisposeProviderRef<int>;
String _$statelessFamilyHash() => r'fdbbd6ea193e742d4d740c3f212eba09c489c3b2';

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

typedef StatelessFamilyRef = AutoDisposeProviderRef<int>;

/// Some comment
///
/// Copied from [statelessFamily].
@ProviderFor(statelessFamily)
const statelessFamilyProvider = StatelessFamilyFamily();

/// Some comment
///
/// Copied from [statelessFamily].
class StatelessFamilyFamily extends Family<int> {
  /// Some comment
  ///
  /// Copied from [statelessFamily].
  const StatelessFamilyFamily();

  /// Some comment
  ///
  /// Copied from [statelessFamily].
  StatelessFamilyProvider call({
    required int a,
    String b = '42',
  }) {
    return StatelessFamilyProvider(
      a: a,
      b: b,
    );
  }

  @override
  StatelessFamilyProvider getProviderOverride(
    covariant StatelessFamilyProvider provider,
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
  String? get name => r'statelessFamilyProvider';
}

/// Some comment
///
/// Copied from [statelessFamily].
class StatelessFamilyProvider extends AutoDisposeProvider<int> {
  /// Some comment
  ///
  /// Copied from [statelessFamily].
  StatelessFamilyProvider({
    required this.a,
    this.b = '42',
  }) : super.internal(
          (ref) => statelessFamily(
            ref,
            a: a,
            b: b,
          ),
          from: statelessFamilyProvider,
          name: r'statelessFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$statelessFamilyHash,
          dependencies: StatelessFamilyFamily._dependencies,
          allTransitiveDependencies:
              StatelessFamilyFamily._allTransitiveDependencies,
        );

  final int a;
  final String b;

  @override
  bool operator ==(Object other) {
    return other is StatelessFamilyProvider && other.a == a && other.b == b;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, a.hashCode);
    hash = _SystemHash.combine(hash, b.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
