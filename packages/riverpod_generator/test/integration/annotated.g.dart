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
String _$familyFunctionalHash() => r'6b9d086e1ade334a1fbf86d9908f4ffdb7d758c9';

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

/// See also [familyFunctional].
@ProviderFor(familyFunctional)
@Deprecated('Deprecation message')
@experimental
@visibleForTesting
@protected
const familyFunctionalProvider = FamilyFunctionalFamily();

/// See also [familyFunctional].
class FamilyFunctionalFamily extends Family<String> {
  /// See also [familyFunctional].
  const FamilyFunctionalFamily();

  /// See also [familyFunctional].
  FamilyFunctionalProvider call(
    int id,
  ) {
    return FamilyFunctionalProvider(
      id,
    );
  }

  @override
  FamilyFunctionalProvider getProviderOverride(
    covariant FamilyFunctionalProvider provider,
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
  String? get name => r'familyFunctionalProvider';
}

/// See also [familyFunctional].
class FamilyFunctionalProvider extends AutoDisposeProvider<String> {
  /// See also [familyFunctional].
  FamilyFunctionalProvider(
    int id,
  ) : this._internal(
          (ref) => familyFunctional(
            ref as FamilyFunctionalRef,
            id,
          ),
          from: familyFunctionalProvider,
          name: r'familyFunctionalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyFunctionalHash,
          dependencies: FamilyFunctionalFamily._dependencies,
          allTransitiveDependencies:
              FamilyFunctionalFamily._allTransitiveDependencies,
          id: id,
        );

  FamilyFunctionalProvider._internal(
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
    String Function(FamilyFunctionalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FamilyFunctionalProvider._internal(
        (ref) => create(ref as FamilyFunctionalRef),
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
    return _FamilyFunctionalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyFunctionalProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FamilyFunctionalRef on AutoDisposeProviderRef<String> {
  /// The parameter `id` of this provider.
  int get id;
}

class _FamilyFunctionalProviderElement
    extends AutoDisposeProviderElement<String> with FamilyFunctionalRef {
  _FamilyFunctionalProviderElement(super.provider);

  @override
  int get id => (origin as FamilyFunctionalProvider).id;
}

String _$notCopiedHash() => r'bddbed3b6d8142b47f44070b8edf12856a3a5ac0';

/// See also [notCopied].
@ProviderFor(notCopied)
final notCopiedProvider = AutoDisposeProvider<String>.internal(
  notCopied,
  name: r'notCopiedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$notCopiedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotCopiedRef = AutoDisposeProviderRef<String>;
String _$notCopiedFamilyHash() => r'798ae9f6b9d2baf700353b28d590258938e0684c';

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
String _$familyClassBasedHash() => r'aa9bcbd189b7883944e82ffba815520a2caaf96c';

abstract class _$FamilyClassBased extends BuildlessAutoDisposeNotifier<String> {
  late final int id;

  String build(
    int id,
  );
}

/// See also [FamilyClassBased].
@ProviderFor(FamilyClassBased)
@Deprecated('Deprecation message')
@experimental
@visibleForTesting
@protected
const familyClassBasedProvider = FamilyClassBasedFamily();

/// See also [FamilyClassBased].
class FamilyClassBasedFamily extends Family<String> {
  /// See also [FamilyClassBased].
  const FamilyClassBasedFamily();

  /// See also [FamilyClassBased].
  FamilyClassBasedProvider call(
    int id,
  ) {
    return FamilyClassBasedProvider(
      id,
    );
  }

  @override
  FamilyClassBasedProvider getProviderOverride(
    covariant FamilyClassBasedProvider provider,
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
  String? get name => r'familyClassBasedProvider';
}

/// See also [FamilyClassBased].
class FamilyClassBasedProvider
    extends AutoDisposeNotifierProviderImpl<FamilyClassBased, String> {
  /// See also [FamilyClassBased].
  FamilyClassBasedProvider(
    int id,
  ) : this._internal(
          () => FamilyClassBased()..id = id,
          from: familyClassBasedProvider,
          name: r'familyClassBasedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyClassBasedHash,
          dependencies: FamilyClassBasedFamily._dependencies,
          allTransitiveDependencies:
              FamilyClassBasedFamily._allTransitiveDependencies,
          id: id,
        );

  FamilyClassBasedProvider._internal(
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
  String runNotifierBuild(
    covariant FamilyClassBased notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(FamilyClassBased Function() create) {
    return ProviderOverride(
      origin: this,
      override: FamilyClassBasedProvider._internal(
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
  AutoDisposeNotifierProviderElement<FamilyClassBased, String> createElement() {
    return _FamilyClassBasedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyClassBasedProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FamilyClassBasedRef on AutoDisposeNotifierProviderRef<String> {
  /// The parameter `id` of this provider.
  int get id;
}

class _FamilyClassBasedProviderElement
    extends AutoDisposeNotifierProviderElement<FamilyClassBased, String>
    with FamilyClassBasedRef {
  _FamilyClassBasedProviderElement(super.provider);

  @override
  int get id => (origin as FamilyClassBasedProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
