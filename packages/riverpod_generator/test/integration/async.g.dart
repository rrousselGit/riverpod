// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async.dart';

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

List<ProviderOrFamily> _allTransitiveDependencies(
  List<ProviderOrFamily> dependencies,
) {
  final result = <ProviderOrFamily>{};

  void visitDependency(ProviderOrFamily dep) {
    if (result.add(dep) && dep.dependencies != null) {
      dep.dependencies!.forEach(visitDependency);
    }
    final depFamily = dep.from;
    if (depFamily != null &&
        result.add(depFamily) &&
        depFamily.dependencies != null) {
      depFamily.dependencies!.forEach(visitDependency);
    }
  }

  dependencies.forEach(visitDependency);

  return List.unmodifiable(result);
}

typedef PublicClassRef = AutoDisposeAsyncNotifierProviderRef<String>;
String $PublicClassHash() => r'98f7b5a2478814264c0a70d066ecabfddc58c577';

/// See also [PublicClass].
final publicClassProvider =
    AutoDisposeAsyncNotifierProvider<PublicClass, String>(
  PublicClass.new,
  name: r'publicClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $PublicClassHash,
  dependencies: <ProviderOrFamily>[],
);

abstract class _$PublicClass extends AutoDisposeAsyncNotifier<String> {
  @override
  FutureOr<String> build();
}

typedef _PrivateClassRef = AutoDisposeAsyncNotifierProviderRef<String>;
String $_PrivateClassHash() => r'7e69cffe8315999710e4cb6bb3de9f179d3f2f5d';

/// See also [_PrivateClass].
final _privateClassProvider =
    AutoDisposeAsyncNotifierProvider<_PrivateClass, String>(
  _PrivateClass.new,
  name: r'_privateClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $_PrivateClassHash,
  dependencies: <ProviderOrFamily>[],
);

abstract class _$PrivateClass extends AutoDisposeAsyncNotifier<String> {
  @override
  FutureOr<String> build();
}

typedef FamilyClassRef = AutoDisposeAsyncNotifierProviderRef<String>;
String $FamilyClassHash() => r'7b31f94e49dff1aa8b2f88d41b8a94e9a6434408';

/// See also [FamilyClass].
class FamilyClassProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FamilyClass, String> {
  FamilyClassProvider(
    this.first, {
    this.second,
    required this.third,
    this.fourth = true,
    this.fifth,
  }) : super(
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
                  : $FamilyClassHash,
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
    covariant _$FamilyClass notifier,
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

/// See also [FamilyClass].
final familyClassProvider = FamilyClassFamily();

class FamilyClassFamily extends Family<AsyncValue<String>> {
  FamilyClassFamily();

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
  AutoDisposeAsyncNotifierProviderImpl<FamilyClass, String> getProviderOverride(
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

  late final _recDeps =
      dependencies == null ? null : _allTransitiveDependencies(dependencies!);

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => _recDeps;

  static final _deps = <ProviderOrFamily>[];

  @override
  List<ProviderOrFamily>? get dependencies => _deps;

  @override
  String? get name => r'familyClassProvider';
}

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

typedef PublicRef = AutoDisposeFutureProviderRef<String>;
String $publicHash() => r'9d99b79c013da13926d4ad89c72ebca4fc1cc257';

/// See also [public].
final publicProvider = AutoDisposeFutureProvider<String>(
  public,
  name: r'publicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $publicHash,
  dependencies: <ProviderOrFamily>[],
);
typedef _PrivateRef = AutoDisposeFutureProviderRef<String>;
String $_privateHash() => r'bc0469a9315de114a0ccd82c7db4980844d0009f';

/// See also [_private].
final _privateProvider = AutoDisposeFutureProvider<String>(
  _private,
  name: r'_privateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $_privateHash,
  dependencies: <ProviderOrFamily>[],
);
typedef FamilyRef = AutoDisposeFutureProviderRef<String>;
String $familyHash() => r'9fbfe324401a079b8461d1b102299d0ca45b210e';

/// See also [family].
class FamilyProvider extends AutoDisposeFutureProvider<String> {
  FamilyProvider(
    this.first, {
    this.second,
    required this.third,
    this.fourth = true,
    this.fifth,
  }) : super(
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
                  : $familyHash,
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

/// See also [family].
final familyProvider = FamilyFamily();

class FamilyFamily extends Family<AsyncValue<String>> {
  FamilyFamily();

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
  AutoDisposeFutureProvider<String> getProviderOverride(
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

  late final _recDeps =
      dependencies == null ? null : _allTransitiveDependencies(dependencies!);

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => _recDeps;

  static final _deps = <ProviderOrFamily>[];

  @override
  List<ProviderOrFamily>? get dependencies => _deps;

  @override
  String? get name => r'familyProvider';
}
