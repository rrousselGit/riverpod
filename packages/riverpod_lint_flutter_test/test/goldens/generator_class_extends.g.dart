// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_class_extends.dart';

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
      : super.internal(
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

  @override
  int runNotifierBuild(
    covariant Generics<A, B> notifier,
  ) {
    return notifier.build();
  }
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
      : super.internal(
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

  @override
  int runNotifierBuild(
    covariant NoGenerics<A, B> notifier,
  ) {
    return notifier.build();
  }
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
      : super.internal(
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

  @override
  int runNotifierBuild(
    covariant MissingGenerics<A, B> notifier,
  ) {
    return notifier.build();
  }
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
      : super.internal(
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

  @override
  int runNotifierBuild(
    covariant WrongOrder<A, B> notifier,
  ) {
    return notifier.build();
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
