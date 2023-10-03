// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$generatedHash() => r'e49f3520d06ed50d34a44de613fdcd20b19f48d4';

/// See also [generated].
@ProviderFor(generated)
final generatedProvider = AutoDisposeProvider<_Test>.internal(
  generated,
  name: r'generatedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$generatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GeneratedRef = AutoDisposeProviderRef<_Test>;
String _$generatedFamilyHash() => r'ed284f58926c87acc81dab9168882d5d1c2cddf8';

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

/// See also [generatedFamily].
@ProviderFor(generatedFamily)
const generatedFamilyProvider = GeneratedFamilyFamily();

/// See also [generatedFamily].
class GeneratedFamilyFamily extends Family<_Test> {
  /// See also [generatedFamily].
  const GeneratedFamilyFamily();

  /// See also [generatedFamily].
  GeneratedFamilyProvider call(
    _Test test,
  ) {
    return GeneratedFamilyProvider(
      test,
    );
  }

  @visibleForOverriding
  @override
  GeneratedFamilyProvider getProviderOverride(
    covariant GeneratedFamilyProvider provider,
  ) {
    return call(
      provider.test,
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
  String? get name => r'generatedFamilyProvider';
}

/// See also [generatedFamily].
class GeneratedFamilyProvider extends AutoDisposeProvider<_Test> {
  /// See also [generatedFamily].
  GeneratedFamilyProvider(
    _Test test,
  ) : this._internal(
          (ref) => generatedFamily(
            ref as GeneratedFamilyRef,
            test,
          ),
          from: generatedFamilyProvider,
          name: r'generatedFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generatedFamilyHash,
          dependencies: GeneratedFamilyFamily._dependencies,
          allTransitiveDependencies:
              GeneratedFamilyFamily._allTransitiveDependencies,
          test: test,
        );

  GeneratedFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.test,
  }) : super.internal();

  final _Test test;

  @override
  Override overrideWith(
    _Test Function(GeneratedFamilyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GeneratedFamilyProvider._internal(
        (ref) => create(ref as GeneratedFamilyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        test: test,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<_Test> createElement() {
    return _GeneratedFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GeneratedFamilyProvider && other.test == test;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, test.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GeneratedFamilyRef on AutoDisposeProviderRef<_Test> {
  /// The parameter `test` of this provider.
  _Test get test;
}

class _GeneratedFamilyProviderElement extends AutoDisposeProviderElement<_Test>
    with GeneratedFamilyRef {
  _GeneratedFamilyProviderElement(super.provider);

  @override
  _Test get test => (origin as GeneratedFamilyProvider).test;
}

String _$$dynamicHash() => r'f62d63d9340f30b253e687f76deacd8205fed0e7';

/// See also [$dynamic].
@ProviderFor($dynamic)
final $dynamicProvider = AutoDisposeProvider<Object?>.internal(
  $dynamic,
  name: r'$dynamicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$$dynamicHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef $DynamicRef = AutoDisposeProviderRef<Object?>;
String _$$dynamicFamilyHash() => r'b764133af8837b8321b08814892f198d4bc1aa18';

/// See also [$dynamicFamily].
@ProviderFor($dynamicFamily)
const $dynamicFamilyProvider = $DynamicFamilyFamily();

/// See also [$dynamicFamily].
class $DynamicFamilyFamily extends Family<Object?> {
  /// See also [$dynamicFamily].
  const $DynamicFamilyFamily();

  /// See also [$dynamicFamily].
  $DynamicFamilyProvider call(
    test,
  ) {
    return $DynamicFamilyProvider(
      test,
    );
  }

  @visibleForOverriding
  @override
  $DynamicFamilyProvider getProviderOverride(
    covariant $DynamicFamilyProvider provider,
  ) {
    return call(
      provider.test,
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
  String? get name => r'$dynamicFamilyProvider';
}

/// See also [$dynamicFamily].
class $DynamicFamilyProvider extends AutoDisposeProvider<Object?> {
  /// See also [$dynamicFamily].
  $DynamicFamilyProvider(
    test,
  ) : this._internal(
          (ref) => $dynamicFamily(
            ref as $DynamicFamilyRef,
            test,
          ),
          from: $dynamicFamilyProvider,
          name: r'$dynamicFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$$dynamicFamilyHash,
          dependencies: $DynamicFamilyFamily._dependencies,
          allTransitiveDependencies:
              $DynamicFamilyFamily._allTransitiveDependencies,
          test: test,
        );

  $DynamicFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.test,
  }) : super.internal();

  final test;

  @override
  Override overrideWith(
    Object? Function($DynamicFamilyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: $DynamicFamilyProvider._internal(
        (ref) => create(ref as $DynamicFamilyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        test: test,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Object?> createElement() {
    return _$DynamicFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is $DynamicFamilyProvider && other.test == test;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, test.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin $DynamicFamilyRef on AutoDisposeProviderRef<Object?> {
  /// The parameter `test` of this provider.
  get test;
}

class _$DynamicFamilyProviderElement extends AutoDisposeProviderElement<Object?>
    with $DynamicFamilyRef {
  _$DynamicFamilyProviderElement(super.provider);

  @override
  get test => (origin as $DynamicFamilyProvider).test;
}

String _$dynamicHash() => r'da9dc07960139fff2cf5fe584dca5c524e4f2308';

/// See also [_dynamic].
@ProviderFor(_dynamic)
const _dynamicProvider = _DynamicFamily();

/// See also [_dynamic].
class _DynamicFamily extends Family<Object?> {
  /// See also [_dynamic].
  const _DynamicFamily();

  /// See also [_dynamic].
  _DynamicProvider call(
    test,
  ) {
    return _DynamicProvider(
      test,
    );
  }

  @visibleForOverriding
  @override
  _DynamicProvider getProviderOverride(
    covariant _DynamicProvider provider,
  ) {
    return call(
      provider.test,
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
  String? get name => r'_dynamicProvider';
}

/// See also [_dynamic].
class _DynamicProvider extends AutoDisposeProvider<Object?> {
  /// See also [_dynamic].
  _DynamicProvider(
    test,
  ) : this._internal(
          (ref) => _dynamic(
            ref as _DynamicRef,
            test,
          ),
          from: _dynamicProvider,
          name: r'_dynamicProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dynamicHash,
          dependencies: _DynamicFamily._dependencies,
          allTransitiveDependencies: _DynamicFamily._allTransitiveDependencies,
          test: test,
        );

  _DynamicProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.test,
  }) : super.internal();

  final test;

  @override
  Override overrideWith(
    Object? Function(_DynamicRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _DynamicProvider._internal(
        (ref) => create(ref as _DynamicRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        test: test,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Object?> createElement() {
    return _DynamicProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _DynamicProvider && other.test == test;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, test.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _DynamicRef on AutoDisposeProviderRef<Object?> {
  /// The parameter `test` of this provider.
  get test;
}

class _DynamicProviderElement extends AutoDisposeProviderElement<Object?>
    with _DynamicRef {
  _DynamicProviderElement(super.provider);

  @override
  get test => (origin as _DynamicProvider).test;
}

String _$aliasHash() => r'cc08ec4cc5ec0dc98bdb7f4dcbc035021b09bcf3';

/// See also [alias].
@ProviderFor(alias)
final aliasProvider = AutoDisposeProvider<r.AsyncValue<int>>.internal(
  alias,
  name: r'aliasProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aliasHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AliasRef = AutoDisposeProviderRef<r.AsyncValue<int>>;
String _$aliasFamilyHash() => r'f345937d5750132f629aef41646b119a301f750b';

/// See also [aliasFamily].
@ProviderFor(aliasFamily)
const aliasFamilyProvider = AliasFamilyFamily();

/// See also [aliasFamily].
class AliasFamilyFamily extends Family<r.AsyncValue<int>> {
  /// See also [aliasFamily].
  const AliasFamilyFamily();

  /// See also [aliasFamily].
  AliasFamilyProvider call(
    r.AsyncValue<int> test,
  ) {
    return AliasFamilyProvider(
      test,
    );
  }

  @visibleForOverriding
  @override
  AliasFamilyProvider getProviderOverride(
    covariant AliasFamilyProvider provider,
  ) {
    return call(
      provider.test,
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
  String? get name => r'aliasFamilyProvider';
}

/// See also [aliasFamily].
class AliasFamilyProvider extends AutoDisposeProvider<r.AsyncValue<int>> {
  /// See also [aliasFamily].
  AliasFamilyProvider(
    r.AsyncValue<int> test,
  ) : this._internal(
          (ref) => aliasFamily(
            ref as AliasFamilyRef,
            test,
          ),
          from: aliasFamilyProvider,
          name: r'aliasFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$aliasFamilyHash,
          dependencies: AliasFamilyFamily._dependencies,
          allTransitiveDependencies:
              AliasFamilyFamily._allTransitiveDependencies,
          test: test,
        );

  AliasFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.test,
  }) : super.internal();

  final r.AsyncValue<int> test;

  @override
  Override overrideWith(
    r.AsyncValue<int> Function(AliasFamilyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AliasFamilyProvider._internal(
        (ref) => create(ref as AliasFamilyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        test: test,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<r.AsyncValue<int>> createElement() {
    return _AliasFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AliasFamilyProvider && other.test == test;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, test.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AliasFamilyRef on AutoDisposeProviderRef<r.AsyncValue<int>> {
  /// The parameter `test` of this provider.
  r.AsyncValue<int> get test;
}

class _AliasFamilyProviderElement
    extends AutoDisposeProviderElement<r.AsyncValue<int>> with AliasFamilyRef {
  _AliasFamilyProviderElement(super.provider);

  @override
  r.AsyncValue<int> get test => (origin as AliasFamilyProvider).test;
}

String _$generatedClassHash() => r'984153f97e25de687d2f19756b277aabd56f6e72';

/// See also [GeneratedClass].
@ProviderFor(GeneratedClass)
final generatedClassProvider =
    AutoDisposeNotifierProvider<GeneratedClass, _Test>.internal(
  GeneratedClass.new,
  name: r'generatedClassProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$generatedClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GeneratedClass = AutoDisposeNotifier<_Test>;
String _$generatedClassFamilyHash() =>
    r'28d0a5a82af5b254f6ef07b492916e2feb7e6e63';

abstract class _$GeneratedClassFamily
    extends BuildlessAutoDisposeNotifier<_Test> {
  late final _Test test;

  _Test build(
    _Test test,
  );
}

/// See also [GeneratedClassFamily].
@ProviderFor(GeneratedClassFamily)
const generatedClassFamilyProvider = GeneratedClassFamilyFamily();

/// See also [GeneratedClassFamily].
class GeneratedClassFamilyFamily extends Family<_Test> {
  /// See also [GeneratedClassFamily].
  const GeneratedClassFamilyFamily();

  /// See also [GeneratedClassFamily].
  GeneratedClassFamilyProvider call(
    _Test test,
  ) {
    return GeneratedClassFamilyProvider(
      test,
    );
  }

  @visibleForOverriding
  @override
  GeneratedClassFamilyProvider getProviderOverride(
    covariant GeneratedClassFamilyProvider provider,
  ) {
    return call(
      provider.test,
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
  String? get name => r'generatedClassFamilyProvider';
}

/// See also [GeneratedClassFamily].
class GeneratedClassFamilyProvider
    extends AutoDisposeNotifierProviderImpl<GeneratedClassFamily, _Test> {
  /// See also [GeneratedClassFamily].
  GeneratedClassFamilyProvider(
    _Test test,
  ) : this._internal(
          () => GeneratedClassFamily()..test = test,
          from: generatedClassFamilyProvider,
          name: r'generatedClassFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generatedClassFamilyHash,
          dependencies: GeneratedClassFamilyFamily._dependencies,
          allTransitiveDependencies:
              GeneratedClassFamilyFamily._allTransitiveDependencies,
          test: test,
        );

  GeneratedClassFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.test,
  }) : super.internal();

  final _Test test;

  @override
  _Test runNotifierBuild(
    covariant GeneratedClassFamily notifier,
  ) {
    return notifier.build(
      test,
    );
  }

  @override
  Override overrideWith(GeneratedClassFamily Function() create) {
    return ProviderOverride(
      origin: this,
      override: GeneratedClassFamilyProvider._internal(
        () => create()..test = test,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        test: test,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<GeneratedClassFamily, _Test>
      createElement() {
    return _GeneratedClassFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GeneratedClassFamilyProvider && other.test == test;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, test.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GeneratedClassFamilyRef on AutoDisposeNotifierProviderRef<_Test> {
  /// The parameter `test` of this provider.
  _Test get test;
}

class _GeneratedClassFamilyProviderElement
    extends AutoDisposeNotifierProviderElement<GeneratedClassFamily, _Test>
    with GeneratedClassFamilyRef {
  _GeneratedClassFamilyProviderElement(super.provider);

  @override
  _Test get test => (origin as GeneratedClassFamilyProvider).test;
}

String _$$dynamicClassHash() => r'c6d8e5191c3f060df3ce3eee66107433fd4c3292';

/// See also [$DynamicClass].
@ProviderFor($DynamicClass)
final $dynamicClassProvider =
    AutoDisposeNotifierProvider<$DynamicClass, Object?>.internal(
  $DynamicClass.new,
  name: r'$dynamicClassProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$$dynamicClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$$DynamicClass = AutoDisposeNotifier<Object?>;
String _$$dynamicClassFamilyHash() =>
    r'bdda961386f3b647c071d79293a8da441580c470';

abstract class _$$DynamicClassFamily
    extends BuildlessAutoDisposeNotifier<Object?> {
  late final test;

  Object? build(
    test,
  );
}

/// See also [$DynamicClassFamily].
@ProviderFor($DynamicClassFamily)
const $dynamicClassFamilyProvider = $DynamicClassFamilyFamily();

/// See also [$DynamicClassFamily].
class $DynamicClassFamilyFamily extends Family<Object?> {
  /// See also [$DynamicClassFamily].
  const $DynamicClassFamilyFamily();

  /// See also [$DynamicClassFamily].
  $DynamicClassFamilyProvider call(
    test,
  ) {
    return $DynamicClassFamilyProvider(
      test,
    );
  }

  @visibleForOverriding
  @override
  $DynamicClassFamilyProvider getProviderOverride(
    covariant $DynamicClassFamilyProvider provider,
  ) {
    return call(
      provider.test,
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
  String? get name => r'$dynamicClassFamilyProvider';
}

/// See also [$DynamicClassFamily].
class $DynamicClassFamilyProvider
    extends AutoDisposeNotifierProviderImpl<$DynamicClassFamily, Object?> {
  /// See also [$DynamicClassFamily].
  $DynamicClassFamilyProvider(
    test,
  ) : this._internal(
          () => $DynamicClassFamily()..test = test,
          from: $dynamicClassFamilyProvider,
          name: r'$dynamicClassFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$$dynamicClassFamilyHash,
          dependencies: $DynamicClassFamilyFamily._dependencies,
          allTransitiveDependencies:
              $DynamicClassFamilyFamily._allTransitiveDependencies,
          test: test,
        );

  $DynamicClassFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.test,
  }) : super.internal();

  final test;

  @override
  Object? runNotifierBuild(
    covariant $DynamicClassFamily notifier,
  ) {
    return notifier.build(
      test,
    );
  }

  @override
  Override overrideWith($DynamicClassFamily Function() create) {
    return ProviderOverride(
      origin: this,
      override: $DynamicClassFamilyProvider._internal(
        () => create()..test = test,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        test: test,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<$DynamicClassFamily, Object?>
      createElement() {
    return _$DynamicClassFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is $DynamicClassFamilyProvider && other.test == test;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, test.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin $DynamicClassFamilyRef on AutoDisposeNotifierProviderRef<Object?> {
  /// The parameter `test` of this provider.
  get test;
}

class _$DynamicClassFamilyProviderElement
    extends AutoDisposeNotifierProviderElement<$DynamicClassFamily, Object?>
    with $DynamicClassFamilyRef {
  _$DynamicClassFamilyProviderElement(super.provider);

  @override
  get test => (origin as $DynamicClassFamilyProvider).test;
}

String _$aliasClassHash() => r'a6c6d7594ebd09ba728e42d79b12af560d09c379';

/// See also [AliasClass].
@ProviderFor(AliasClass)
final aliasClassProvider =
    AutoDisposeNotifierProvider<AliasClass, r.AsyncValue<int>>.internal(
  AliasClass.new,
  name: r'aliasClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aliasClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AliasClass = AutoDisposeNotifier<r.AsyncValue<int>>;
String _$aliasClassFamilyHash() => r'3f348beb95dae3a9890b4a4d0ce01481316fc66d';

abstract class _$AliasClassFamily
    extends BuildlessAutoDisposeNotifier<r.AsyncValue<int>> {
  late final r.AsyncValue<int> test;

  r.AsyncValue<int> build(
    r.AsyncValue<int> test,
  );
}

/// See also [AliasClassFamily].
@ProviderFor(AliasClassFamily)
const aliasClassFamilyProvider = AliasClassFamilyFamily();

/// See also [AliasClassFamily].
class AliasClassFamilyFamily extends Family<r.AsyncValue<int>> {
  /// See also [AliasClassFamily].
  const AliasClassFamilyFamily();

  /// See also [AliasClassFamily].
  AliasClassFamilyProvider call(
    r.AsyncValue<int> test,
  ) {
    return AliasClassFamilyProvider(
      test,
    );
  }

  @visibleForOverriding
  @override
  AliasClassFamilyProvider getProviderOverride(
    covariant AliasClassFamilyProvider provider,
  ) {
    return call(
      provider.test,
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
  String? get name => r'aliasClassFamilyProvider';
}

/// See also [AliasClassFamily].
class AliasClassFamilyProvider extends AutoDisposeNotifierProviderImpl<
    AliasClassFamily, r.AsyncValue<int>> {
  /// See also [AliasClassFamily].
  AliasClassFamilyProvider(
    r.AsyncValue<int> test,
  ) : this._internal(
          () => AliasClassFamily()..test = test,
          from: aliasClassFamilyProvider,
          name: r'aliasClassFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$aliasClassFamilyHash,
          dependencies: AliasClassFamilyFamily._dependencies,
          allTransitiveDependencies:
              AliasClassFamilyFamily._allTransitiveDependencies,
          test: test,
        );

  AliasClassFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.test,
  }) : super.internal();

  final r.AsyncValue<int> test;

  @override
  r.AsyncValue<int> runNotifierBuild(
    covariant AliasClassFamily notifier,
  ) {
    return notifier.build(
      test,
    );
  }

  @override
  Override overrideWith(AliasClassFamily Function() create) {
    return ProviderOverride(
      origin: this,
      override: AliasClassFamilyProvider._internal(
        () => create()..test = test,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        test: test,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AliasClassFamily, r.AsyncValue<int>>
      createElement() {
    return _AliasClassFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AliasClassFamilyProvider && other.test == test;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, test.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AliasClassFamilyRef on AutoDisposeNotifierProviderRef<r.AsyncValue<int>> {
  /// The parameter `test` of this provider.
  r.AsyncValue<int> get test;
}

class _AliasClassFamilyProviderElement
    extends AutoDisposeNotifierProviderElement<AliasClassFamily,
        r.AsyncValue<int>> with AliasClassFamilyRef {
  _AliasClassFamilyProviderElement(super.provider);

  @override
  r.AsyncValue<int> get test => (origin as AliasClassFamilyProvider).test;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter
