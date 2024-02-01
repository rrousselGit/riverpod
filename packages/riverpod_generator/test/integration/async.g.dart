// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genericHash() => r'6ee5473ece745b00328c1e048f6967c160343620';

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

/// See also [generic].
@ProviderFor(generic)
const genericProvider = GenericFamily();

/// See also [generic].
class GenericFamily extends Family {
  /// See also [generic].
  const GenericFamily()
      : super(
          name: r'genericProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [generic].
  GenericProvider<T> call<T extends num>() {
    return GenericProvider<T>();
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<List<T>> Function<T extends num>(GenericRef ref) create) {
    return _$GenericFamilyOverride(this, create);
  }

  @override
  String toString() => 'genericProvider';
}

class _$GenericFamilyOverride implements FamilyOverride {
  _$GenericFamilyOverride(this.from, this.create);

  final FutureOr<List<T>> Function<T extends num>(GenericRef ref) create;

  @override
  final GenericFamily from;

  @override
  _GenericProviderElement createElement(
    ProviderContainer container,
    covariant GenericProvider provider,
  ) {
    return provider._copyWith(create).createElement(container);
  }

  @override
  String toString() => 'genericProvider.overrideWith(...)';
}

/// See also [generic].
class GenericProvider<T extends num> extends FutureProvider<List<T>> {
  /// See also [generic].
  GenericProvider()
      : this._internal(
          (ref) => generic<T>(
            ref as GenericRef<T>,
          ),
          from: genericProvider,
          name: r'genericProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericHash,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  GenericProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  Override overrideWith(
    FutureOr<List<T>> Function(GenericRef<T> ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      providerOverride: GenericProvider<T>._internal(
        (ref) => create(ref as GenericRef<T>),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }

  @override
  () get argument {
    return ();
  }

  @override
  _GenericProviderElement<T> createElement(
    ProviderContainer container,
  ) {
    return _GenericProviderElement(this, container);
  }

  GenericProvider _copyWith(
    FutureOr<List<T>> Function<T extends num>(GenericRef ref) create,
  ) {
    return GenericProvider._internal(
      (ref) => create(ref as GenericRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenericProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, T.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String toString() => 'genericProvider<$T>$argument';
}

mixin GenericRef<T extends num> on Ref<AsyncValue<List<T>>> {}

class _GenericProviderElement<T extends num>
    extends FutureProviderElement<List<T>> with GenericRef<T> {
  _GenericProviderElement(super.provider, super.container);
}

String _$publicHash() => r'9d99b79c013da13926d4ad89c72ebca4fc1cc257';

/// See also [public].
@ProviderFor(public)
final publicProvider = FutureProvider<String>.internal(
  public,
  name: r'publicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PublicRef = Ref<AsyncValue<String>>;
String _$privateHash() => r'bc0469a9315de114a0ccd82c7db4980844d0009f';

/// See also [_private].
@ProviderFor(_private)
final _privateProvider = FutureProvider<String>.internal(
  _private,
  name: r'_privateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _PrivateRef = Ref<AsyncValue<String>>;
String _$familyOrHash() => r'1c3217e296b0ce52c07c18769d1fffb95850f482';

/// See also [familyOr].
@ProviderFor(familyOr)
const familyOrProvider = FamilyOrFamily();

/// See also [familyOr].
class FamilyOrFamily extends Family {
  /// See also [familyOr].
  const FamilyOrFamily()
      : super(
          name: r'familyOrProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyOrHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [familyOr].
  FamilyOrProvider call(
    int first,
  ) {
    return FamilyOrProvider(
      first,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<String> Function(FamilyOrRef ref) create) {
    return _$FamilyOrFamilyOverride(this, create);
  }

  @override
  String toString() => 'familyOrProvider';
}

class _$FamilyOrFamilyOverride implements FamilyOverride {
  _$FamilyOrFamilyOverride(this.from, this.create);

  final FutureOr<String> Function(FamilyOrRef ref) create;

  @override
  final FamilyOrFamily from;

  @override
  _FamilyOrProviderElement createElement(
    ProviderContainer container,
    covariant FamilyOrProvider provider,
  ) {
    return provider._copyWith(create).createElement(container);
  }

  @override
  String toString() => 'familyOrProvider.overrideWith(...)';
}

/// See also [familyOr].
class FamilyOrProvider extends FutureProvider<String> {
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
          dependencies: null,
          allTransitiveDependencies: null,
          first: first,
        );

  FamilyOrProvider._internal(
    super.create, {
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
    FutureOr<String> Function(FamilyOrRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      providerOverride: FamilyOrProvider._internal(
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
  (int,) get argument {
    return (first,);
  }

  @override
  _FamilyOrProviderElement createElement(
    ProviderContainer container,
  ) {
    return _FamilyOrProviderElement(this, container);
  }

  FamilyOrProvider _copyWith(
    FutureOr<String> Function(FamilyOrRef ref) create,
  ) {
    return FamilyOrProvider._internal(
      (ref) => create(ref as FamilyOrRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      first: first,
    );
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

  @override
  String toString() => 'familyOrProvider$argument';
}

mixin FamilyOrRef on Ref<AsyncValue<String>> {
  /// The parameter `first` of this provider.
  int get first;
}

class _FamilyOrProviderElement extends FutureProviderElement<String>
    with FamilyOrRef {
  _FamilyOrProviderElement(super.provider, super.container);

  @override
  int get first => (origin as FamilyOrProvider).first;
}

String _$familyHash() => r'eb6fad35a94d4238b621c2100253ee2c700bee77';

/// See also [family].
@ProviderFor(family)
const familyProvider = FamilyFamily();

/// See also [family].
class FamilyFamily extends Family {
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

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<String> Function(FamilyRef ref) create) {
    return _$FamilyFamilyOverride(this, create);
  }

  @override
  String toString() => 'familyProvider';
}

class _$FamilyFamilyOverride implements FamilyOverride {
  _$FamilyFamilyOverride(this.from, this.create);

  final FutureOr<String> Function(FamilyRef ref) create;

  @override
  final FamilyFamily from;

  @override
  _FamilyProviderElement createElement(
    ProviderContainer container,
    covariant FamilyProvider provider,
  ) {
    return provider._copyWith(create).createElement(container);
  }

  @override
  String toString() => 'familyProvider.overrideWith(...)';
}

/// See also [family].
class FamilyProvider extends FutureProvider<String> {
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
          dependencies: null,
          allTransitiveDependencies: null,
          first: first,
          second: second,
          third: third,
          fourth: fourth,
          fifth: fifth,
        );

  FamilyProvider._internal(
    super.create, {
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
    FutureOr<String> Function(FamilyRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      providerOverride: FamilyProvider._internal(
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
  (
    int, {
    String? second,
    double third,
    bool fourth,
    List<String>? fifth,
  }) get argument {
    return (
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
  }

  @override
  _FamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _FamilyProviderElement(this, container);
  }

  FamilyProvider _copyWith(
    FutureOr<String> Function(FamilyRef ref) create,
  ) {
    return FamilyProvider._internal(
      (ref) => create(ref as FamilyRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      first: first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
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

  @override
  String toString() => 'familyProvider$argument';
}

mixin FamilyRef on Ref<AsyncValue<String>> {
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

class _FamilyProviderElement extends FutureProviderElement<String>
    with FamilyRef {
  _FamilyProviderElement(super.provider, super.container);

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

String _$genericClassHash() => r'd3c4acc9cdae12f6c666fbf1f89aee212bb086db';

abstract class _$GenericClass<T extends num>
    extends BuildlessAutoDisposeAsyncNotifier<List<T>> {
  FutureOr<List<T>> build();
}

/// See also [GenericClass].
@ProviderFor(GenericClass)
const genericClassProvider = GenericClassFamily();

/// See also [GenericClass].
class GenericClassFamily extends Family {
  /// See also [GenericClass].
  const GenericClassFamily()
      : super(
          name: r'genericClassProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericClassHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [GenericClass].
  GenericClassProvider<T> call<T extends num>() {
    return GenericClassProvider<T>();
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(GenericClass Function() create) {
    return _$GenericClassFamilyOverride(this, create);
  }

  @override
  String toString() => 'genericClassProvider';
}

class _$GenericClassFamilyOverride implements FamilyOverride {
  _$GenericClassFamilyOverride(this.from, this.create);

  final GenericClass Function() create;

  @override
  final GenericClassFamily from;

  @override
  _GenericClassProviderElement createElement(
    ProviderContainer container,
    covariant GenericClassProvider provider,
  ) {
    return provider._copyWith(create).createElement(container);
  }

  @override
  String toString() => 'genericClassProvider.overrideWith(...)';
}

/// See also [GenericClass].
class GenericClassProvider<T extends num>
    extends AutoDisposeAsyncNotifierProviderImpl<GenericClass<T>, List<T>> {
  /// See also [GenericClass].
  GenericClassProvider()
      : this._internal(
          GenericClass<T>.new,
          from: genericClassProvider,
          name: r'genericClassProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericClassHash,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  GenericClassProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  FutureOr<List<T>> runNotifierBuild(
    covariant GenericClass<T> notifier,
  ) {
    return notifier.build();
  }

  @override
  Override overrideWith(GenericClass<T> Function() create) {
    return ProviderOverride(
      origin: this,
      providerOverride: GenericClassProvider<T>._internal(
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
  () get argument {
    return ();
  }

  @override
  _GenericClassProviderElement<T> createElement(
    ProviderContainer container,
  ) {
    return _GenericClassProviderElement(this, container);
  }

  GenericClassProvider _copyWith(
    GenericClass Function() create,
  ) {
    return GenericClassProvider._internal(
      () => create(),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenericClassProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, T.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String toString() => 'genericClassProvider<$T>$argument';
}

mixin GenericClassRef<T extends num> on AutoDisposeAsyncNotifierProviderRef {}

class _GenericClassProviderElement<T extends num>
    extends AutoDisposeAsyncNotifierProviderElement<GenericClass<T>, List<T>>
    with GenericClassRef<T> {
  _GenericClassProviderElement(super.provider, super.container);
}

String _$publicClassHash() => r'e9bc69e44b72e8ed77d423524c0d74ad460d629d';

/// See also [PublicClass].
@ProviderFor(PublicClass)
final publicClassProvider = AsyncNotifierProvider<PublicClass, String>.internal(
  PublicClass.new,
  name: r'publicClassProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PublicClass = AsyncNotifier<String>;
String _$privateClassHash() => r'7e69cffe8315999710e4cb6bb3de9f179d3f2f5d';

/// See also [_PrivateClass].
@ProviderFor(_PrivateClass)
final _privateClassProvider =
    AsyncNotifierProvider<_PrivateClass, String>.internal(
  _PrivateClass.new,
  name: r'_privateClassProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PrivateClass = AsyncNotifier<String>;
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
class FamilyOrClassFamily extends Family {
  /// See also [FamilyOrClass].
  const FamilyOrClassFamily()
      : super(
          name: r'familyOrClassProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyOrClassHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [FamilyOrClass].
  FamilyOrClassProvider call(
    int first,
  ) {
    return FamilyOrClassProvider(
      first,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FamilyOrClass Function() create) {
    return _$FamilyOrClassFamilyOverride(this, create);
  }

  @override
  String toString() => 'familyOrClassProvider';
}

class _$FamilyOrClassFamilyOverride implements FamilyOverride {
  _$FamilyOrClassFamilyOverride(this.from, this.create);

  final FamilyOrClass Function() create;

  @override
  final FamilyOrClassFamily from;

  @override
  _FamilyOrClassProviderElement createElement(
    ProviderContainer container,
    covariant FamilyOrClassProvider provider,
  ) {
    return provider._copyWith(create).createElement(container);
  }

  @override
  String toString() => 'familyOrClassProvider.overrideWith(...)';
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
          dependencies: null,
          allTransitiveDependencies: null,
          first: first,
        );

  FamilyOrClassProvider._internal(
    super.create, {
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
      providerOverride: FamilyOrClassProvider._internal(
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
  (int,) get argument {
    return (first,);
  }

  @override
  _FamilyOrClassProviderElement createElement(
    ProviderContainer container,
  ) {
    return _FamilyOrClassProviderElement(this, container);
  }

  FamilyOrClassProvider _copyWith(
    FamilyOrClass Function() create,
  ) {
    return FamilyOrClassProvider._internal(
      () => create()..first = first,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      first: first,
    );
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

  @override
  String toString() => 'familyOrClassProvider$argument';
}

mixin FamilyOrClassRef on AutoDisposeAsyncNotifierProviderRef {
  /// The parameter `first` of this provider.
  int get first;
}

class _FamilyOrClassProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FamilyOrClass, String>
    with FamilyOrClassRef {
  _FamilyOrClassProviderElement(super.provider, super.container);

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
class FamilyClassFamily extends Family {
  /// See also [FamilyClass].
  const FamilyClassFamily()
      : super(
          name: r'familyClassProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyClassHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

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

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FamilyClass Function() create) {
    return _$FamilyClassFamilyOverride(this, create);
  }

  @override
  String toString() => 'familyClassProvider';
}

class _$FamilyClassFamilyOverride implements FamilyOverride {
  _$FamilyClassFamilyOverride(this.from, this.create);

  final FamilyClass Function() create;

  @override
  final FamilyClassFamily from;

  @override
  _FamilyClassProviderElement createElement(
    ProviderContainer container,
    covariant FamilyClassProvider provider,
  ) {
    return provider._copyWith(create).createElement(container);
  }

  @override
  String toString() => 'familyClassProvider.overrideWith(...)';
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
          dependencies: null,
          allTransitiveDependencies: null,
          first: first,
          second: second,
          third: third,
          fourth: fourth,
          fifth: fifth,
        );

  FamilyClassProvider._internal(
    super.create, {
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
      providerOverride: FamilyClassProvider._internal(
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
  (
    int, {
    String? second,
    double third,
    bool fourth,
    List<String>? fifth,
  }) get argument {
    return (
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
  }

  @override
  _FamilyClassProviderElement createElement(
    ProviderContainer container,
  ) {
    return _FamilyClassProviderElement(this, container);
  }

  FamilyClassProvider _copyWith(
    FamilyClass Function() create,
  ) {
    return FamilyClassProvider._internal(
      () => create()
        ..first = first
        ..second = second
        ..third = third
        ..fourth = fourth
        ..fifth = fifth,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      first: first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
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

  @override
  String toString() => 'familyClassProvider$argument';
}

mixin FamilyClassRef on AutoDisposeAsyncNotifierProviderRef {
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
  _FamilyClassProviderElement(super.provider, super.container);

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
