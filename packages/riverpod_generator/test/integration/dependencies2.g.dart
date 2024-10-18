// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies2.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$providerWithDependencies2Hash() =>
    r'3a6100929120a9cf1ef7f1e0a5e9b8e4d4030ae2';

/// See also [providerWithDependencies2].
@ProviderFor(providerWithDependencies2)
final providerWithDependencies2Provider = AutoDisposeProvider<int>.internal(
  providerWithDependencies2,
  name: r'providerWithDependencies2Provider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$providerWithDependencies2Hash,
  dependencies: <ProviderOrFamily>[
    providerWithDependenciesProvider,
    _private2Provider,
    public2Provider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    providerWithDependenciesProvider,
    ...?providerWithDependenciesProvider.allTransitiveDependencies,
    _private2Provider,
    ...?_private2Provider.allTransitiveDependencies,
    public2Provider,
    ...?public2Provider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProviderWithDependencies2Ref = AutoDisposeProviderRef<int>;
String _$familyWithDependencies2Hash() =>
    r'd064c06ca5a85a62cbe2b47943e98fc2e858fb03';

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

/// See also [familyWithDependencies2].
@ProviderFor(familyWithDependencies2)
const familyWithDependencies2Provider = FamilyWithDependencies2Family();

/// See also [familyWithDependencies2].
class FamilyWithDependencies2Family extends Family<int> {
  /// See also [familyWithDependencies2].
  const FamilyWithDependencies2Family();

  /// See also [familyWithDependencies2].
  FamilyWithDependencies2Provider call({
    int? id,
  }) {
    return FamilyWithDependencies2Provider(
      id: id,
    );
  }

  @override
  FamilyWithDependencies2Provider getProviderOverride(
    covariant FamilyWithDependencies2Provider provider,
  ) {
    return call(
      id: provider.id,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    providerWithDependenciesProvider,
    _private2Provider,
    public2Provider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    providerWithDependenciesProvider,
    ...?providerWithDependenciesProvider.allTransitiveDependencies,
    _private2Provider,
    ...?_private2Provider.allTransitiveDependencies,
    public2Provider,
    ...?public2Provider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'familyWithDependencies2Provider';
}

/// See also [familyWithDependencies2].
class FamilyWithDependencies2Provider extends AutoDisposeProvider<int> {
  /// See also [familyWithDependencies2].
  FamilyWithDependencies2Provider({
    int? id,
  }) : this._internal(
          (ref) => familyWithDependencies2(
            ref as FamilyWithDependencies2Ref,
            id: id,
          ),
          from: familyWithDependencies2Provider,
          name: r'familyWithDependencies2Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyWithDependencies2Hash,
          dependencies: FamilyWithDependencies2Family._dependencies,
          allTransitiveDependencies:
              FamilyWithDependencies2Family._allTransitiveDependencies,
          id: id,
        );

  FamilyWithDependencies2Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int? id;

  @override
  Override overrideWith(
    int Function(FamilyWithDependencies2Ref provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FamilyWithDependencies2Provider._internal(
        (ref) => create(ref as FamilyWithDependencies2Ref),
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
    return _FamilyWithDependencies2ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyWithDependencies2Provider && other.id == id;
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
mixin FamilyWithDependencies2Ref on AutoDisposeProviderRef<int> {
  /// The parameter `id` of this provider.
  int? get id;
}

class _FamilyWithDependencies2ProviderElement
    extends AutoDisposeProviderElement<int> with FamilyWithDependencies2Ref {
  _FamilyWithDependencies2ProviderElement(super.provider);

  @override
  int? get id => (origin as FamilyWithDependencies2Provider).id;
}

String _$private2Hash() => r'e420875c8fbd9bf33eff945f2b7276b585032a38';

/// See also [_private2].
@ProviderFor(_private2)
final _private2Provider = AutoDisposeProvider<int>.internal(
  _private2,
  name: r'_private2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$private2Hash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _Private2Ref = AutoDisposeProviderRef<int>;
String _$public2Hash() => r'20eb4f82e5f25fafc72775e7b86021d70ebb5579';

/// See also [public2].
@ProviderFor(public2)
final public2Provider = AutoDisposeProvider<int>.internal(
  public2,
  name: r'public2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$public2Hash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef Public2Ref = AutoDisposeProviderRef<int>;
String _$notifierWithDependenciesHash() =>
    r'becc68e5a54b0cc2b8277a6d54b74edef93bfe89';

/// See also [NotifierWithDependencies].
@ProviderFor(NotifierWithDependencies)
final notifierWithDependenciesProvider =
    AutoDisposeNotifierProvider<NotifierWithDependencies, int>.internal(
  NotifierWithDependencies.new,
  name: r'notifierWithDependenciesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notifierWithDependenciesHash,
  dependencies: <ProviderOrFamily>[
    providerWithDependenciesProvider,
    _private2Provider,
    public2Provider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    providerWithDependenciesProvider,
    ...?providerWithDependenciesProvider.allTransitiveDependencies,
    _private2Provider,
    ...?_private2Provider.allTransitiveDependencies,
    public2Provider,
    ...?public2Provider.allTransitiveDependencies
  },
);

typedef _$NotifierWithDependencies = AutoDisposeNotifier<int>;
String _$notifierFamilyWithDependenciesHash() =>
    r'b185ba93857cd028964c1412e748ee887dbd45c8';

abstract class _$NotifierFamilyWithDependencies
    extends BuildlessAutoDisposeNotifier<int> {
  late final int? id;

  int build({
    int? id,
  });
}

/// See also [NotifierFamilyWithDependencies].
@ProviderFor(NotifierFamilyWithDependencies)
const notifierFamilyWithDependenciesProvider =
    NotifierFamilyWithDependenciesFamily();

/// See also [NotifierFamilyWithDependencies].
class NotifierFamilyWithDependenciesFamily extends Family<int> {
  /// See also [NotifierFamilyWithDependencies].
  const NotifierFamilyWithDependenciesFamily();

  /// See also [NotifierFamilyWithDependencies].
  NotifierFamilyWithDependenciesProvider call({
    int? id,
  }) {
    return NotifierFamilyWithDependenciesProvider(
      id: id,
    );
  }

  @override
  NotifierFamilyWithDependenciesProvider getProviderOverride(
    covariant NotifierFamilyWithDependenciesProvider provider,
  ) {
    return call(
      id: provider.id,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    providerWithDependenciesProvider,
    _private2Provider,
    public2Provider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    providerWithDependenciesProvider,
    ...?providerWithDependenciesProvider.allTransitiveDependencies,
    _private2Provider,
    ...?_private2Provider.allTransitiveDependencies,
    public2Provider,
    ...?public2Provider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'notifierFamilyWithDependenciesProvider';
}

/// See also [NotifierFamilyWithDependencies].
class NotifierFamilyWithDependenciesProvider
    extends AutoDisposeNotifierProviderImpl<NotifierFamilyWithDependencies,
        int> {
  /// See also [NotifierFamilyWithDependencies].
  NotifierFamilyWithDependenciesProvider({
    int? id,
  }) : this._internal(
          () => NotifierFamilyWithDependencies()..id = id,
          from: notifierFamilyWithDependenciesProvider,
          name: r'notifierFamilyWithDependenciesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notifierFamilyWithDependenciesHash,
          dependencies: NotifierFamilyWithDependenciesFamily._dependencies,
          allTransitiveDependencies:
              NotifierFamilyWithDependenciesFamily._allTransitiveDependencies,
          id: id,
        );

  NotifierFamilyWithDependenciesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int? id;

  @override
  int runNotifierBuild(
    covariant NotifierFamilyWithDependencies notifier,
  ) {
    return notifier.build(
      id: id,
    );
  }

  @override
  Override overrideWith(NotifierFamilyWithDependencies Function() create) {
    return ProviderOverride(
      origin: this,
      override: NotifierFamilyWithDependenciesProvider._internal(
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
  AutoDisposeNotifierProviderElement<NotifierFamilyWithDependencies, int>
      createElement() {
    return _NotifierFamilyWithDependenciesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotifierFamilyWithDependenciesProvider && other.id == id;
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
mixin NotifierFamilyWithDependenciesRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `id` of this provider.
  int? get id;
}

class _NotifierFamilyWithDependenciesProviderElement
    extends AutoDisposeNotifierProviderElement<NotifierFamilyWithDependencies,
        int> with NotifierFamilyWithDependenciesRef {
  _NotifierFamilyWithDependenciesProviderElement(super.provider);

  @override
  int? get id => (origin as NotifierFamilyWithDependenciesProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
