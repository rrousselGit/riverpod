// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotated.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$functionalHash() => r'f30c2a17e4cce470c89b082569e3f911d9e4b79f';

/// See also [functional].
@ProviderFor(functional)
@Deprecated('Deprecation message')
@experimental
@visibleForTesting
@protected
final functionalProvider = AutoDisposeProvider<String>.internal(
  functional,
  name: r'functionalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$functionalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FunctionalRef = AutoDisposeProviderRef<String>;
String _$familyHash() => r'7a3eadae2860fe8643024906c5fb53a5e5dc7d49';

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
@Deprecated('Deprecation message')
@experimental
@visibleForTesting
@protected
const familyProvider = FamilyFamily();

/// See also [family].
class FamilyFamily extends Family<String> {
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
class FamilyProvider extends AutoDisposeProvider<String> {
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
    String Function(FamilyRef provider) create,
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
  AutoDisposeProviderElement<String> createElement() {
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

mixin FamilyRef on AutoDisposeProviderRef<String> {
  /// The parameter `id` of this provider.
  int get id;
}

class _FamilyProviderElement extends AutoDisposeProviderElement<String>
    with FamilyRef {
  _FamilyProviderElement(super.provider);

  @override
  int get id => (origin as FamilyProvider).id;
}

String _$notCopiedFunctionalHash() =>
    r'30587ee9ceb75d5c8562015ad4a67ec0b107c1f6';

/// See also [notCopiedFunctional].
@ProviderFor(notCopiedFunctional)
final notCopiedFunctionalProvider = AutoDisposeProvider<String>.internal(
  notCopiedFunctional,
  name: r'notCopiedFunctionalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notCopiedFunctionalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotCopiedFunctionalRef = AutoDisposeProviderRef<String>;
String _$notCopiedFamilyHash() => r'6ef06ce6ebd73b476870bbe1af41c4f3fbe8ddb1';

/// See also [notCopiedFamily].
@ProviderFor(notCopiedFamily)
const notCopiedFamilyProvider = NotCopiedFamilyFamily();

/// See also [notCopiedFamily].
class NotCopiedFamilyFamily extends Family<String> {
  /// See also [notCopiedFamily].
  const NotCopiedFamilyFamily();

  /// See also [notCopiedFamily].
  NotCopiedFamilyProvider call(
    int id,
  ) {
    return NotCopiedFamilyProvider(
      id,
    );
  }

  @override
  NotCopiedFamilyProvider getProviderOverride(
    covariant NotCopiedFamilyProvider provider,
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
  String? get name => r'notCopiedFamilyProvider';
}

/// See also [notCopiedFamily].
class NotCopiedFamilyProvider extends AutoDisposeProvider<String> {
  /// See also [notCopiedFamily].
  NotCopiedFamilyProvider(
    int id,
  ) : this._internal(
          (ref) => notCopiedFamily(
            ref as NotCopiedFamilyRef,
            id,
          ),
          from: notCopiedFamilyProvider,
          name: r'notCopiedFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notCopiedFamilyHash,
          dependencies: NotCopiedFamilyFamily._dependencies,
          allTransitiveDependencies:
              NotCopiedFamilyFamily._allTransitiveDependencies,
          id: id,
        );

  NotCopiedFamilyProvider._internal(
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
    String Function(NotCopiedFamilyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotCopiedFamilyProvider._internal(
        (ref) => create(ref as NotCopiedFamilyRef),
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
  AutoDisposeProviderElement<String> createElement() {
    return _NotCopiedFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotCopiedFamilyProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NotCopiedFamilyRef on AutoDisposeProviderRef<String> {
  /// The parameter `id` of this provider.
  int get id;
}

class _NotCopiedFamilyProviderElement extends AutoDisposeProviderElement<String>
    with NotCopiedFamilyRef {
  _NotCopiedFamilyProviderElement(super.provider);

  @override
  int get id => (origin as NotCopiedFamilyProvider).id;
}

String _$classBasedHash() => r'622330ee6c6b3b384dde237a3beab1006d1bfbfc';

/// See also [ClassBased].
@ProviderFor(ClassBased)
@Deprecated('Deprecation message')
@experimental
@visibleForTesting
@protected
final classBasedProvider =
    AutoDisposeNotifierProvider<ClassBased, String>.internal(
  ClassBased.new,
  name: r'classBasedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$classBasedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ClassBased = AutoDisposeNotifier<String>;
String _$notCopiedClassBasedHash() =>
    r'd2aefd08a78e3bb4c02000d4931a3bf15c01b495';

/// See also [NotCopiedClassBased].
@ProviderFor(NotCopiedClassBased)
final notCopiedClassBasedProvider =
    AutoDisposeNotifierProvider<NotCopiedClassBased, String>.internal(
  NotCopiedClassBased.new,
  name: r'notCopiedClassBasedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notCopiedClassBasedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotCopiedClassBased = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
