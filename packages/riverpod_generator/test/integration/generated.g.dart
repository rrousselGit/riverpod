// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$generatedHash() => r'e49f3520d06ed50d34a44de613fdcd20b19f48d4';

/// See also [generated].
@ProviderFor(generated)
final generatedProvider = Provider<_Test>.internal(
  generated,
  name: r'generatedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$generatedHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GeneratedRef = Ref<_Test>;
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
final class GeneratedFamilyFamily extends Family {
  /// See also [generatedFamily].
  const GeneratedFamilyFamily()
      : super(
          name: r'generatedFamilyProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generatedFamilyHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [generatedFamily].
  GeneratedFamilyProvider call(
    _Test test,
  ) {
    return GeneratedFamilyProvider(
      test,
    );
  }

  @override
  String toString() => 'generatedFamilyProvider';
}

/// See also [generatedFamily].
final class GeneratedFamilyProvider extends Provider<_Test> {
  /// See also [generatedFamily].
  GeneratedFamilyProvider(
    _Test test,
  ) : this._internal(
          (ref) => generatedFamily(
            ref as GeneratedFamilyRef,
            test,
          ),
          argument: (test,),
        );

  GeneratedFamilyProvider._internal(
    super.create, {
    required (_Test,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generatedFamilyHash,
          from: generatedFamilyProvider,
          name: r'generatedFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _GeneratedFamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _GeneratedFamilyProviderElement(this, container);
  }

  @internal
  @override
  GeneratedFamilyProvider copyWithCreate(
    _Test Function(GeneratedFamilyRef ref) create,
  ) {
    return GeneratedFamilyProvider._internal(
      (ref) => create(ref as GeneratedFamilyRef),
      argument: argument as (_Test,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GeneratedFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'generatedFamilyProvider$argument';
}

mixin GeneratedFamilyRef on Ref<_Test> {
  /// The parameter `test` of this provider.
  _Test get test;
}

class _GeneratedFamilyProviderElement extends ProviderElement<_Test>
    with GeneratedFamilyRef {
  _GeneratedFamilyProviderElement(super.provider, super.container);

  @override
  _Test get test => (origin as GeneratedFamilyProvider).test;
}

String _$$dynamicHash() => r'f62d63d9340f30b253e687f76deacd8205fed0e7';

/// See also [$dynamic].
@ProviderFor($dynamic)
final $dynamicProvider = Provider<Object?>.internal(
  $dynamic,
  name: r'$dynamicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$$dynamicHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef $DynamicRef = Ref<Object?>;
String _$$dynamicFamilyHash() => r'b764133af8837b8321b08814892f198d4bc1aa18';

/// See also [$dynamicFamily].
@ProviderFor($dynamicFamily)
const $dynamicFamilyProvider = $DynamicFamilyFamily();

/// See also [$dynamicFamily].
final class $DynamicFamilyFamily extends Family {
  /// See also [$dynamicFamily].
  const $DynamicFamilyFamily()
      : super(
          name: r'$dynamicFamilyProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$$dynamicFamilyHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [$dynamicFamily].
  $DynamicFamilyProvider call(
    test,
  ) {
    return $DynamicFamilyProvider(
      test,
    );
  }

  @override
  String toString() => '\$dynamicFamilyProvider';
}

/// See also [$dynamicFamily].
final class $DynamicFamilyProvider extends Provider<Object?> {
  /// See also [$dynamicFamily].
  $DynamicFamilyProvider(
    test,
  ) : this._internal(
          (ref) => $dynamicFamily(
            ref as $DynamicFamilyRef,
            test,
          ),
          argument: (test,),
        );

  $DynamicFamilyProvider._internal(
    super.create, {
    required (dynamic,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$$dynamicFamilyHash,
          from: $dynamicFamilyProvider,
          name: r'$dynamicFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _$DynamicFamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _$DynamicFamilyProviderElement(this, container);
  }

  @internal
  @override
  $DynamicFamilyProvider copyWithCreate(
    Object? Function($DynamicFamilyRef ref) create,
  ) {
    return $DynamicFamilyProvider._internal(
      (ref) => create(ref as $DynamicFamilyRef),
      argument: argument as (dynamic,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is $DynamicFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => '\$dynamicFamilyProvider$argument';
}

mixin $DynamicFamilyRef on Ref<Object?> {
  /// The parameter `test` of this provider.
  get test;
}

class _$DynamicFamilyProviderElement extends ProviderElement<Object?>
    with $DynamicFamilyRef {
  _$DynamicFamilyProviderElement(super.provider, super.container);

  @override
  get test => (origin as $DynamicFamilyProvider).test;
}

String _$dynamicHash() => r'da9dc07960139fff2cf5fe584dca5c524e4f2308';

/// See also [_dynamic].
@ProviderFor(_dynamic)
const _dynamicProvider = _DynamicFamily();

/// See also [_dynamic].
final class _DynamicFamily extends Family {
  /// See also [_dynamic].
  const _DynamicFamily()
      : super(
          name: r'_dynamicProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dynamicHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [_dynamic].
  _DynamicProvider call(
    test,
  ) {
    return _DynamicProvider(
      test,
    );
  }

  @override
  String toString() => '_dynamicProvider';
}

/// See also [_dynamic].
final class _DynamicProvider extends Provider<Object?> {
  /// See also [_dynamic].
  _DynamicProvider(
    test,
  ) : this._internal(
          (ref) => _dynamic(
            ref as _DynamicRef,
            test,
          ),
          argument: (test,),
        );

  _DynamicProvider._internal(
    super.create, {
    required (dynamic,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dynamicHash,
          from: _dynamicProvider,
          name: r'_dynamicProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _DynamicProviderElement createElement(
    ProviderContainer container,
  ) {
    return _DynamicProviderElement(this, container);
  }

  @internal
  @override
  _DynamicProvider copyWithCreate(
    Object? Function(_DynamicRef ref) create,
  ) {
    return _DynamicProvider._internal(
      (ref) => create(ref as _DynamicRef),
      argument: argument as (dynamic,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _DynamicProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => '_dynamicProvider$argument';
}

mixin _DynamicRef on Ref<Object?> {
  /// The parameter `test` of this provider.
  get test;
}

class _DynamicProviderElement extends ProviderElement<Object?>
    with _DynamicRef {
  _DynamicProviderElement(super.provider, super.container);

  @override
  get test => (origin as _DynamicProvider).test;
}

String _$aliasHash() => r'cc08ec4cc5ec0dc98bdb7f4dcbc035021b09bcf3';

/// See also [alias].
@ProviderFor(alias)
final aliasProvider = Provider<r.AsyncValue<int>>.internal(
  alias,
  name: r'aliasProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aliasHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AliasRef = Ref<r.AsyncValue<int>>;
String _$aliasFamilyHash() => r'f345937d5750132f629aef41646b119a301f750b';

/// See also [aliasFamily].
@ProviderFor(aliasFamily)
const aliasFamilyProvider = AliasFamilyFamily();

/// See also [aliasFamily].
final class AliasFamilyFamily extends Family {
  /// See also [aliasFamily].
  const AliasFamilyFamily()
      : super(
          name: r'aliasFamilyProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$aliasFamilyHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [aliasFamily].
  AliasFamilyProvider call(
    r.AsyncValue<int> test,
  ) {
    return AliasFamilyProvider(
      test,
    );
  }

  @override
  String toString() => 'aliasFamilyProvider';
}

/// See also [aliasFamily].
final class AliasFamilyProvider extends Provider<r.AsyncValue<int>> {
  /// See also [aliasFamily].
  AliasFamilyProvider(
    r.AsyncValue<int> test,
  ) : this._internal(
          (ref) => aliasFamily(
            ref as AliasFamilyRef,
            test,
          ),
          argument: (test,),
        );

  AliasFamilyProvider._internal(
    super.create, {
    required (r.AsyncValue<int>,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$aliasFamilyHash,
          from: aliasFamilyProvider,
          name: r'aliasFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _AliasFamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _AliasFamilyProviderElement(this, container);
  }

  @internal
  @override
  AliasFamilyProvider copyWithCreate(
    r.AsyncValue<int> Function(AliasFamilyRef ref) create,
  ) {
    return AliasFamilyProvider._internal(
      (ref) => create(ref as AliasFamilyRef),
      argument: argument as (r.AsyncValue<int>,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AliasFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'aliasFamilyProvider$argument';
}

mixin AliasFamilyRef on Ref<r.AsyncValue<int>> {
  /// The parameter `test` of this provider.
  r.AsyncValue<int> get test;
}

class _AliasFamilyProviderElement extends ProviderElement<r.AsyncValue<int>>
    with AliasFamilyRef {
  _AliasFamilyProviderElement(super.provider, super.container);

  @override
  r.AsyncValue<int> get test => (origin as AliasFamilyProvider).test;
}

String _$generatedClassHash() => r'984153f97e25de687d2f19756b277aabd56f6e72';

/// See also [GeneratedClass].
@ProviderFor(GeneratedClass)
final generatedClassProvider = NotifierProvider<GeneratedClass, _Test>.internal(
  GeneratedClass.new,
  name: r'generatedClassProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$generatedClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GeneratedClass = Notifier<_Test>;
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
final class GeneratedClassFamilyFamily extends Family {
  /// See also [GeneratedClassFamily].
  const GeneratedClassFamilyFamily()
      : super(
          name: r'generatedClassFamilyProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generatedClassFamilyHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [GeneratedClassFamily].
  GeneratedClassFamilyProvider call(
    _Test test,
  ) {
    return GeneratedClassFamilyProvider(
      test,
    );
  }

  @override
  String toString() => 'generatedClassFamilyProvider';
}

/// See also [GeneratedClassFamily].
final class GeneratedClassFamilyProvider
    extends AutoDisposeNotifierProviderImpl<GeneratedClassFamily, _Test> {
  /// See also [GeneratedClassFamily].
  GeneratedClassFamilyProvider(
    _Test test,
  ) : this._internal(
          () => GeneratedClassFamily()..test = test,
          argument: (test,),
        );

  GeneratedClassFamilyProvider._internal(
    super.create, {
    required (_Test,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generatedClassFamilyHash,
          from: generatedClassFamilyProvider,
          name: r'generatedClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _Test runNotifierBuild(
    covariant GeneratedClassFamily notifier,
  ) {
    return notifier.build(
      test,
    );
  }

  @internal
  @override
  AutoDisposeNotifierProviderImpl copyWithBuild(
    GeneratedClassFamily Function() create,
  ) {
    return AutoDisposeNotifierProviderImpl._internal(
      create,
      test: test,
    );
  }

  @override
  _GeneratedClassFamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _GeneratedClassFamilyProviderElement(this, container);
  }

  @internal
  @override
  GeneratedClassFamilyProvider copyWithCreate(
    GeneratedClassFamily Function() create,
  ) {
    return GeneratedClassFamilyProvider._internal(
      () => create()..test = test,
      argument: argument as (_Test,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GeneratedClassFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'generatedClassFamilyProvider$argument';
}

mixin GeneratedClassFamilyRef on AutoDisposeNotifierProviderRef {
  /// The parameter `test` of this provider.
  _Test get test;
}

class _GeneratedClassFamilyProviderElement
    extends AutoDisposeNotifierProviderElement<GeneratedClassFamily, _Test>
    with GeneratedClassFamilyRef {
  _GeneratedClassFamilyProviderElement(super.provider, super.container);

  @override
  _Test get test => (origin as GeneratedClassFamilyProvider).test;
}

String _$$dynamicClassHash() => r'c6d8e5191c3f060df3ce3eee66107433fd4c3292';

/// See also [$DynamicClass].
@ProviderFor($DynamicClass)
final $dynamicClassProvider = NotifierProvider<$DynamicClass, Object?>.internal(
  $DynamicClass.new,
  name: r'$dynamicClassProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$$dynamicClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$$DynamicClass = Notifier<Object?>;
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
final class $DynamicClassFamilyFamily extends Family {
  /// See also [$DynamicClassFamily].
  const $DynamicClassFamilyFamily()
      : super(
          name: r'$dynamicClassFamilyProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$$dynamicClassFamilyHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [$DynamicClassFamily].
  $DynamicClassFamilyProvider call(
    test,
  ) {
    return $DynamicClassFamilyProvider(
      test,
    );
  }

  @override
  String toString() => '\$dynamicClassFamilyProvider';
}

/// See also [$DynamicClassFamily].
final class $DynamicClassFamilyProvider
    extends AutoDisposeNotifierProviderImpl<$DynamicClassFamily, Object?> {
  /// See also [$DynamicClassFamily].
  $DynamicClassFamilyProvider(
    test,
  ) : this._internal(
          () => $DynamicClassFamily()..test = test,
          argument: (test,),
        );

  $DynamicClassFamilyProvider._internal(
    super.create, {
    required (dynamic,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$$dynamicClassFamilyHash,
          from: $dynamicClassFamilyProvider,
          name: r'$dynamicClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  Object? runNotifierBuild(
    covariant $DynamicClassFamily notifier,
  ) {
    return notifier.build(
      test,
    );
  }

  @internal
  @override
  AutoDisposeNotifierProviderImpl copyWithBuild(
    $DynamicClassFamily Function() create,
  ) {
    return AutoDisposeNotifierProviderImpl._internal(
      create,
      test: test,
    );
  }

  @override
  _$DynamicClassFamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _$DynamicClassFamilyProviderElement(this, container);
  }

  @internal
  @override
  $DynamicClassFamilyProvider copyWithCreate(
    $DynamicClassFamily Function() create,
  ) {
    return $DynamicClassFamilyProvider._internal(
      () => create()..test = test,
      argument: argument as (dynamic,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is $DynamicClassFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => '\$dynamicClassFamilyProvider$argument';
}

mixin $DynamicClassFamilyRef on AutoDisposeNotifierProviderRef {
  /// The parameter `test` of this provider.
  get test;
}

class _$DynamicClassFamilyProviderElement
    extends AutoDisposeNotifierProviderElement<$DynamicClassFamily, Object?>
    with $DynamicClassFamilyRef {
  _$DynamicClassFamilyProviderElement(super.provider, super.container);

  @override
  get test => (origin as $DynamicClassFamilyProvider).test;
}

String _$aliasClassHash() => r'a6c6d7594ebd09ba728e42d79b12af560d09c379';

/// See also [AliasClass].
@ProviderFor(AliasClass)
final aliasClassProvider =
    NotifierProvider<AliasClass, r.AsyncValue<int>>.internal(
  AliasClass.new,
  name: r'aliasClassProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aliasClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AliasClass = Notifier<r.AsyncValue<int>>;
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
final class AliasClassFamilyFamily extends Family {
  /// See also [AliasClassFamily].
  const AliasClassFamilyFamily()
      : super(
          name: r'aliasClassFamilyProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$aliasClassFamilyHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [AliasClassFamily].
  AliasClassFamilyProvider call(
    r.AsyncValue<int> test,
  ) {
    return AliasClassFamilyProvider(
      test,
    );
  }

  @override
  String toString() => 'aliasClassFamilyProvider';
}

/// See also [AliasClassFamily].
final class AliasClassFamilyProvider extends AutoDisposeNotifierProviderImpl<
    AliasClassFamily, r.AsyncValue<int>> {
  /// See also [AliasClassFamily].
  AliasClassFamilyProvider(
    r.AsyncValue<int> test,
  ) : this._internal(
          () => AliasClassFamily()..test = test,
          argument: (test,),
        );

  AliasClassFamilyProvider._internal(
    super.create, {
    required (r.AsyncValue<int>,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$aliasClassFamilyHash,
          from: aliasClassFamilyProvider,
          name: r'aliasClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  r.AsyncValue<int> runNotifierBuild(
    covariant AliasClassFamily notifier,
  ) {
    return notifier.build(
      test,
    );
  }

  @internal
  @override
  AutoDisposeNotifierProviderImpl copyWithBuild(
    AliasClassFamily Function() create,
  ) {
    return AutoDisposeNotifierProviderImpl._internal(
      create,
      test: test,
    );
  }

  @override
  _AliasClassFamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _AliasClassFamilyProviderElement(this, container);
  }

  @internal
  @override
  AliasClassFamilyProvider copyWithCreate(
    AliasClassFamily Function() create,
  ) {
    return AliasClassFamilyProvider._internal(
      () => create()..test = test,
      argument: argument as (r.AsyncValue<int>,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AliasClassFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'aliasClassFamilyProvider$argument';
}

mixin AliasClassFamilyRef on AutoDisposeNotifierProviderRef {
  /// The parameter `test` of this provider.
  r.AsyncValue<int> get test;
}

class _AliasClassFamilyProviderElement
    extends AutoDisposeNotifierProviderElement<AliasClassFamily,
        r.AsyncValue<int>> with AliasClassFamilyRef {
  _AliasClassFamilyProviderElement(super.provider, super.container);

  @override
  r.AsyncValue<int> get test => (origin as AliasClassFamilyProvider).test;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
