// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier_extends.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myNotifierHash() => r'58f5439a3b1036ba7804f63a5a6ebe0114125039';

/// See also [MyNotifier].
@ProviderFor(MyNotifier)
final myNotifierProvider =
    AutoDisposeNotifierProvider<MyNotifier, int>.internal(
  MyNotifier.new,
  name: r'myNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyNotifier = AutoDisposeNotifier<int>;
String _$noExtendsHash() => r'3f1276999a9a6d3676c628c25ed853cbefb21ce9';

/// See also [NoExtends].
@ProviderFor(NoExtends)
final noExtendsProvider = AutoDisposeNotifierProvider<NoExtends, int>.internal(
  NoExtends.new,
  name: r'noExtendsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$noExtendsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NoExtends = AutoDisposeNotifier<int>;
String _$wrongExtendsHash() => r'6479055793af10a34e225373a67f7eaac4d7c0de';

/// See also [WrongExtends].
@ProviderFor(WrongExtends)
final wrongExtendsProvider =
    AutoDisposeNotifierProvider<WrongExtends, int>.internal(
  WrongExtends.new,
  name: r'wrongExtendsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$wrongExtendsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WrongExtends = AutoDisposeNotifier<int>;
String _$privateClassHash() => r'ba68a29a609566bb8bc0792391f842762356e124';

/// See also [_PrivateClass].
@ProviderFor(_PrivateClass)
final _privateClassProvider =
    AutoDisposeNotifierProvider<_PrivateClass, String>.internal(
  _PrivateClass.new,
  name: r'_privateClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PrivateClass = AutoDisposeNotifier<String>;
String _$genericsHash() => r'0a1bf00e0610ccb1fb5615460e1bc4afb2555f69';

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

abstract class _$Generics<A extends num, B>
    extends BuildlessAutoDisposeNotifier<int> {
  int build();
}

/// See also [Generics].
@ProviderFor(Generics)
const genericsProvider = GenericsFamily();

/// See also [Generics].
class GenericsFamily extends Family {
  /// See also [Generics].
  const GenericsFamily();

  /// See also [Generics].
  GenericsProvider<A, B> call<A extends num, B>() {
    return GenericsProvider<A, B>();
  }

  @override
  GenericsProvider<num, Object?> getProviderOverride(
    covariant GenericsProvider<num, Object?> provider,
  ) {
    return call();
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'genericsProvider';
}

/// See also [Generics].
class GenericsProvider<A extends num, B>
    extends AutoDisposeNotifierProviderImpl<Generics<A, B>, int> {
  /// See also [Generics].
  GenericsProvider()
      : this._internal(
          Generics<A, B>.new,
          from: genericsProvider,
          name: r'genericsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericsHash,
          dependencies: GenericsFamily._dependencies,
          allTransitiveDependencies: GenericsFamily._allTransitiveDependencies,
        );

  GenericsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  int runNotifierBuild(
    covariant Generics<A, B> notifier,
  ) {
    return notifier.build();
  }

  @override
  Override overrideWith(Generics<A, B> Function() create) {
    return ProviderOverride(
      origin: this,
      override: GenericsProvider<A, B>._internal(
        () => create(),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Generics<A, B>, int> createElement() {
    return _GenericsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenericsProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, A.hashCode);
    hash = _SystemHash.combine(hash, B.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GenericsRef<A extends num, B> on AutoDisposeNotifierProviderRef<int> {}

class _GenericsProviderElement<A extends num, B>
    extends AutoDisposeNotifierProviderElement<Generics<A, B>, int>
    with GenericsRef<A, B> {
  _GenericsProviderElement(super.provider);
}

String _$noGenericsHash() => r'30d5d20092f43cb17ede1f619773757df7cecb30';

abstract class _$NoGenerics<A extends num, B>
    extends BuildlessAutoDisposeNotifier<int> {
  int build();
}

/// See also [NoGenerics].
@ProviderFor(NoGenerics)
const noGenericsProvider = NoGenericsFamily();

/// See also [NoGenerics].
class NoGenericsFamily extends Family {
  /// See also [NoGenerics].
  const NoGenericsFamily();

  /// See also [NoGenerics].
  NoGenericsProvider<A, B> call<A extends num, B>() {
    return NoGenericsProvider<A, B>();
  }

  @override
  NoGenericsProvider<num, Object?> getProviderOverride(
    covariant NoGenericsProvider<num, Object?> provider,
  ) {
    return call();
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'noGenericsProvider';
}

/// See also [NoGenerics].
class NoGenericsProvider<A extends num, B>
    extends AutoDisposeNotifierProviderImpl<NoGenerics<A, B>, int> {
  /// See also [NoGenerics].
  NoGenericsProvider()
      : this._internal(
          NoGenerics<A, B>.new,
          from: noGenericsProvider,
          name: r'noGenericsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noGenericsHash,
          dependencies: NoGenericsFamily._dependencies,
          allTransitiveDependencies:
              NoGenericsFamily._allTransitiveDependencies,
        );

  NoGenericsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  int runNotifierBuild(
    covariant NoGenerics<A, B> notifier,
  ) {
    return notifier.build();
  }

  @override
  Override overrideWith(NoGenerics<A, B> Function() create) {
    return ProviderOverride(
      origin: this,
      override: NoGenericsProvider<A, B>._internal(
        () => create(),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<NoGenerics<A, B>, int> createElement() {
    return _NoGenericsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoGenericsProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, A.hashCode);
    hash = _SystemHash.combine(hash, B.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoGenericsRef<A extends num, B> on AutoDisposeNotifierProviderRef<int> {}

class _NoGenericsProviderElement<A extends num, B>
    extends AutoDisposeNotifierProviderElement<NoGenerics<A, B>, int>
    with NoGenericsRef<A, B> {
  _NoGenericsProviderElement(super.provider);
}

String _$missingGenericsHash() => r'b611c76d5fb87fdde78b5fc017912e0569762c23';

abstract class _$MissingGenerics<A, B>
    extends BuildlessAutoDisposeNotifier<int> {
  int build();
}

/// See also [MissingGenerics].
@ProviderFor(MissingGenerics)
const missingGenericsProvider = MissingGenericsFamily();

/// See also [MissingGenerics].
class MissingGenericsFamily extends Family {
  /// See also [MissingGenerics].
  const MissingGenericsFamily();

  /// See also [MissingGenerics].
  MissingGenericsProvider<A, B> call<A, B>() {
    return MissingGenericsProvider<A, B>();
  }

  @override
  MissingGenericsProvider<Object?, Object?> getProviderOverride(
    covariant MissingGenericsProvider<Object?, Object?> provider,
  ) {
    return call();
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'missingGenericsProvider';
}

/// See also [MissingGenerics].
class MissingGenericsProvider<A, B>
    extends AutoDisposeNotifierProviderImpl<MissingGenerics<A, B>, int> {
  /// See also [MissingGenerics].
  MissingGenericsProvider()
      : this._internal(
          MissingGenerics<A, B>.new,
          from: missingGenericsProvider,
          name: r'missingGenericsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$missingGenericsHash,
          dependencies: MissingGenericsFamily._dependencies,
          allTransitiveDependencies:
              MissingGenericsFamily._allTransitiveDependencies,
        );

  MissingGenericsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  int runNotifierBuild(
    covariant MissingGenerics<A, B> notifier,
  ) {
    return notifier.build();
  }

  @override
  Override overrideWith(MissingGenerics<A, B> Function() create) {
    return ProviderOverride(
      origin: this,
      override: MissingGenericsProvider<A, B>._internal(
        () => create(),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MissingGenerics<A, B>, int>
      createElement() {
    return _MissingGenericsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MissingGenericsProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, A.hashCode);
    hash = _SystemHash.combine(hash, B.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MissingGenericsRef<A, B> on AutoDisposeNotifierProviderRef<int> {}

class _MissingGenericsProviderElement<A, B>
    extends AutoDisposeNotifierProviderElement<MissingGenerics<A, B>, int>
    with MissingGenericsRef<A, B> {
  _MissingGenericsProviderElement(super.provider);
}

String _$wrongOrderHash() => r'7757670a2f67406ebc96c87edf088deb9cb248a1';

abstract class _$WrongOrder<A, B> extends BuildlessAutoDisposeNotifier<int> {
  int build();
}

/// See also [WrongOrder].
@ProviderFor(WrongOrder)
const wrongOrderProvider = WrongOrderFamily();

/// See also [WrongOrder].
class WrongOrderFamily extends Family {
  /// See also [WrongOrder].
  const WrongOrderFamily();

  /// See also [WrongOrder].
  WrongOrderProvider<A, B> call<A, B>() {
    return WrongOrderProvider<A, B>();
  }

  @override
  WrongOrderProvider<Object?, Object?> getProviderOverride(
    covariant WrongOrderProvider<Object?, Object?> provider,
  ) {
    return call();
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'wrongOrderProvider';
}

/// See also [WrongOrder].
class WrongOrderProvider<A, B>
    extends AutoDisposeNotifierProviderImpl<WrongOrder<A, B>, int> {
  /// See also [WrongOrder].
  WrongOrderProvider()
      : this._internal(
          WrongOrder<A, B>.new,
          from: wrongOrderProvider,
          name: r'wrongOrderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$wrongOrderHash,
          dependencies: WrongOrderFamily._dependencies,
          allTransitiveDependencies:
              WrongOrderFamily._allTransitiveDependencies,
        );

  WrongOrderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  int runNotifierBuild(
    covariant WrongOrder<A, B> notifier,
  ) {
    return notifier.build();
  }

  @override
  Override overrideWith(WrongOrder<A, B> Function() create) {
    return ProviderOverride(
      origin: this,
      override: WrongOrderProvider<A, B>._internal(
        () => create(),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WrongOrder<A, B>, int> createElement() {
    return _WrongOrderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WrongOrderProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, A.hashCode);
    hash = _SystemHash.combine(hash, B.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WrongOrderRef<A, B> on AutoDisposeNotifierProviderRef<int> {}

class _WrongOrderProviderElement<A, B>
    extends AutoDisposeNotifierProviderElement<WrongOrder<A, B>, int>
    with WrongOrderRef<A, B> {
  _WrongOrderProviderElement(super.provider);
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
