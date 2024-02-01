// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$depHash() => r'2213a401e03a1a914579b4a3a7707b783de9efba';

/// See also [dep].
@ProviderFor(dep)
final depProvider = Provider<int>.internal(
  dep,
  name: r'depProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$depHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DepRef = Ref<int>;
String _$familyHash() => r'8c228ff14b8c6cf1f3d4d6266232d64b5057c440';

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
final class FamilyFamily extends Family {
  /// See also [family].
  const FamilyFamily()
      : super(
          name: r'familyProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [family].
  FamilyProvider call(
    int id,
  ) {
    return FamilyProvider(
      id,
    );
  }

  @override
  String toString() => 'familyProvider';
}

/// See also [family].
final class FamilyProvider extends Provider<int> {
  /// See also [family].
  FamilyProvider(
    int id,
  ) : this._internal(
          (ref) => family(
            ref as FamilyRef,
            id,
          ),
          argument: (id,),
        );

  FamilyProvider._internal(
    super.create, {
    required (int,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyHash,
          from: familyProvider,
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _FamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _FamilyProviderElement(this, container);
  }

  @internal
  @override
  FamilyProvider copyWithCreate(
    int Function(FamilyRef ref) create,
  ) {
    return FamilyProvider._internal(
      (ref) => create(ref as FamilyRef),
      argument: argument as (int,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'familyProvider$argument';
}

mixin FamilyRef on Ref<int> {
  /// The parameter `id` of this provider.
  int get id;
}

class _FamilyProviderElement extends ProviderElement<int> with FamilyRef {
  _FamilyProviderElement(super.provider, super.container);

  @override
  int get id => (origin as FamilyProvider).id;
}

String _$providerHash() => r'6c9184ef4c6a410a2132e1ecc13a2e646e936d37';

/// See also [provider].
@ProviderFor(provider)
final providerProvider = Provider<int>.internal(
  provider,
  name: r'providerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$providerHash,
  from: null,
  argument: null,
  isAutoDispose: true,
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

typedef ProviderRef = Ref<int>;
String _$provider2Hash() => r'70d908579c5e64ce6558b42f433adfb80f4dc79b';

/// See also [provider2].
@ProviderFor(provider2)
final provider2Provider = Provider<int>.internal(
  provider2,
  name: r'provider2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$provider2Hash,
  from: null,
  argument: null,
  isAutoDispose: true,
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

typedef Provider2Ref = Ref<int>;
String _$transitiveDependenciesHash() =>
    r'9c81823224bb28a5dc482328c04ce76293370877';

/// See also [transitiveDependencies].
@ProviderFor(transitiveDependencies)
final transitiveDependenciesProvider = Provider<int>.internal(
  transitiveDependencies,
  name: r'transitiveDependenciesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transitiveDependenciesHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: <ProviderOrFamily>[providerProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    providerProvider,
    ...?providerProvider.allTransitiveDependencies
  },
);

typedef TransitiveDependenciesRef = Ref<int>;
String _$smallTransitiveDependencyCountHash() =>
    r'34689e1ba57e2959975cbf8ebd6c9483f4652a73';

/// See also [smallTransitiveDependencyCount].
@ProviderFor(smallTransitiveDependencyCount)
final smallTransitiveDependencyCountProvider = Provider<int>.internal(
  smallTransitiveDependencyCount,
  name: r'smallTransitiveDependencyCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$smallTransitiveDependencyCountHash,
  from: null,
  argument: null,
  isAutoDispose: true,
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

typedef SmallTransitiveDependencyCountRef = Ref<int>;
String _$emptyDependenciesFunctionalHash() =>
    r'592bebd079450e2071fb12d68c3ae333d5c28359';

/// See also [emptyDependenciesFunctional].
@ProviderFor(emptyDependenciesFunctional)
final emptyDependenciesFunctionalProvider = Provider<int>.internal(
  emptyDependenciesFunctional,
  name: r'emptyDependenciesFunctionalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emptyDependenciesFunctionalHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

typedef EmptyDependenciesFunctionalRef = Ref<int>;
String _$providerWithDependenciesHash() =>
    r'beecbe7a41b647ab92367dbcc12055bcd6345af7';

/// See also [providerWithDependencies].
@ProviderFor(providerWithDependencies)
final providerWithDependenciesProvider = Provider<int>.internal(
  providerWithDependencies,
  name: r'providerWithDependenciesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$providerWithDependenciesHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: <ProviderOrFamily>[_privateDepProvider, publicDepProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    _privateDepProvider,
    ...?_privateDepProvider.allTransitiveDependencies,
    publicDepProvider,
    ...?publicDepProvider.allTransitiveDependencies
  },
);

typedef ProviderWithDependenciesRef = Ref<int>;
String _$privateDepHash() => r'f610d91bd39e0dcffe6ff4e74160964a291289d9';

/// See also [_privateDep].
@ProviderFor(_privateDep)
final _privateDepProvider = Provider<int>.internal(
  _privateDep,
  name: r'_privateDepProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateDepHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _PrivateDepRef = Ref<int>;
String _$publicDepHash() => r'bcb69aace017c86c3c4b8eccf59fa22d010834bc';

/// See also [publicDep].
@ProviderFor(publicDep)
final publicDepProvider = Provider<int>.internal(
  publicDep,
  name: r'publicDepProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicDepHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PublicDepRef = Ref<int>;
String _$dep2Hash() => r'2778537df77f6431148c2ce400724da3e2ab4b94';

/// See also [Dep2].
@ProviderFor(Dep2)
final dep2Provider = NotifierProvider<Dep2, int>.internal(
  Dep2.new,
  name: r'dep2Provider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dep2Hash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Dep2 = Notifier<int>;
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
final class Family2Family extends Family {
  /// See also [Family2].
  const Family2Family()
      : super(
          name: r'family2Provider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$family2Hash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [Family2].
  Family2Provider call(
    int id,
  ) {
    return Family2Provider(
      id,
    );
  }

  @override
  String toString() => 'family2Provider';
}

/// See also [Family2].
final class Family2Provider
    extends AutoDisposeNotifierProviderImpl<Family2, int> {
  /// See also [Family2].
  Family2Provider(
    int id,
  ) : this._internal(
          () => Family2()..id = id,
          argument: (id,),
        );

  Family2Provider._internal(
    super.create, {
    required (int,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$family2Hash,
          from: family2Provider,
          name: r'family2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  int runNotifierBuild(
    covariant Family2 notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @internal
  @override
  AutoDisposeNotifierProviderImpl copyWithBuild(
    Family2 Function() create,
  ) {
    return AutoDisposeNotifierProviderImpl._internal(
      create,
      id: id,
    );
  }

  @override
  _Family2ProviderElement createElement(
    ProviderContainer container,
  ) {
    return _Family2ProviderElement(this, container);
  }

  @internal
  @override
  Family2Provider copyWithCreate(
    Family2 Function() create,
  ) {
    return Family2Provider._internal(
      () => create()..id = id,
      argument: argument as (int,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Family2Provider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'family2Provider$argument';
}

mixin Family2Ref on AutoDisposeNotifierProviderRef {
  /// The parameter `id` of this provider.
  int get id;
}

class _Family2ProviderElement
    extends AutoDisposeNotifierProviderElement<Family2, int> with Family2Ref {
  _Family2ProviderElement(super.provider, super.container);

  @override
  int get id => (origin as Family2Provider).id;
}

String _$provider3Hash() => r'dfdd6dec6cfee543c73d99593ce98d68f4db385c';

/// See also [Provider3].
@ProviderFor(Provider3)
final provider3Provider = NotifierProvider<Provider3, int>.internal(
  Provider3.new,
  name: r'provider3Provider',
  from: null,
  argument: null,
  isAutoDispose: true,
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

typedef _$Provider3 = Notifier<int>;
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
final class Provider4Family extends Family {
  /// See also [Provider4].
  const Provider4Family()
      : super(
          name: r'provider4Provider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$provider4Hash,
          isAutoDispose: true,
        );

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>{
    depProvider,
    familyProvider,
    dep2Provider,
    family2Provider
  };

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

  /// See also [Provider4].
  Provider4Provider call(
    int id,
  ) {
    return Provider4Provider(
      id,
    );
  }

  @override
  String toString() => 'provider4Provider';
}

/// See also [Provider4].
final class Provider4Provider
    extends AutoDisposeNotifierProviderImpl<Provider4, int> {
  /// See also [Provider4].
  Provider4Provider(
    int id,
  ) : this._internal(
          () => Provider4()..id = id,
          argument: (id,),
        );

  Provider4Provider._internal(
    super.create, {
    required (int,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$provider4Hash,
          from: provider4Provider,
          name: r'provider4Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  int runNotifierBuild(
    covariant Provider4 notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @internal
  @override
  AutoDisposeNotifierProviderImpl copyWithBuild(
    Provider4 Function() create,
  ) {
    return AutoDisposeNotifierProviderImpl._internal(
      create,
      id: id,
    );
  }

  @override
  _Provider4ProviderElement createElement(
    ProviderContainer container,
  ) {
    return _Provider4ProviderElement(this, container);
  }

  @internal
  @override
  Provider4Provider copyWithCreate(
    Provider4 Function() create,
  ) {
    return Provider4Provider._internal(
      () => create()..id = id,
      argument: argument as (int,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Provider4Provider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'provider4Provider$argument';
}

mixin Provider4Ref on AutoDisposeNotifierProviderRef {
  /// The parameter `id` of this provider.
  int get id;
}

class _Provider4ProviderElement
    extends AutoDisposeNotifierProviderElement<Provider4, int>
    with Provider4Ref {
  _Provider4ProviderElement(super.provider, super.container);

  @override
  int get id => (origin as Provider4Provider).id;
}

String _$emptyDependenciesClassBasedHash() =>
    r'e20c18353984a81977b656e9879b3841dbaedc6c';

/// See also [EmptyDependenciesClassBased].
@ProviderFor(EmptyDependenciesClassBased)
final emptyDependenciesClassBasedProvider =
    NotifierProvider<EmptyDependenciesClassBased, int>.internal(
  EmptyDependenciesClassBased.new,
  name: r'emptyDependenciesClassBasedProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emptyDependenciesClassBasedHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

typedef _$EmptyDependenciesClassBased = Notifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
