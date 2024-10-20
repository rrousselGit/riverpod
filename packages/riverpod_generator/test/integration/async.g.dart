// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$publicHash() => r'19bceccf795e4c3a26ad1e613fd6f41aad949e2b';

/// See also [public].
@ProviderFor(public)
final publicProvider = AutoDisposeFutureProvider<String>.internal(
  public,
  name: r'publicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PublicRef = AutoDisposeFutureProviderRef<String>;
String _$privateHash() => r'7f0d1ff55a21e520b8471bbabc4649b5336221d4';

/// See also [_private].
@ProviderFor(_private)
final _privateProvider = AutoDisposeFutureProvider<String>.internal(
  _private,
  name: r'_privateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _PrivateRef = AutoDisposeFutureProviderRef<String>;
String _$familyOrHash() => r'97cce80a626e228202fa30b87c07ae8319b48023';

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

/// See also [familyOr].
@ProviderFor(familyOr)
const familyOrProvider = FamilyOrFamily();

/// See also [familyOr].
class FamilyOrFamily extends Family<AsyncValue<String>> {
  /// See also [familyOr].
  const FamilyOrFamily();

  /// See also [familyOr].
  FamilyOrProvider call(
    int first,
  ) {
    return FamilyOrProvider(
      first,
    );
  }

  @override
  FamilyOrProvider getProviderOverride(
    covariant FamilyOrProvider provider,
  ) {
    return call(
      provider.first,
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
  String? get name => r'familyOrProvider';
}

/// See also [familyOr].
class FamilyOrProvider extends AutoDisposeFutureProvider<String> {
  /// See also [familyOr].
  FamilyOrProvider(
    int first,
  ) : this._internal(
          (ref) => familyOr(
            ref as FamilyOrRef,
            first,
          ),
          from: familyOrProvider,
          name: r'familyOrProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyOrHash,
          dependencies: FamilyOrFamily._dependencies,
          allTransitiveDependencies: FamilyOrFamily._allTransitiveDependencies,
          first: first,
        );

  FamilyOrProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.first,
  }) : super.internal();

  final int first;

  @override
  Override overrideWith(
    FutureOr<String> Function(FamilyOrRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FamilyOrProvider._internal(
        (ref) => create(ref as FamilyOrRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        first: first,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _FamilyOrProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyOrProvider && other.first == first;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, first.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FamilyOrRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `first` of this provider.
  int get first;
}

class _FamilyOrProviderElement extends AutoDisposeFutureProviderElement<String>
    with FamilyOrRef {
  _FamilyOrProviderElement(super.provider);

  @override
  int get first => (origin as FamilyOrProvider).first;
}

String _$familyHash() => r'1da6c928ee85a03729a1c147f33e018521bb9c89';

/// See also [family].
@ProviderFor(family)
const familyProvider = FamilyFamily();

/// See also [family].
class FamilyFamily extends Family<AsyncValue<String>> {
  /// See also [family].
  const FamilyFamily();

  /// See also [family].
  FamilyProvider call(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) {
    return FamilyProvider(
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
  }

  @override
  FamilyProvider getProviderOverride(
    covariant FamilyProvider provider,
  ) {
    return call(
      provider.first,
      second: provider.second,
      third: provider.third,
      fourth: provider.fourth,
      fifth: provider.fifth,
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
class FamilyProvider extends AutoDisposeFutureProvider<String> {
  /// See also [family].
  FamilyProvider(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) : this._internal(
          (ref) => family(
            ref as FamilyRef,
            first,
            second: second,
            third: third,
            fourth: fourth,
            fifth: fifth,
          ),
          from: familyProvider,
          name: r'familyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyHash,
          dependencies: FamilyFamily._dependencies,
          allTransitiveDependencies: FamilyFamily._allTransitiveDependencies,
          first: first,
          second: second,
          third: third,
          fourth: fourth,
          fifth: fifth,
        );

  FamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.fifth,
  }) : super.internal();

  final int first;
  final String? second;
  final double third;
  final bool fourth;
  final List<String>? fifth;

  @override
  Override overrideWith(
    FutureOr<String> Function(FamilyRef provider) create,
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
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _FamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider &&
        other.first == first &&
        other.second == second &&
        other.third == third &&
        other.fourth == fourth &&
        other.fifth == fifth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, first.hashCode);
    hash = _SystemHash.combine(hash, second.hashCode);
    hash = _SystemHash.combine(hash, third.hashCode);
    hash = _SystemHash.combine(hash, fourth.hashCode);
    hash = _SystemHash.combine(hash, fifth.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FamilyRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `first` of this provider.
  int get first;

  /// The parameter `second` of this provider.
  String? get second;

  /// The parameter `third` of this provider.
  double get third;

  /// The parameter `fourth` of this provider.
  bool get fourth;

  /// The parameter `fifth` of this provider.
  List<String>? get fifth;
}

class _FamilyProviderElement extends AutoDisposeFutureProviderElement<String>
    with FamilyRef {
  _FamilyProviderElement(super.provider);

  @override
  int get first => (origin as FamilyProvider).first;
  @override
  String? get second => (origin as FamilyProvider).second;
  @override
  double get third => (origin as FamilyProvider).third;
  @override
  bool get fourth => (origin as FamilyProvider).fourth;
  @override
  List<String>? get fifth => (origin as FamilyProvider).fifth;
}

String _$publicClassHash() => r'e9bc69e44b72e8ed77d423524c0d74ad460d629d';

/// See also [PublicClass].
@ProviderFor(PublicClass)
final publicClassProvider =
    AutoDisposeAsyncNotifierProvider<PublicClass, String>.internal(
  PublicClass.new,
  name: r'publicClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PublicClass = AutoDisposeAsyncNotifier<String>;
String _$privateClassHash() => r'7e69cffe8315999710e4cb6bb3de9f179d3f2f5d';

/// See also [_PrivateClass].
@ProviderFor(_PrivateClass)
final _privateClassProvider =
    AutoDisposeAsyncNotifierProvider<_PrivateClass, String>.internal(
  _PrivateClass.new,
  name: r'_privateClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PrivateClass = AutoDisposeAsyncNotifier<String>;
String _$familyOrClassHash() => r'b4882d4e79a03c63005d35eb7a021c9c4373a8d9';

abstract class _$FamilyOrClass
    extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final int first;

  FutureOr<String> build(
    int first,
  );
}

/// See also [FamilyOrClass].
@ProviderFor(FamilyOrClass)
const familyOrClassProvider = FamilyOrClassFamily();

/// See also [FamilyOrClass].
class FamilyOrClassFamily extends Family<AsyncValue<String>> {
  /// See also [FamilyOrClass].
  const FamilyOrClassFamily();

  /// See also [FamilyOrClass].
  FamilyOrClassProvider call(
    int first,
  ) {
    return FamilyOrClassProvider(
      first,
    );
  }

  @override
  FamilyOrClassProvider getProviderOverride(
    covariant FamilyOrClassProvider provider,
  ) {
    return call(
      provider.first,
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
  String? get name => r'familyOrClassProvider';
}

/// See also [FamilyOrClass].
class FamilyOrClassProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FamilyOrClass, String> {
  /// See also [FamilyOrClass].
  FamilyOrClassProvider(
    int first,
  ) : this._internal(
          () => FamilyOrClass()..first = first,
          from: familyOrClassProvider,
          name: r'familyOrClassProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyOrClassHash,
          dependencies: FamilyOrClassFamily._dependencies,
          allTransitiveDependencies:
              FamilyOrClassFamily._allTransitiveDependencies,
          first: first,
        );

  FamilyOrClassProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.first,
  }) : super.internal();

  final int first;

  @override
  FutureOr<String> runNotifierBuild(
    covariant FamilyOrClass notifier,
  ) {
    return notifier.build(
      first,
    );
  }

  @override
  Override overrideWith(FamilyOrClass Function() create) {
    return ProviderOverride(
      origin: this,
      override: FamilyOrClassProvider._internal(
        () => create()..first = first,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        first: first,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FamilyOrClass, String>
      createElement() {
    return _FamilyOrClassProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyOrClassProvider && other.first == first;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, first.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FamilyOrClassRef on AutoDisposeAsyncNotifierProviderRef<String> {
  /// The parameter `first` of this provider.
  int get first;
}

class _FamilyOrClassProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FamilyOrClass, String>
    with FamilyOrClassRef {
  _FamilyOrClassProviderElement(super.provider);

  @override
  int get first => (origin as FamilyOrClassProvider).first;
}

String _$familyClassHash() => r'b7e3ca6091f12bbc99972e961acd885e05f42a15';

abstract class _$FamilyClass extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final int first;
  late final String? second;
  late final double third;
  late final bool fourth;
  late final List<String>? fifth;

  FutureOr<String> build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  });
}

/// See also [FamilyClass].
@ProviderFor(FamilyClass)
const familyClassProvider = FamilyClassFamily();

/// See also [FamilyClass].
class FamilyClassFamily extends Family<AsyncValue<String>> {
  /// See also [FamilyClass].
  const FamilyClassFamily();

  /// See also [FamilyClass].
  FamilyClassProvider call(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) {
    return FamilyClassProvider(
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
  }

  @override
  FamilyClassProvider getProviderOverride(
    covariant FamilyClassProvider provider,
  ) {
    return call(
      provider.first,
      second: provider.second,
      third: provider.third,
      fourth: provider.fourth,
      fifth: provider.fifth,
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
  String? get name => r'familyClassProvider';
}

/// See also [FamilyClass].
class FamilyClassProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FamilyClass, String> {
  /// See also [FamilyClass].
  FamilyClassProvider(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) : this._internal(
          () => FamilyClass()
            ..first = first
            ..second = second
            ..third = third
            ..fourth = fourth
            ..fifth = fifth,
          from: familyClassProvider,
          name: r'familyClassProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyClassHash,
          dependencies: FamilyClassFamily._dependencies,
          allTransitiveDependencies:
              FamilyClassFamily._allTransitiveDependencies,
          first: first,
          second: second,
          third: third,
          fourth: fourth,
          fifth: fifth,
        );

  FamilyClassProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.fifth,
  }) : super.internal();

  final int first;
  final String? second;
  final double third;
  final bool fourth;
  final List<String>? fifth;

  @override
  FutureOr<String> runNotifierBuild(
    covariant FamilyClass notifier,
  ) {
    return notifier.build(
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
  }

  @override
  Override overrideWith(FamilyClass Function() create) {
    return ProviderOverride(
      origin: this,
      override: FamilyClassProvider._internal(
        () => create()
          ..first = first
          ..second = second
          ..third = third
          ..fourth = fourth
          ..fifth = fifth,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FamilyClass, String> createElement() {
    return _FamilyClassProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider &&
        other.first == first &&
        other.second == second &&
        other.third == third &&
        other.fourth == fourth &&
        other.fifth == fifth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, first.hashCode);
    hash = _SystemHash.combine(hash, second.hashCode);
    hash = _SystemHash.combine(hash, third.hashCode);
    hash = _SystemHash.combine(hash, fourth.hashCode);
    hash = _SystemHash.combine(hash, fifth.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FamilyClassRef on AutoDisposeAsyncNotifierProviderRef<String> {
  /// The parameter `first` of this provider.
  int get first;

  /// The parameter `second` of this provider.
  String? get second;

  /// The parameter `third` of this provider.
  double get third;

  /// The parameter `fourth` of this provider.
  bool get fourth;

  /// The parameter `fifth` of this provider.
  List<String>? get fifth;
}

class _FamilyClassProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FamilyClass, String>
    with FamilyClassRef {
  _FamilyClassProviderElement(super.provider);

  @override
  int get first => (origin as FamilyClassProvider).first;
  @override
  String? get second => (origin as FamilyClassProvider).second;
  @override
  double get third => (origin as FamilyClassProvider).third;
  @override
  bool get fourth => (origin as FamilyClassProvider).fourth;
  @override
  List<String>? get fifth => (origin as FamilyClassProvider).fifth;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
