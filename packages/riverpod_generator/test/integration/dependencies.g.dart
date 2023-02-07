// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// Generator: RiverpodGenerator2
// **************************************************************************

// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment
String _$dep2Hash() => '2778537df77f6431148c2ce400724da3e2ab4b94';

/// See also [Dep2].
@ProviderFor(Dep2)
final dep2Provider = AutoDisposeNotifierProvider<Dep2, int>(
  Dep2.new,
  name: r'dep2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dep2Hash,
);

typedef _$Dep2 = AutoDisposeNotifier<int>;
String _$family2Hash() => 'ce727b262aae067b0d4f703f03670abb70ad8977';

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

abstract class _$Family2 extends BuildlessAutoDisposeNotifier<int> {
  late final int id;

  int build(
    int id,
  );
}

/// See also [Family2].
@ProviderFor(Family2)
final family2Provider = Family2Family();

/// See also [Family2].
class Family2Family extends Family<int> {
  Family2Family();

  Family2Provider call(
    int id,
  ) {
    return Family2Provider(
      id,
    );
  }

  @override
  Family2Provider getProviderOverride(
    covariant Family2Provider provider,
  ) {
    return call(
      provider.id,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'family2Provider';
}

/// See also [Family2].
class Family2Provider extends AutoDisposeNotifierProviderImpl<Family2, int> {
  Family2Provider(
    this.id,
  ) : super(
          () => Family2()..id = id,
          from: family2Provider,
          name: r'family2Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$family2Hash,
        );

  final int id;

  @override
  bool operator ==(Object other) {
    return other is Family2Provider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant Family2 notifier,
  ) {
    return notifier.build(
      id,
    );
  }
}

String _$provider3Hash() => 'dfdd6dec6cfee543c73d99593ce98d68f4db385c';

/// See also [Provider3].
@ProviderFor(Provider3)
final provider3Provider = AutoDisposeNotifierProvider<Provider3, int>(
  Provider3.new,
  name: r'provider3Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$provider3Hash,
  dependencies: [depProvider, familyProvider, dep2Provider, family2Provider],
);

typedef _$Provider3 = AutoDisposeNotifier<int>;
String _$provider4Hash() => '1c955214d99695bb694c96374b277aac58e734df';

abstract class _$Provider4 extends BuildlessAutoDisposeNotifier<int> {
  late final int id;

  int build(
    int id,
  );
}

/// See also [Provider4].
@ProviderFor(Provider4)
final provider4Provider = Provider4Family();

/// See also [Provider4].
class Provider4Family extends Family<int> {
  Provider4Family();

  Provider4Provider call(
    int id,
  ) {
    return Provider4Provider(
      id,
    );
  }

  @override
  Provider4Provider getProviderOverride(
    covariant Provider4Provider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static final List<ProviderOrFamily> _allTransitiveDependencies = [
    depProvider,
    familyProvider,
    dep2Provider,
    family2Provider
  ];

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  static final List<ProviderOrFamily> _dependencies = [
    depProvider,
    familyProvider,
    dep2Provider,
    family2Provider
  ];

  @override
  List<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  String? get name => r'provider4Provider';
}

/// See also [Provider4].
class Provider4Provider
    extends AutoDisposeNotifierProviderImpl<Provider4, int> {
  Provider4Provider(
    this.id,
  ) : super(
          () => Provider4()..id = id,
          from: provider4Provider,
          name: r'provider4Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$provider4Hash,
        );

  final int id;

  @override
  bool operator ==(Object other) {
    return other is Provider4Provider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant Provider4 notifier,
  ) {
    return notifier.build(
      id,
    );
  }
}

String _$depHash() => '2213a401e03a1a914579b4a3a7707b783de9efba';

/// See also [dep].
@ProviderFor(dep)
final depProvider = AutoDisposeProvider<int>(
  dep,
  name: r'depProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$depHash,
);

typedef DepRef = AutoDisposeProviderRef<int>;
String _$familyHash() => '8c228ff14b8c6cf1f3d4d6266232d64b5057c440';
typedef FamilyRef = AutoDisposeProviderRef<int>;

/// See also [family].
@ProviderFor(family)
final familyProvider = FamilyFamily();

/// See also [family].
class FamilyFamily extends Family<int> {
  FamilyFamily();

  FamilyProvider call(
    int id,
  ) {
    return FamilyProvider(
      id,
    );
  }

  @override
  FamilyProvider getProviderOverride(
    covariant FamilyProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'familyProvider';
}

/// See also [family].
class FamilyProvider extends AutoDisposeProvider<int> {
  FamilyProvider(
    this.id,
  ) : super(
          (ref) => family(
            ref,
            id,
          ),
          from: familyProvider,
          name: r'familyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyHash,
        );

  final int id;

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$providerHash() => '6c9184ef4c6a410a2132e1ecc13a2e646e936d37';

/// See also [provider].
@ProviderFor(provider)
final providerProvider = AutoDisposeProvider<int>(
  provider,
  name: r'providerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$providerHash,
  dependencies: [depProvider, familyProvider, dep2Provider, family2Provider],
);

typedef ProviderRef = AutoDisposeProviderRef<int>;
String _$provider2Hash() => '70d908579c5e64ce6558b42f433adfb80f4dc79b';

/// See also [provider2].
@ProviderFor(provider2)
final provider2Provider = AutoDisposeProvider<int>(
  provider2,
  name: r'provider2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$provider2Hash,
  dependencies: [depProvider, familyProvider, dep2Provider, family2Provider],
);

typedef Provider2Ref = AutoDisposeProviderRef<int>;
String _$transitiveDependenciesHash() =>
    '9c81823224bb28a5dc482328c04ce76293370877';

/// See also [transitiveDependencies].
@ProviderFor(transitiveDependencies)
final transitiveDependenciesProvider = AutoDisposeProvider<int>(
  transitiveDependencies,
  name: r'transitiveDependenciesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transitiveDependenciesHash,
  dependencies: [providerProvider],
);

typedef TransitiveDependenciesRef = AutoDisposeProviderRef<int>;
