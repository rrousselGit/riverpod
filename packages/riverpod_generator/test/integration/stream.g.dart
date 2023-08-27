// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$publicHash() => r'c5cc0eac434371901cf6ab159a81bba49c58da12';

/// See also [public].
@ProviderFor(public)
final publicProvider = AutoDisposeStreamProvider<String>.internal(
  public,
  name: r'publicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PublicRef = AutoDisposeStreamProviderRef<String>;
String _$privateHash() => r'bbee0c7e27bda81346b5f52c96b23b2e48f83077';

/// See also [_private].
@ProviderFor(_private)
final _privateProvider = AutoDisposeStreamProvider<String>.internal(
  _private,
  name: r'_privateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _PrivateRef = AutoDisposeStreamProviderRef<String>;
String _$familyHash() => r'6896fac2f6e3ccd7c38ecaa0d538cbd3577936b2';

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

typedef FamilyRef = AutoDisposeStreamProviderRef<String>;

/// See also [family].
@ProviderFor(family)
const familyProvider = FamilyFamily();

/// See also [family].
class FamilyFamily extends Family<AsyncValue<String>> {
  /// See also [family].
  const FamilyFamily();

  /// See also [family].
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

/// See also [family].
class FamilyProvider extends AutoDisposeStreamProvider<String> {
  /// See also [family].
  FamilyProvider(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) : this._internal(
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
          first: first,
          second: second,
          third: third,
          fourth: fourth,
          fifth: fifth,
        );

  FamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.fifth,
  }) : super.internal();

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

String _$publicClassHash() => r'b1526943c8ff0aaa20642bf78e744e5833cf9d02';

/// See also [PublicClass].
@ProviderFor(PublicClass)
final publicClassProvider =
    AutoDisposeStreamNotifierProvider<PublicClass, String>.internal(
  PublicClass.new,
  name: r'publicClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PublicClass = AutoDisposeStreamNotifier<String>;
String _$privateClassHash() => r'8c0d52b7ab79c0546d0c84c011bb3512609e029e';

/// See also [_PrivateClass].
@ProviderFor(_PrivateClass)
final _privateClassProvider =
    AutoDisposeStreamNotifierProvider<_PrivateClass, String>.internal(
  _PrivateClass.new,
  name: r'_privateClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PrivateClass = AutoDisposeStreamNotifier<String>;
String _$familyClassHash() => r'6ec16ca23da8df4c010ecb5eed72e3e655504460';

abstract class _$FamilyClass
    extends BuildlessAutoDisposeStreamNotifier<String> {
  late final int first;
  late final String? second;
  late final double third;
  late final bool fourth;
  late final List<String>? fifth;

  Stream<String> build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  });
}

/// See also [FamilyClass].
@ProviderFor(FamilyClass)
const familyClassProvider = FamilyClassFamily();

/// See also [FamilyClass].
class FamilyClassFamily extends Family<AsyncValue<String>> {
  /// See also [FamilyClass].
  const FamilyClassFamily();

  /// See also [FamilyClass].
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

/// See also [FamilyClass].
class FamilyClassProvider
    extends AutoDisposeStreamNotifierProviderImpl<FamilyClass, String> {
  /// See also [FamilyClass].
  FamilyClassProvider(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) : this._internal(
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
          first: first,
          second: second,
          third: third,
          fourth: fourth,
          fifth: fifth,
        );

  FamilyClassProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.fifth,
  }) : super.internal();

  final int first;
  final String? second;
  final double third;
  final bool fourth;
  final List<String>? fifth;

  @override
  Stream<String> runNotifierBuild(
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

  @override
  Override overrideWith(FamilyClass Function() create) {
    return ProviderOverride(
      origin: this,
      override: FamilyClassProvider._internal(
        () => create()
          ..first = first
          ..second = second
          ..third = third
          ..fourth = fourth
          ..fifth = fifth,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      ),
    );
  }

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
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
