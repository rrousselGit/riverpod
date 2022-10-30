// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

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

String $PublicClassHash() => r'c27eae39f455b986e570abb84f1471de7445ef3b';

/// A generated public provider from a class
///
/// Copied from [PublicClass].
final publicClassProvider = AutoDisposeNotifierProvider<PublicClass, String>(
  PublicClass.new,
  name: r'publicClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $PublicClassHash,
);
typedef PublicClassRef = AutoDisposeNotifierProviderRef<String>;

abstract class _$PublicClass extends AutoDisposeNotifier<String> {
  @override
  String build();
}

String $_PrivateClassHash() => r'3b08af72c6d4f24aed264efcf181572525b75603';

/// See also [_PrivateClass].
final _privateClassProvider =
    AutoDisposeNotifierProvider<_PrivateClass, String>(
  _PrivateClass.new,
  name: r'_privateClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $_PrivateClassHash,
);
typedef _PrivateClassRef = AutoDisposeNotifierProviderRef<String>;

abstract class _$PrivateClass extends AutoDisposeNotifier<String> {
  @override
  String build();
}

String $FamilyClassHash() => r'721bdd2f1ca0d7cee1a0ae476d7bfe93f9ce6875';

/// A generated family provider from a class.
///
/// Copied from [FamilyClass].
class FamilyClassProvider
    extends AutoDisposeNotifierProviderImpl<FamilyClass, String> {
  FamilyClassProvider(
    this.first, {
    this.second,
    required this.third,
    this.forth = true,
    this.fifth,
  }) : super(
          () => FamilyClass()
            ..first = first
            ..second = second
            ..third = third
            ..forth = forth
            ..fifth = fifth,
          from: familyClassProvider,
          name: r'familyClassProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $FamilyClassHash,
        );

  final int first;
  final String? second;
  final double third;
  final bool forth;
  final List<String>? fifth;

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider &&
        other.first == first &&
        other.second == second &&
        other.third == third &&
        other.forth == forth &&
        other.fifth == fifth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, first.hashCode);
    hash = _SystemHash.combine(hash, second.hashCode);
    hash = _SystemHash.combine(hash, third.hashCode);
    hash = _SystemHash.combine(hash, forth.hashCode);
    hash = _SystemHash.combine(hash, fifth.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String runNotifierBuild(
    covariant _$FamilyClass notifier,
  ) {
    return notifier.build(
      first,
      second: second,
      third: third,
      forth: forth,
      fifth: fifth,
    );
  }
}

typedef FamilyClassRef = AutoDisposeNotifierProviderRef<String>;

/// A generated family provider from a class.
///
/// Copied from [FamilyClass].
final familyClassProvider = FamilyClassFamily();

class FamilyClassFamily extends Family<String> {
  FamilyClassFamily();

  FamilyClassProvider call(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  }) {
    return FamilyClassProvider(
      first,
      second: second,
      third: third,
      forth: forth,
      fifth: fifth,
    );
  }

  @override
  AutoDisposeNotifierProviderImpl<FamilyClass, String> getProviderOverride(
    covariant FamilyClassProvider provider,
  ) {
    return call(
      provider.first,
      second: provider.second,
      third: provider.third,
      forth: provider.forth,
      fifth: provider.fifth,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'familyClassProvider';
}

abstract class _$FamilyClass extends BuildlessAutoDisposeNotifier<String> {
  late final int first;
  late final String? second;
  late final double third;
  late final bool forth;
  late final List<String>? fifth;

  String build(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  });
}

String $Supports$InClassNameHash() =>
    r'dd23b01994664e5a2c22ba3a61f3b23d2128861b';

/// A generated provider from a class with a '$' in its name.
///
/// Copied from [Supports$InClassName].
final supports$InClassNameProvider =
    AutoDisposeNotifierProvider<Supports$InClassName, String>(
  Supports$InClassName.new,
  name: r'supports$InClassNameProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : $Supports$InClassNameHash,
);
typedef Supports$InClassNameRef = AutoDisposeNotifierProviderRef<String>;

abstract class _$Supports$InClassName extends AutoDisposeNotifier<String> {
  @override
  String build();
}

String $publicHash() => r'138be35943899793ab085e711fe3f3d22696a3ba';

/// A public generated provider.
///
/// Copied from [public].
final publicProvider = AutoDisposeProvider<String>(
  public,
  name: r'publicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $publicHash,
);
typedef PublicRef = AutoDisposeProviderRef<String>;
String $supports$inNamesHash() => r'baacdb7b92917860b02aba1fa7010c7056da4a67';

/// A generated provider with a '$' in its name.
///
/// Copied from [supports$inNames].
final supports$inNamesProvider = AutoDisposeProvider<String>(
  supports$inNames,
  name: r'supports$inNamesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : $supports$inNamesHash,
);
typedef Supports$inNamesRef = AutoDisposeProviderRef<String>;
String $familyHash() => r'ebf082969854dcc358b9870a2e5e9b922423e59b';

/// A generated family provider.
///
/// Copied from [family].
class FamilyProvider extends AutoDisposeProvider<String> {
  FamilyProvider(
    this.first, {
    this.second,
    required this.third,
    this.forth = true,
    this.fifth,
  }) : super(
          (ref) => family(
            ref,
            first,
            second: second,
            third: third,
            forth: forth,
            fifth: fifth,
          ),
          from: familyProvider,
          name: r'familyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $familyHash,
        );

  final int first;
  final String? second;
  final double third;
  final bool forth;
  final List<String>? fifth;

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider &&
        other.first == first &&
        other.second == second &&
        other.third == third &&
        other.forth == forth &&
        other.fifth == fifth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, first.hashCode);
    hash = _SystemHash.combine(hash, second.hashCode);
    hash = _SystemHash.combine(hash, third.hashCode);
    hash = _SystemHash.combine(hash, forth.hashCode);
    hash = _SystemHash.combine(hash, fifth.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef FamilyRef = AutoDisposeProviderRef<String>;

/// A generated family provider.
///
/// Copied from [family].
final familyProvider = FamilyFamily();

class FamilyFamily extends Family<String> {
  FamilyFamily();

  FamilyProvider call(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  }) {
    return FamilyProvider(
      first,
      second: second,
      third: third,
      forth: forth,
      fifth: fifth,
    );
  }

  @override
  AutoDisposeProvider<String> getProviderOverride(
    covariant FamilyProvider provider,
  ) {
    return call(
      provider.first,
      second: provider.second,
      third: provider.third,
      forth: provider.forth,
      fifth: provider.fifth,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'familyProvider';
}

String $_privateHash() => r'9a87ed0765ad8448525fa1290b34760c79e7402b';

/// See also [_private].
final _privateProvider = AutoDisposeProvider<String>(
  _private,
  name: r'_privateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $_privateHash,
);
typedef _PrivateRef = AutoDisposeProviderRef<String>;
