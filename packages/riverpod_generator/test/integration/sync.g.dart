// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$publicHash() => r'138be35943899793ab085e711fe3f3d22696a3ba';

/// This is some documentation
///
/// Copied from [public].
@ProviderFor(public)
final publicProvider = AutoDisposeProvider<String>.internal(
  public,
  name: r'publicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PublicRef = AutoDisposeProviderRef<String>;
String _$supports$inNamesHash() => r'cbf929802fcbd0aa949ad72743d096fb3ef5f28f';

/// See also [supports$inNames].
@ProviderFor(supports$inNames)
final supports$inNamesProvider = AutoDisposeProvider<String>.internal(
  supports$inNames,
  name: r'supports$inNamesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supports$inNamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef Supports$inNamesRef = AutoDisposeProviderRef<String>;
String _$familyHash() => r'14d1ee238ca608d547630d0e222ef4c5866e9e61';

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

typedef FamilyRef = AutoDisposeProviderRef<String>;

/// This is some documentation
///
/// Copied from [family].
@ProviderFor(family)
const familyProvider = FamilyFamily();

/// This is some documentation
///
/// Copied from [family].
class FamilyFamily extends Family<String> {
  /// This is some documentation
  ///
  /// Copied from [family].
  const FamilyFamily();

  /// This is some documentation
  ///
  /// Copied from [family].
  FamilyProvider call(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) {
    return FamilyProvider(
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
  }

  @override
  FamilyProvider getProviderOverride(
    covariant FamilyProvider provider,
  ) {
    return call(
      provider.first,
      second: provider.second,
      third: provider.third,
      fourth: provider.fourth,
      fifth: provider.fifth,
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
  String? get name => r'familyProvider';
}

/// This is some documentation
///
/// Copied from [family].
class FamilyProvider extends AutoDisposeProvider<String> {
  /// This is some documentation
  ///
  /// Copied from [family].
  FamilyProvider(
    this.first, {
    this.second,
    required this.third,
    this.fourth = true,
    this.fifth,
  }) : super.internal(
          (ref) => family(
            ref,
            first,
            second: second,
            third: third,
            fourth: fourth,
            fifth: fifth,
          ),
          from: familyProvider,
          name: r'familyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyHash,
          dependencies: FamilyFamily._dependencies,
          allTransitiveDependencies: FamilyFamily._allTransitiveDependencies,
        );

  final int first;
  final String? second;
  final double third;
  final bool fourth;
  final List<String>? fifth;

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider &&
        other.first == first &&
        other.second == second &&
        other.third == third &&
        other.fourth == fourth &&
        other.fifth == fifth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, first.hashCode);
    hash = _SystemHash.combine(hash, second.hashCode);
    hash = _SystemHash.combine(hash, third.hashCode);
    hash = _SystemHash.combine(hash, fourth.hashCode);
    hash = _SystemHash.combine(hash, fifth.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$privateHash() => r'519561bc7e88e394d7f75ca2102a5c0acc832c66';

/// See also [_private].
@ProviderFor(_private)
final _privateProvider = AutoDisposeProvider<String>.internal(
  _private,
  name: r'_privateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _PrivateRef = AutoDisposeProviderRef<String>;
String _$publicClassHash() => r'f04884c039e6200ad3537feeecfc6e83828b5eb5';

/// This is some documentation
///
/// Copied from [PublicClass].
@ProviderFor(PublicClass)
final publicClassProvider =
    AutoDisposeNotifierProvider<PublicClass, String>.internal(
  PublicClass.new,
  name: r'publicClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PublicClass = AutoDisposeNotifier<String>;
String _$privateClassHash() => r'6d41def3ffdc1f79e593beaefb3304ce4b211a77';

/// See also [_PrivateClass].
@ProviderFor(_PrivateClass)
final _privateClassProvider =
    AutoDisposeNotifierProvider<_PrivateClass, String>.internal(
  _PrivateClass.new,
  name: r'_privateClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PrivateClass = AutoDisposeNotifier<String>;
String _$familyClassHash() => r'7dd0013dba8f45e82e8e39fbb2635e5a7f4b9cac';

abstract class _$FamilyClass extends BuildlessAutoDisposeNotifier<String> {
  late final int first;
  late final String? second;
  late final double third;
  late final bool fourth;
  late final List<String>? fifth;

  String build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  });
}

/// This is some documentation
///
/// Copied from [FamilyClass].
@ProviderFor(FamilyClass)
const familyClassProvider = FamilyClassFamily();

/// This is some documentation
///
/// Copied from [FamilyClass].
class FamilyClassFamily extends Family<String> {
  /// This is some documentation
  ///
  /// Copied from [FamilyClass].
  const FamilyClassFamily();

  /// This is some documentation
  ///
  /// Copied from [FamilyClass].
  FamilyClassProvider call(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) {
    return FamilyClassProvider(
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
  }

  @override
  FamilyClassProvider getProviderOverride(
    covariant FamilyClassProvider provider,
  ) {
    return call(
      provider.first,
      second: provider.second,
      third: provider.third,
      fourth: provider.fourth,
      fifth: provider.fifth,
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
  String? get name => r'familyClassProvider';
}

/// This is some documentation
///
/// Copied from [FamilyClass].
class FamilyClassProvider
    extends AutoDisposeNotifierProviderImpl<FamilyClass, String> {
  /// This is some documentation
  ///
  /// Copied from [FamilyClass].
  FamilyClassProvider(
    this.first, {
    this.second,
    required this.third,
    this.fourth = true,
    this.fifth,
  }) : super.internal(
          () => FamilyClass()
            ..first = first
            ..second = second
            ..third = third
            ..fourth = fourth
            ..fifth = fifth,
          from: familyClassProvider,
          name: r'familyClassProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyClassHash,
          dependencies: FamilyClassFamily._dependencies,
          allTransitiveDependencies:
              FamilyClassFamily._allTransitiveDependencies,
        );

  final int first;
  final String? second;
  final double third;
  final bool fourth;
  final List<String>? fifth;

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider &&
        other.first == first &&
        other.second == second &&
        other.third == third &&
        other.fourth == fourth &&
        other.fifth == fifth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, first.hashCode);
    hash = _SystemHash.combine(hash, second.hashCode);
    hash = _SystemHash.combine(hash, third.hashCode);
    hash = _SystemHash.combine(hash, fourth.hashCode);
    hash = _SystemHash.combine(hash, fifth.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String runNotifierBuild(
    covariant FamilyClass notifier,
  ) {
    return notifier.build(
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
  }
}

String _$supports$InClassNameHash() =>
    r'4e99f433d9cb3598faaf4d172edf9f28b9e68091';

/// See also [Supports$InClassName].
@ProviderFor(Supports$InClassName)
final supports$InClassNameProvider =
    AutoDisposeNotifierProvider<Supports$InClassName, String>.internal(
  Supports$InClassName.new,
  name: r'supports$InClassNameProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supports$InClassNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Supports$InClassName = AutoDisposeNotifier<String>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
