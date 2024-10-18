// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$depHash() => r'1b3ec5231cd2328602151de9ceacdcd102a1d2e2';

/// See also [dep].
@ProviderFor(dep)
final depProvider = AutoDisposeProvider<int>.internal(
  dep,
  name: r'depProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$depHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DepRef = AutoDisposeProviderRef<int>;
String _$familyHash() => r'940eb87eb11206499f73f05791a6266b38cda88a';

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

/// See also [family].
@ProviderFor(family)
const familyProvider = FamilyFamily();

/// See also [family].
class FamilyFamily extends Family<int> {
  /// See also [family].
  const FamilyFamily();

  /// See also [family].
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
class FamilyProvider extends AutoDisposeProvider<int> {
  /// See also [family].
  FamilyProvider(
    int id,
  ) : this._internal(
          (ref) => family(
            ref as FamilyRef,
            id,
          ),
          from: familyProvider,
          name: r'familyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyHash,
          dependencies: FamilyFamily._dependencies,
          allTransitiveDependencies: FamilyFamily._allTransitiveDependencies,
          id: id,
        );

  FamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    int Function(FamilyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FamilyProvider._internal(
        (ref) => create(ref as FamilyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _FamilyProviderElement(this);
  }

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FamilyRef on AutoDisposeProviderRef<int> {
  /// The parameter `id` of this provider.
  int get id;
}

class _FamilyProviderElement extends AutoDisposeProviderElement<int>
    with FamilyRef {
  _FamilyProviderElement(super.provider);

  @override
  int get id => (origin as FamilyProvider).id;
}

String _$providerHash() => r'1be7ae7ac2100d39b949af50ec50fce48b26cdd1';

/// See also [provider].
@ProviderFor(provider)
final providerProvider = AutoDisposeProvider<int>.internal(
  provider,
  name: r'providerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$providerHash,
  dependencies: <ProviderOrFamily>{
    depProvider,
    familyProvider,
    dep2Provider,
    family2Provider
  },
  allTransitiveDependencies: <ProviderOrFamily>{
    depProvider,
    ...?depProvider.allTransitiveDependencies,
    familyProvider,
    ...?familyProvider.allTransitiveDependencies,
    dep2Provider,
    ...?dep2Provider.allTransitiveDependencies,
    family2Provider,
    ...?family2Provider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProviderRef = AutoDisposeProviderRef<int>;
String _$provider2Hash() => r'30f81430b57f0116f621a4a309c458fce0536378';

/// See also [provider2].
@ProviderFor(provider2)
final provider2Provider = AutoDisposeProvider<int>.internal(
  provider2,
  name: r'provider2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$provider2Hash,
  dependencies: <ProviderOrFamily>{
    depProvider,
    familyProvider,
    dep2Provider,
    family2Provider
  },
  allTransitiveDependencies: <ProviderOrFamily>{
    depProvider,
    ...?depProvider.allTransitiveDependencies,
    familyProvider,
    ...?familyProvider.allTransitiveDependencies,
    dep2Provider,
    ...?dep2Provider.allTransitiveDependencies,
    family2Provider,
    ...?family2Provider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef Provider2Ref = AutoDisposeProviderRef<int>;
String _$transitiveDependenciesHash() =>
    r'909d45403831b521177ec15b1dd78554e261d3be';

/// See also [transitiveDependencies].
@ProviderFor(transitiveDependencies)
final transitiveDependenciesProvider = AutoDisposeProvider<int>.internal(
  transitiveDependencies,
  name: r'transitiveDependenciesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transitiveDependenciesHash,
  dependencies: <ProviderOrFamily>[providerProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    providerProvider,
    ...?providerProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransitiveDependenciesRef = AutoDisposeProviderRef<int>;
String _$smallTransitiveDependencyCountHash() =>
    r'f67b369dd99e35a6e6211004b45c87c5ba4ac1c7';

/// See also [smallTransitiveDependencyCount].
@ProviderFor(smallTransitiveDependencyCount)
final smallTransitiveDependencyCountProvider =
    AutoDisposeProvider<int>.internal(
  smallTransitiveDependencyCount,
  name: r'smallTransitiveDependencyCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$smallTransitiveDependencyCountHash,
  dependencies: <ProviderOrFamily>[depProvider, familyProvider, dep2Provider],
  allTransitiveDependencies: <ProviderOrFamily>{
    depProvider,
    ...?depProvider.allTransitiveDependencies,
    familyProvider,
    ...?familyProvider.allTransitiveDependencies,
    dep2Provider,
    ...?dep2Provider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SmallTransitiveDependencyCountRef = AutoDisposeProviderRef<int>;
String _$emptyDependenciesFunctionalHash() =>
    r'77289071cab8a10da8f5b7b40932864510a1ee38';

/// See also [emptyDependenciesFunctional].
@ProviderFor(emptyDependenciesFunctional)
final emptyDependenciesFunctionalProvider = AutoDisposeProvider<int>.internal(
  emptyDependenciesFunctional,
  name: r'emptyDependenciesFunctionalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emptyDependenciesFunctionalHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmptyDependenciesFunctionalRef = AutoDisposeProviderRef<int>;
String _$providerWithDependenciesHash() =>
    r'7d40c994fc2d4ba9e6a0bb4a3d100f8da874eb5e';

/// See also [providerWithDependencies].
@ProviderFor(providerWithDependencies)
final providerWithDependenciesProvider = AutoDisposeProvider<int>.internal(
  providerWithDependencies,
  name: r'providerWithDependenciesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$providerWithDependenciesHash,
  dependencies: <ProviderOrFamily>[_privateDepProvider, publicDepProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    _privateDepProvider,
    ...?_privateDepProvider.allTransitiveDependencies,
    publicDepProvider,
    ...?publicDepProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProviderWithDependenciesRef = AutoDisposeProviderRef<int>;
String _$privateDepHash() => r'92ff5cc515ecf2455cb04773f1b49f23b17ea2e2';

/// See also [_privateDep].
@ProviderFor(_privateDep)
final _privateDepProvider = AutoDisposeProvider<int>.internal(
  _privateDep,
  name: r'_privateDepProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateDepHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _PrivateDepRef = AutoDisposeProviderRef<int>;
String _$publicDepHash() => r'a9c461ae174577183ab4c0ff8d8267cc7a64a2c5';

/// See also [publicDep].
@ProviderFor(publicDep)
final publicDepProvider = AutoDisposeProvider<int>.internal(
  publicDep,
  name: r'publicDepProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicDepHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PublicDepRef = AutoDisposeProviderRef<int>;
String _$dep2Hash() => r'2778537df77f6431148c2ce400724da3e2ab4b94';

/// See also [Dep2].
@ProviderFor(Dep2)
final dep2Provider = AutoDisposeNotifierProvider<Dep2, int>.internal(
  Dep2.new,
  name: r'dep2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dep2Hash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Dep2 = AutoDisposeNotifier<int>;
String _$family2Hash() => r'ce727b262aae067b0d4f703f03670abb70ad8977';

abstract class _$Family2 extends BuildlessAutoDisposeNotifier<int> {
  late final int id;

  int build(
    int id,
  );
}

/// See also [Family2].
@ProviderFor(Family2)
const family2Provider = Family2Family();

/// See also [Family2].
class Family2Family extends Family<int> {
  /// See also [Family2].
  const Family2Family();

  /// See also [Family2].
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

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'family2Provider';
}

/// See also [Family2].
class Family2Provider extends AutoDisposeNotifierProviderImpl<Family2, int> {
  /// See also [Family2].
  Family2Provider(
    int id,
  ) : this._internal(
          () => Family2()..id = id,
          from: family2Provider,
          name: r'family2Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$family2Hash,
          dependencies: Family2Family._dependencies,
          allTransitiveDependencies: Family2Family._allTransitiveDependencies,
          id: id,
        );

  Family2Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  int runNotifierBuild(
    covariant Family2 notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(Family2 Function() create) {
    return ProviderOverride(
      origin: this,
      override: Family2Provider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Family2, int> createElement() {
    return _Family2ProviderElement(this);
  }

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
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin Family2Ref on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `id` of this provider.
  int get id;
}

class _Family2ProviderElement
    extends AutoDisposeNotifierProviderElement<Family2, int> with Family2Ref {
  _Family2ProviderElement(super.provider);

  @override
  int get id => (origin as Family2Provider).id;
}

String _$provider3Hash() => r'dfdd6dec6cfee543c73d99593ce98d68f4db385c';

/// See also [Provider3].
@ProviderFor(Provider3)
final provider3Provider = AutoDisposeNotifierProvider<Provider3, int>.internal(
  Provider3.new,
  name: r'provider3Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$provider3Hash,
  dependencies: <ProviderOrFamily>{
    depProvider,
    familyProvider,
    dep2Provider,
    family2Provider
  },
  allTransitiveDependencies: <ProviderOrFamily>{
    depProvider,
    ...?depProvider.allTransitiveDependencies,
    familyProvider,
    ...?familyProvider.allTransitiveDependencies,
    dep2Provider,
    ...?dep2Provider.allTransitiveDependencies,
    family2Provider,
    ...?family2Provider.allTransitiveDependencies
  },
);

typedef _$Provider3 = AutoDisposeNotifier<int>;
String _$provider4Hash() => r'1c955214d99695bb694c96374b277aac58e734df';

abstract class _$Provider4 extends BuildlessAutoDisposeNotifier<int> {
  late final int id;

  int build(
    int id,
  );
}

/// See also [Provider4].
@ProviderFor(Provider4)
const provider4Provider = Provider4Family();

/// See also [Provider4].
class Provider4Family extends Family<int> {
  /// See also [Provider4].
  const Provider4Family();

  /// See also [Provider4].
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

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>{
    depProvider,
    familyProvider,
    dep2Provider,
    family2Provider
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    depProvider,
    ...?depProvider.allTransitiveDependencies,
    familyProvider,
    ...?familyProvider.allTransitiveDependencies,
    dep2Provider,
    ...?dep2Provider.allTransitiveDependencies,
    family2Provider,
    ...?family2Provider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'provider4Provider';
}

/// See also [Provider4].
class Provider4Provider
    extends AutoDisposeNotifierProviderImpl<Provider4, int> {
  /// See also [Provider4].
  Provider4Provider(
    int id,
  ) : this._internal(
          () => Provider4()..id = id,
          from: provider4Provider,
          name: r'provider4Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$provider4Hash,
          dependencies: Provider4Family._dependencies,
          allTransitiveDependencies: Provider4Family._allTransitiveDependencies,
          id: id,
        );

  Provider4Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  int runNotifierBuild(
    covariant Provider4 notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(Provider4 Function() create) {
    return ProviderOverride(
      origin: this,
      override: Provider4Provider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Provider4, int> createElement() {
    return _Provider4ProviderElement(this);
  }

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
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin Provider4Ref on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `id` of this provider.
  int get id;
}

class _Provider4ProviderElement
    extends AutoDisposeNotifierProviderElement<Provider4, int>
    with Provider4Ref {
  _Provider4ProviderElement(super.provider);

  @override
  int get id => (origin as Provider4Provider).id;
}

String _$emptyDependenciesClassBasedHash() =>
    r'e20c18353984a81977b656e9879b3841dbaedc6c';

/// See also [EmptyDependenciesClassBased].
@ProviderFor(EmptyDependenciesClassBased)
final emptyDependenciesClassBasedProvider =
    AutoDisposeNotifierProvider<EmptyDependenciesClassBased, int>.internal(
  EmptyDependenciesClassBased.new,
  name: r'emptyDependenciesClassBasedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emptyDependenciesClassBasedHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

typedef _$EmptyDependenciesClassBased = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
