// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_class_based_provider_to_function_based.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$classBasedHash() => r'27c425a18f7602488054c7bbe3c3b570f614761c';

/// Some comment
///
/// Copied from [ClassBased].
@ProviderFor(ClassBased)
final classBasedProvider =
    AutoDisposeNotifierProvider<ClassBased, int>.internal(
  ClassBased.new,
  name: r'classBasedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$classBasedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ClassBased = AutoDisposeNotifier<int>;
String _$classBasedFamilyHash() => r'00f758cf96448ab7c34735222189d1add9ff7254';

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

abstract class _$ClassBasedFamily extends BuildlessAutoDisposeNotifier<int> {
  late final int a;
  late final String b;

  int build({
    required int a,
    String b = '42',
  });
}

/// Some comment
///
/// Copied from [ClassBasedFamily].
@ProviderFor(ClassBasedFamily)
const classBasedFamilyProvider = ClassBasedFamilyFamily();

/// Some comment
///
/// Copied from [ClassBasedFamily].
class ClassBasedFamilyFamily extends Family<int> {
  /// Some comment
  ///
  /// Copied from [ClassBasedFamily].
  const ClassBasedFamilyFamily();

  /// Some comment
  ///
  /// Copied from [ClassBasedFamily].
  ClassBasedFamilyProvider call({
    required int a,
    String b = '42',
  }) {
    return ClassBasedFamilyProvider(
      a: a,
      b: b,
    );
  }

  @override
  ClassBasedFamilyProvider getProviderOverride(
    covariant ClassBasedFamilyProvider provider,
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
  String? get name => r'classBasedFamilyProvider';
}

/// Some comment
///
/// Copied from [ClassBasedFamily].
class ClassBasedFamilyProvider
    extends AutoDisposeNotifierProviderImpl<ClassBasedFamily, int> {
  /// Some comment
  ///
  /// Copied from [ClassBasedFamily].
  ClassBasedFamilyProvider({
    required this.a,
    this.b = '42',
  }) : super.internal(
          () => ClassBasedFamily()
            ..a = a
            ..b = b,
          from: classBasedFamilyProvider,
          name: r'classBasedFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$classBasedFamilyHash,
          dependencies: ClassBasedFamilyFamily._dependencies,
          allTransitiveDependencies:
              ClassBasedFamilyFamily._allTransitiveDependencies,
        );

  final int a;
  final String b;

  @override
  bool operator ==(Object other) {
    return other is ClassBasedFamilyProvider && other.a == a && other.b == b;
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
    covariant ClassBasedFamily notifier,
  ) {
    return notifier.build(
      a: a,
      b: b,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
