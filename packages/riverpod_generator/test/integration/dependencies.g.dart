// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

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

typedef PublicClassRef = AutoDisposeNotifierProviderRef<String>;
String $PublicClassHash() => r'9051420030bd52022bb1edcd36078849d4c0f8b1';

/// See also [PublicClass].
final publicClassProvider = AutoDisposeNotifierProvider<PublicClass, String>(
  PublicClass.new,
  name: r'publicClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $PublicClassHash,
  dependencies: <ProviderOrFamily>[_privateProvider],
);

abstract class _$PublicClass extends AutoDisposeNotifier<String> {
  @override
  String build();
}

typedef _PrivateClassRef = AutoDisposeNotifierProviderRef<String>;
String $_PrivateClassHash() => r'9a5df12774071b89bb9db57e3a45d4c6ea6c9762';

/// See also [_PrivateClass].
final _privateClassProvider =
    AutoDisposeNotifierProvider<_PrivateClass, String>(
  _PrivateClass.new,
  name: r'_privateClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $_PrivateClassHash,
  dependencies: <ProviderOrFamily>[_privateProvider],
);

abstract class _$PrivateClass extends AutoDisposeNotifier<String> {
  @override
  String build();
}

typedef FamilyClassRef = AutoDisposeNotifierProviderRef<String>;
String $FamilyClassHash() => r'b330d54d10c7ad8b4aa6fff7700006f7f71bef21';

/// See also [FamilyClass].
class FamilyClassProvider
    extends AutoDisposeNotifierProviderImpl<FamilyClass, String> {
  FamilyClassProvider(
    this.value,
  ) : super(
          () => FamilyClass()..value = value,
          from: familyClassProvider,
          name: r'familyClassProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $FamilyClassHash,
        );

  final String value;

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider && other.value == value;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, value.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String runNotifierBuild(
    covariant _$FamilyClass notifier,
  ) {
    return notifier.build(
      value,
    );
  }
}

/// See also [FamilyClass].
final familyClassProvider = FamilyClassFamily();

class FamilyClassFamily extends Family<String> {
  FamilyClassFamily();

  FamilyClassProvider call(
    String value,
  ) {
    return FamilyClassProvider(
      value,
    );
  }

  @override
  AutoDisposeNotifierProviderImpl<FamilyClass, String> getProviderOverride(
    covariant FamilyClassProvider provider,
  ) {
    return call(
      provider.value,
    );
  }

  late final _recDeps =
      dependencies == null ? null : _allTransitiveDependencies(dependencies!);

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => _recDeps;

  static final _deps = <ProviderOrFamily>[_privateProvider];

  @override
  List<ProviderOrFamily>? get dependencies => _deps;

  @override
  String? get name => r'familyClassProvider';
}

abstract class _$FamilyClass extends BuildlessAutoDisposeNotifier<String> {
  late final String value;

  String build(
    String value,
  );
}

typedef FamilyClassStringRef = AutoDisposeNotifierProviderRef<String>;
String $FamilyClassStringHash() => r'd4937b443d9370296d75f24135021606e207a898';

/// See also [FamilyClassString].
class FamilyClassStringProvider
    extends AutoDisposeNotifierProviderImpl<FamilyClassString, String> {
  FamilyClassStringProvider(
    this.value,
  ) : super(
          () => FamilyClassString()..value = value,
          from: familyClassStringProvider,
          name: r'familyClassStringProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $FamilyClassStringHash,
        );

  final String value;

  @override
  bool operator ==(Object other) {
    return other is FamilyClassStringProvider && other.value == value;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, value.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String runNotifierBuild(
    covariant _$FamilyClassString notifier,
  ) {
    return notifier.build(
      value,
    );
  }
}

/// See also [FamilyClassString].
final familyClassStringProvider = FamilyClassStringFamily();

class FamilyClassStringFamily extends Family<String> {
  FamilyClassStringFamily();

  FamilyClassStringProvider call(
    String value,
  ) {
    return FamilyClassStringProvider(
      value,
    );
  }

  @override
  AutoDisposeNotifierProviderImpl<FamilyClassString, String>
      getProviderOverride(
    covariant FamilyClassStringProvider provider,
  ) {
    return call(
      provider.value,
    );
  }

  late final _recDeps =
      dependencies == null ? null : _allTransitiveDependencies(dependencies!);

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => _recDeps;

  static final _deps = <ProviderOrFamily>[_privateProvider, stateProvider];

  @override
  List<ProviderOrFamily>? get dependencies => _deps;

  @override
  String? get name => r'familyClassStringProvider';
}

abstract class _$FamilyClassString
    extends BuildlessAutoDisposeNotifier<String> {
  late final String value;

  String build(
    String value,
  );
}

typedef PublicRef = AutoDisposeProviderRef<String>;
String $publicHash() => r'c09baa7f3eed65eeafb94b991c8b0a74d5f5a691';

/// See also [public].
final publicProvider = AutoDisposeProvider<String>(
  public,
  name: r'publicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $publicHash,
  dependencies: <ProviderOrFamily>[
    _privateProvider,
    stateProvider,
    familyClassProvider,
    _privateClassProvider,
    publicClassProvider
  ],
);
typedef _PrivateRef = AutoDisposeFutureProviderRef<String>;
String $_privateHash() => r'dca0f816be242ff92c3c80303c756559baaa4256';

/// See also [_private].
final _privateProvider = AutoDisposeFutureProvider<String>(
  _private,
  name: r'_privateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $_privateHash,
  dependencies: <ProviderOrFamily>[],
);
