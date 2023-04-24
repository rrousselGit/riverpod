// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genericHash() => r'6ee5473ece745b00328c1e048f6967c160343620';

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

typedef GenericRef<T extends num> = AutoDisposeFutureProviderRef<List<T>>;

/// See also [generic].
@ProviderFor(generic)
const genericProvider = GenericFamily();

/// See also [generic].
class GenericFamily extends Family {
  /// See also [generic].
  const GenericFamily();

  /// See also [generic].
  GenericProvider<T> call<T extends num>() {
    return GenericProvider<T>();
  }

  @override
  GenericProvider<num> getProviderOverride(
    covariant GenericProvider<num> provider,
  ) {
    return call();
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'genericProvider';
}

/// See also [generic].
class GenericProvider<T extends num>
    extends AutoDisposeFutureProvider<List<T>> {
  /// See also [generic].
  GenericProvider()
      : super.internal(
          (ref) => generic<T>(
            ref,
          ),
          from: genericProvider,
          name: r'genericProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericHash,
          dependencies: GenericFamily._dependencies,
          allTransitiveDependencies: GenericFamily._allTransitiveDependencies,
        );

  @override
  bool operator ==(Object other) {
    return other is GenericProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, T.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$publicHash() => r'9d99b79c013da13926d4ad89c72ebca4fc1cc257';

/// See also [public].
@ProviderFor(public)
final publicProvider = AutoDisposeFutureProvider<String>.internal(
  public,
  name: r'publicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PublicRef = AutoDisposeFutureProviderRef<String>;
String _$privateHash() => r'bc0469a9315de114a0ccd82c7db4980844d0009f';

/// See also [_private].
@ProviderFor(_private)
final _privateProvider = AutoDisposeFutureProvider<String>.internal(
  _private,
  name: r'_privateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _PrivateRef = AutoDisposeFutureProviderRef<String>;
String _$familyHash() => r'f46defb7b007c76254058e9e8bc868260bcfe0f1';
typedef FamilyRef = AutoDisposeFutureProviderRef<String>;

/// See also [family].
@ProviderFor(family)
const familyProvider = FamilyFamily();

/// See also [family].
class FamilyFamily extends Family {
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
class FamilyProvider extends AutoDisposeFutureProvider<String> {
  /// See also [family].
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

String _$genericClassHash() => r'd3c4acc9cdae12f6c666fbf1f89aee212bb086db';

abstract class _$GenericClass<T extends num>
    extends BuildlessAutoDisposeAsyncNotifier<List<T>> {
  Future<List<T>> build();
}

/// See also [GenericClass].
@ProviderFor(GenericClass)
const genericClassProvider = GenericClassFamily();

/// See also [GenericClass].
class GenericClassFamily extends Family {
  /// See also [GenericClass].
  const GenericClassFamily();

  /// See also [GenericClass].
  GenericClassProvider<T> call<T extends num>() {
    return GenericClassProvider<T>();
  }

  @override
  GenericClassProvider<num> getProviderOverride(
    covariant GenericClassProvider<num> provider,
  ) {
    return call();
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'genericClassProvider';
}

/// See also [GenericClass].
class GenericClassProvider<T extends num>
    extends AutoDisposeAsyncNotifierProviderImpl<GenericClass<T>, List<T>> {
  /// See also [GenericClass].
  GenericClassProvider()
      : super.internal(
          GenericClass<T>.new,
          from: genericClassProvider,
          name: r'genericClassProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericClassHash,
          dependencies: GenericClassFamily._dependencies,
          allTransitiveDependencies:
              GenericClassFamily._allTransitiveDependencies,
        );

  @override
  bool operator ==(Object other) {
    return other is GenericClassProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, T.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  Future<List<T>> runNotifierBuild(
    covariant GenericClass<T> notifier,
  ) {
    return notifier.build();
  }
}

String _$publicClassHash() => r'98f7b5a2478814264c0a70d066ecabfddc58c577';

/// See also [PublicClass].
@ProviderFor(PublicClass)
final publicClassProvider =
    AutoDisposeAsyncNotifierProvider<PublicClass, String>.internal(
  PublicClass.new,
  name: r'publicClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PublicClass = AutoDisposeAsyncNotifier<String>;
String _$privateClassHash() => r'7e69cffe8315999710e4cb6bb3de9f179d3f2f5d';

/// See also [_PrivateClass].
@ProviderFor(_PrivateClass)
final _privateClassProvider =
    AutoDisposeAsyncNotifierProvider<_PrivateClass, String>.internal(
  _PrivateClass.new,
  name: r'_privateClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PrivateClass = AutoDisposeAsyncNotifier<String>;
String _$familyClassHash() => r'7b31f94e49dff1aa8b2f88d41b8a94e9a6434408';

abstract class _$FamilyClass extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final int first;
  late final String? second;
  late final double third;
  late final bool fourth;
  late final List<String>? fifth;

  FutureOr<String> build(
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
class FamilyClassFamily extends Family {
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
    extends AutoDisposeAsyncNotifierProviderImpl<FamilyClass, String> {
  /// See also [FamilyClass].
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
  FutureOr<String> runNotifierBuild(
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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
