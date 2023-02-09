// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_stateful_provider_to_stateless.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$statefulHash() => r'97a80741e820dc6e31ab7abf4b116c22dae0590b';

/// Some comment
///
/// Copied from [Stateful].
@ProviderFor(Stateful)
final statefulProvider = AutoDisposeNotifierProvider<Stateful, int>.internal(
  Stateful.new,
  name: r'statefulProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$statefulHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Stateful = AutoDisposeNotifier<int>;
String _$statefulFamilyHash() => r'8df1b3aa9081e66af197b7f69945cc81e3ddf82d';

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

abstract class _$StatefulFamily extends BuildlessAutoDisposeNotifier<int> {
  late final int a;
  late final String b;

  int build({
    required int a,
    String b = '42',
  });
}

/// Some comment
///
/// Copied from [StatefulFamily].
@ProviderFor(StatefulFamily)
const statefulFamilyProvider = StatefulFamilyFamily();

/// Some comment
///
/// Copied from [StatefulFamily].
class StatefulFamilyFamily extends Family<int> {
  /// Some comment
  ///
  /// Copied from [StatefulFamily].
  const StatefulFamilyFamily();

  /// Some comment
  ///
  /// Copied from [StatefulFamily].
  StatefulFamilyProvider call({
    required int a,
    String b = '42',
  }) {
    return StatefulFamilyProvider(
      a: a,
      b: b,
    );
  }

  @override
  StatefulFamilyProvider getProviderOverride(
    covariant StatefulFamilyProvider provider,
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
  String? get name => r'statefulFamilyProvider';
}

/// Some comment
///
/// Copied from [StatefulFamily].
class StatefulFamilyProvider
    extends AutoDisposeNotifierProviderImpl<StatefulFamily, int> {
  /// Some comment
  ///
  /// Copied from [StatefulFamily].
  StatefulFamilyProvider({
    required this.a,
    this.b = '42',
  }) : super.internal(
          () => StatefulFamily()
            ..a = a
            ..b = b,
          from: statefulFamilyProvider,
          name: r'statefulFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$statefulFamilyHash,
          dependencies: StatefulFamilyFamily._dependencies,
          allTransitiveDependencies:
              StatefulFamilyFamily._allTransitiveDependencies,
        );

  final int a;
  final String b;

  @override
  bool operator ==(Object other) {
    return other is StatefulFamilyProvider && other.a == a && other.b == b;
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
    covariant StatefulFamily notifier,
  ) {
    return notifier.build(
      a: a,
      b: b,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
