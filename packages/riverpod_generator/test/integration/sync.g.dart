// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genericHash() => r'0fda19dd377694315cdffd7414d53f98569c655c';

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
  const GenericFamily();

  /// See also [generic].
  GenericProvider<T> call<T extends num>() {
    return GenericProvider<T>();
  }

  @override
  GenericProvider<num> getProviderOverride(
    covariant GenericProvider<num> provider,
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
  String? get name => r'genericProvider';
}

/// See also [generic].
class GenericProvider<T extends num> extends AutoDisposeProvider<List<T>> {
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
          dependencies: GenericFamily._dependencies,
          allTransitiveDependencies: GenericFamily._allTransitiveDependencies,
        );

  GenericProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  Override overrideWith(
    List<T> Function(GenericRef<T> provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GenericProvider<T>._internal(
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
  AutoDisposeProviderElement<List<T>> createElement() {
    return _GenericProviderElement(this);
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
}

mixin GenericRef<T extends num> on AutoDisposeProviderRef<List<T>> {}

class _GenericProviderElement<T extends num>
    extends AutoDisposeProviderElement<List<T>> with GenericRef<T> {
  _GenericProviderElement(super.provider);
}

String _$complexGenericHash() => r'a5254e5552cd61bb8d65c018539ff2d8edfd5822';

/// See also [complexGeneric].
@ProviderFor(complexGeneric)
const complexGenericProvider = ComplexGenericFamily();

/// See also [complexGeneric].
class ComplexGenericFamily extends Family {
  /// See also [complexGeneric].
  const ComplexGenericFamily();

  /// See also [complexGeneric].
  ComplexGenericProvider<T, Foo> call<T extends num, Foo extends String?>({
    required T param,
    Foo? otherParam,
  }) {
    return ComplexGenericProvider<T, Foo>(
      param: param,
      otherParam: otherParam,
    );
  }

  @override
  ComplexGenericProvider<num, String?> getProviderOverride(
    covariant ComplexGenericProvider<num, String?> provider,
  ) {
    return call(
      param: provider.param,
      otherParam: provider.otherParam,
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
  String? get name => r'complexGenericProvider';
}

/// See also [complexGeneric].
class ComplexGenericProvider<T extends num, Foo extends String?>
    extends AutoDisposeProvider<List<T>> {
  /// See also [complexGeneric].
  ComplexGenericProvider({
    required T param,
    Foo? otherParam,
  }) : this._internal(
          (ref) => complexGeneric<T, Foo>(
            ref as ComplexGenericRef<T, Foo>,
            param: param,
            otherParam: otherParam,
          ),
          from: complexGenericProvider,
          name: r'complexGenericProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$complexGenericHash,
          dependencies: ComplexGenericFamily._dependencies,
          allTransitiveDependencies:
              ComplexGenericFamily._allTransitiveDependencies,
          param: param,
          otherParam: otherParam,
        );

  ComplexGenericProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.param,
    required this.otherParam,
  }) : super.internal();

  final T param;
  final Foo? otherParam;

  @override
  Override overrideWith(
    List<T> Function(ComplexGenericRef<T, Foo> provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ComplexGenericProvider<T, Foo>._internal(
        (ref) => create(ref as ComplexGenericRef<T, Foo>),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        param: param,
        otherParam: otherParam,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<T>> createElement() {
    return _ComplexGenericProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ComplexGenericProvider &&
        other.runtimeType == runtimeType &&
        other.param == param &&
        other.otherParam == otherParam;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, param.hashCode);
    hash = _SystemHash.combine(hash, otherParam.hashCode);
    hash = _SystemHash.combine(hash, T.hashCode);
    hash = _SystemHash.combine(hash, Foo.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ComplexGenericRef<T extends num, Foo extends String?>
    on AutoDisposeProviderRef<List<T>> {
  /// The parameter `param` of this provider.
  T get param;

  /// The parameter `otherParam` of this provider.
  Foo? get otherParam;
}

class _ComplexGenericProviderElement<T extends num, Foo extends String?>
    extends AutoDisposeProviderElement<List<T>> with ComplexGenericRef<T, Foo> {
  _ComplexGenericProviderElement(super.provider);

  @override
  T get param => (origin as ComplexGenericProvider<T, Foo>).param;
  @override
  Foo? get otherParam => (origin as ComplexGenericProvider<T, Foo>).otherParam;
}

String _$rawFutureHash() => r'5203a56065b768023770326281618e3229ccb530';

/// See also [rawFuture].
@ProviderFor(rawFuture)
final rawFutureProvider = AutoDisposeProvider<Future<String>>.internal(
  rawFuture,
  name: r'rawFutureProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rawFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RawFutureRef = AutoDisposeProviderRef<Future<String>>;
String _$rawStreamHash() => r'2b764189753a8b74f47ba557a79416f00ef5cebd';

/// See also [rawStream].
@ProviderFor(rawStream)
final rawStreamProvider = AutoDisposeProvider<Stream<String>>.internal(
  rawStream,
  name: r'rawStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rawStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RawStreamRef = AutoDisposeProviderRef<Stream<String>>;
String _$rawFamilyFutureHash() => r'485f59512081852e51279658facc015309743864';

/// See also [rawFamilyFuture].
@ProviderFor(rawFamilyFuture)
const rawFamilyFutureProvider = RawFamilyFutureFamily();

/// See also [rawFamilyFuture].
class RawFamilyFutureFamily extends Family {
  /// See also [rawFamilyFuture].
  const RawFamilyFutureFamily();

  /// See also [rawFamilyFuture].
  RawFamilyFutureProvider call(
    int id,
  ) {
    return RawFamilyFutureProvider(
      id,
    );
  }

  @override
  RawFamilyFutureProvider getProviderOverride(
    covariant RawFamilyFutureProvider provider,
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
  String? get name => r'rawFamilyFutureProvider';
}

/// See also [rawFamilyFuture].
class RawFamilyFutureProvider extends AutoDisposeProvider<Future<String>> {
  /// See also [rawFamilyFuture].
  RawFamilyFutureProvider(
    int id,
  ) : this._internal(
          (ref) => rawFamilyFuture(
            ref as RawFamilyFutureRef,
            id,
          ),
          from: rawFamilyFutureProvider,
          name: r'rawFamilyFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawFamilyFutureHash,
          dependencies: RawFamilyFutureFamily._dependencies,
          allTransitiveDependencies:
              RawFamilyFutureFamily._allTransitiveDependencies,
          id: id,
        );

  RawFamilyFutureProvider._internal(
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
    Future<String> Function(RawFamilyFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RawFamilyFutureProvider._internal(
        (ref) => create(ref as RawFamilyFutureRef),
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
  AutoDisposeProviderElement<Future<String>> createElement() {
    return _RawFamilyFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawFamilyFutureProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RawFamilyFutureRef on AutoDisposeProviderRef<Future<String>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _RawFamilyFutureProviderElement
    extends AutoDisposeProviderElement<Future<String>> with RawFamilyFutureRef {
  _RawFamilyFutureProviderElement(super.provider);

  @override
  int get id => (origin as RawFamilyFutureProvider).id;
}

String _$rawFamilyStreamHash() => r'e778e5cfcb8ab381e2412f5c73213aaa03b93012';

/// See also [rawFamilyStream].
@ProviderFor(rawFamilyStream)
const rawFamilyStreamProvider = RawFamilyStreamFamily();

/// See also [rawFamilyStream].
class RawFamilyStreamFamily extends Family {
  /// See also [rawFamilyStream].
  const RawFamilyStreamFamily();

  /// See also [rawFamilyStream].
  RawFamilyStreamProvider call(
    int id,
  ) {
    return RawFamilyStreamProvider(
      id,
    );
  }

  @override
  RawFamilyStreamProvider getProviderOverride(
    covariant RawFamilyStreamProvider provider,
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
  String? get name => r'rawFamilyStreamProvider';
}

/// See also [rawFamilyStream].
class RawFamilyStreamProvider extends AutoDisposeProvider<Stream<String>> {
  /// See also [rawFamilyStream].
  RawFamilyStreamProvider(
    int id,
  ) : this._internal(
          (ref) => rawFamilyStream(
            ref as RawFamilyStreamRef,
            id,
          ),
          from: rawFamilyStreamProvider,
          name: r'rawFamilyStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawFamilyStreamHash,
          dependencies: RawFamilyStreamFamily._dependencies,
          allTransitiveDependencies:
              RawFamilyStreamFamily._allTransitiveDependencies,
          id: id,
        );

  RawFamilyStreamProvider._internal(
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
    Stream<String> Function(RawFamilyStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RawFamilyStreamProvider._internal(
        (ref) => create(ref as RawFamilyStreamRef),
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
  AutoDisposeProviderElement<Stream<String>> createElement() {
    return _RawFamilyStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawFamilyStreamProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RawFamilyStreamRef on AutoDisposeProviderRef<Stream<String>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _RawFamilyStreamProviderElement
    extends AutoDisposeProviderElement<Stream<String>> with RawFamilyStreamRef {
  _RawFamilyStreamProviderElement(super.provider);

  @override
  int get id => (origin as RawFamilyStreamProvider).id;
}

String _$publicHash() => r'138be35943899793ab085e711fe3f3d22696a3ba';

/// This is some documentation
///
/// Copied from [public].
@ProviderFor(public)
final publicProvider = AutoDisposeProvider<String>.internal(
  public,
  name: r'publicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PublicRef = AutoDisposeProviderRef<String>;
String _$supports$inNamesHash() => r'cbf929802fcbd0aa949ad72743d096fb3ef5f28f';

/// See also [supports$inNames].
@ProviderFor(supports$inNames)
final supports$inNamesProvider = AutoDisposeProvider<String>.internal(
  supports$inNames,
  name: r'supports$inNamesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supports$inNamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef Supports$inNamesRef = AutoDisposeProviderRef<String>;
String _$familyHash() => r'14d1ee238ca608d547630d0e222ef4c5866e9e61';

/// This is some documentation
///
/// Copied from [family].
@ProviderFor(family)
const familyProvider = FamilyFamily();

/// This is some documentation
///
/// Copied from [family].
class FamilyFamily extends Family {
  /// This is some documentation
  ///
  /// Copied from [family].
  const FamilyFamily();

  /// This is some documentation
  ///
  /// Copied from [family].
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

/// This is some documentation
///
/// Copied from [family].
class FamilyProvider extends AutoDisposeProvider<String> {
  /// This is some documentation
  ///
  /// Copied from [family].
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
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
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

mixin FamilyRef on AutoDisposeProviderRef<String> {
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

class _FamilyProviderElement extends AutoDisposeProviderElement<String>
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

String _$privateHash() => r'519561bc7e88e394d7f75ca2102a5c0acc832c66';

/// See also [_private].
@ProviderFor(_private)
final _privateProvider = AutoDisposeProvider<String>.internal(
  _private,
  name: r'_privateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _PrivateRef = AutoDisposeProviderRef<String>;
String _$generatedHash() => r'fecbc1d5d9a05fc996b452a57fd1975ff368af91';

/// See also [generated].
@ProviderFor(generated)
final generatedProvider = AutoDisposeProvider<String>.internal(
  generated,
  name: r'generatedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$generatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GeneratedRef = AutoDisposeProviderRef<String>;
String _$genericClassHash() => r'671e348a5abf8e00ab06c5f247defbca8af9677b';

abstract class _$GenericClass<T extends num>
    extends BuildlessAutoDisposeNotifier<List<T>> {
  List<T> build();
}

/// See also [GenericClass].
@ProviderFor(GenericClass)
const genericClassProvider = GenericClassFamily();

/// See also [GenericClass].
class GenericClassFamily extends Family {
  /// See also [GenericClass].
  const GenericClassFamily();

  /// See also [GenericClass].
  GenericClassProvider<T> call<T extends num>() {
    return GenericClassProvider<T>();
  }

  @override
  GenericClassProvider<num> getProviderOverride(
    covariant GenericClassProvider<num> provider,
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
  String? get name => r'genericClassProvider';
}

/// See also [GenericClass].
class GenericClassProvider<T extends num>
    extends AutoDisposeNotifierProviderImpl<GenericClass<T>, List<T>> {
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
          dependencies: GenericClassFamily._dependencies,
          allTransitiveDependencies:
              GenericClassFamily._allTransitiveDependencies,
        );

  GenericClassProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
  }) : super.internal();

  @override
  List<T> runNotifierBuild(
    covariant GenericClass<T> notifier,
  ) {
    return notifier.build();
  }

  @override
  Override overrideWith(GenericClass<T> Function() create) {
    return ProviderOverride(
      origin: this,
      override: GenericClassProvider<T>._internal(
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
  AutoDisposeNotifierProviderElement<GenericClass<T>, List<T>> createElement() {
    return _GenericClassProviderElement(this);
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
}

mixin GenericClassRef<T extends num>
    on AutoDisposeNotifierProviderRef<List<T>> {}

class _GenericClassProviderElement<T extends num>
    extends AutoDisposeNotifierProviderElement<GenericClass<T>, List<T>>
    with GenericClassRef<T> {
  _GenericClassProviderElement(super.provider);
}

String _$rawFutureClassHash() => r'bf66f1cdbd99118b8845d206e6a2611b3101f45c';

/// See also [RawFutureClass].
@ProviderFor(RawFutureClass)
final rawFutureClassProvider =
    AutoDisposeNotifierProvider<RawFutureClass, Future<String>>.internal(
  RawFutureClass.new,
  name: r'rawFutureClassProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rawFutureClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RawFutureClass = AutoDisposeNotifier<Future<String>>;
String _$rawStreamClassHash() => r'712cffcb2018cfb4ff45012c1aa6e43c8cbe9d5d';

/// See also [RawStreamClass].
@ProviderFor(RawStreamClass)
final rawStreamClassProvider =
    AutoDisposeNotifierProvider<RawStreamClass, Stream<String>>.internal(
  RawStreamClass.new,
  name: r'rawStreamClassProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rawStreamClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RawStreamClass = AutoDisposeNotifier<Stream<String>>;
String _$rawFamilyFutureClassHash() =>
    r'd7cacb0f2c51697d107de6daa68b242c04085dca';

abstract class _$RawFamilyFutureClass
    extends BuildlessAutoDisposeNotifier<Future<String>> {
  late final int id;

  Future<String> build(
    int id,
  );
}

/// See also [RawFamilyFutureClass].
@ProviderFor(RawFamilyFutureClass)
const rawFamilyFutureClassProvider = RawFamilyFutureClassFamily();

/// See also [RawFamilyFutureClass].
class RawFamilyFutureClassFamily extends Family {
  /// See also [RawFamilyFutureClass].
  const RawFamilyFutureClassFamily();

  /// See also [RawFamilyFutureClass].
  RawFamilyFutureClassProvider call(
    int id,
  ) {
    return RawFamilyFutureClassProvider(
      id,
    );
  }

  @override
  RawFamilyFutureClassProvider getProviderOverride(
    covariant RawFamilyFutureClassProvider provider,
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
  String? get name => r'rawFamilyFutureClassProvider';
}

/// See also [RawFamilyFutureClass].
class RawFamilyFutureClassProvider extends AutoDisposeNotifierProviderImpl<
    RawFamilyFutureClass, Future<String>> {
  /// See also [RawFamilyFutureClass].
  RawFamilyFutureClassProvider(
    int id,
  ) : this._internal(
          () => RawFamilyFutureClass()..id = id,
          from: rawFamilyFutureClassProvider,
          name: r'rawFamilyFutureClassProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawFamilyFutureClassHash,
          dependencies: RawFamilyFutureClassFamily._dependencies,
          allTransitiveDependencies:
              RawFamilyFutureClassFamily._allTransitiveDependencies,
          id: id,
        );

  RawFamilyFutureClassProvider._internal(
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
  Future<String> runNotifierBuild(
    covariant RawFamilyFutureClass notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(RawFamilyFutureClass Function() create) {
    return ProviderOverride(
      origin: this,
      override: RawFamilyFutureClassProvider._internal(
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
  AutoDisposeNotifierProviderElement<RawFamilyFutureClass, Future<String>>
      createElement() {
    return _RawFamilyFutureClassProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawFamilyFutureClassProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RawFamilyFutureClassRef
    on AutoDisposeNotifierProviderRef<Future<String>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _RawFamilyFutureClassProviderElement
    extends AutoDisposeNotifierProviderElement<RawFamilyFutureClass,
        Future<String>> with RawFamilyFutureClassRef {
  _RawFamilyFutureClassProviderElement(super.provider);

  @override
  int get id => (origin as RawFamilyFutureClassProvider).id;
}

String _$rawFamilyStreamClassHash() =>
    r'321796a0befc43fb83f7ccfdcb6b011fc8c7c599';

abstract class _$RawFamilyStreamClass
    extends BuildlessAutoDisposeNotifier<Stream<String>> {
  late final int id;

  Stream<String> build(
    int id,
  );
}

/// See also [RawFamilyStreamClass].
@ProviderFor(RawFamilyStreamClass)
const rawFamilyStreamClassProvider = RawFamilyStreamClassFamily();

/// See also [RawFamilyStreamClass].
class RawFamilyStreamClassFamily extends Family {
  /// See also [RawFamilyStreamClass].
  const RawFamilyStreamClassFamily();

  /// See also [RawFamilyStreamClass].
  RawFamilyStreamClassProvider call(
    int id,
  ) {
    return RawFamilyStreamClassProvider(
      id,
    );
  }

  @override
  RawFamilyStreamClassProvider getProviderOverride(
    covariant RawFamilyStreamClassProvider provider,
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
  String? get name => r'rawFamilyStreamClassProvider';
}

/// See also [RawFamilyStreamClass].
class RawFamilyStreamClassProvider extends AutoDisposeNotifierProviderImpl<
    RawFamilyStreamClass, Stream<String>> {
  /// See also [RawFamilyStreamClass].
  RawFamilyStreamClassProvider(
    int id,
  ) : this._internal(
          () => RawFamilyStreamClass()..id = id,
          from: rawFamilyStreamClassProvider,
          name: r'rawFamilyStreamClassProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawFamilyStreamClassHash,
          dependencies: RawFamilyStreamClassFamily._dependencies,
          allTransitiveDependencies:
              RawFamilyStreamClassFamily._allTransitiveDependencies,
          id: id,
        );

  RawFamilyStreamClassProvider._internal(
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
  Stream<String> runNotifierBuild(
    covariant RawFamilyStreamClass notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(RawFamilyStreamClass Function() create) {
    return ProviderOverride(
      origin: this,
      override: RawFamilyStreamClassProvider._internal(
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
  AutoDisposeNotifierProviderElement<RawFamilyStreamClass, Stream<String>>
      createElement() {
    return _RawFamilyStreamClassProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawFamilyStreamClassProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RawFamilyStreamClassRef
    on AutoDisposeNotifierProviderRef<Stream<String>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _RawFamilyStreamClassProviderElement
    extends AutoDisposeNotifierProviderElement<RawFamilyStreamClass,
        Stream<String>> with RawFamilyStreamClassRef {
  _RawFamilyStreamClassProviderElement(super.provider);

  @override
  int get id => (origin as RawFamilyStreamClassProvider).id;
}

String _$publicClassHash() => r'c8e7eec9e202acf8394e02496857cbe49405bf62';

/// This is some documentation
///
/// Copied from [PublicClass].
@ProviderFor(PublicClass)
final publicClassProvider =
    AutoDisposeNotifierProvider<PublicClass, String>.internal(
  PublicClass.new,
  name: r'publicClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PublicClass = AutoDisposeNotifier<String>;
String _$privateClassHash() => r'6d41def3ffdc1f79e593beaefb3304ce4b211a77';

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
String _$familyClassHash() => r'01e3b9cb4d6d0bf12a2284761b1a11819d97d249';

abstract class _$FamilyClass extends BuildlessAutoDisposeNotifier<String> {
  late final int first;
  late final String? second;
  late final double third;
  late final bool fourth;
  late final List<String>? fifth;

  String build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  });
}

/// This is some documentation
///
/// Copied from [FamilyClass].
@ProviderFor(FamilyClass)
const familyClassProvider = FamilyClassFamily();

/// This is some documentation
///
/// Copied from [FamilyClass].
class FamilyClassFamily extends Family {
  /// This is some documentation
  ///
  /// Copied from [FamilyClass].
  const FamilyClassFamily();

  /// This is some documentation
  ///
  /// Copied from [FamilyClass].
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

/// This is some documentation
///
/// Copied from [FamilyClass].
class FamilyClassProvider
    extends AutoDisposeNotifierProviderImpl<FamilyClass, String> {
  /// This is some documentation
  ///
  /// Copied from [FamilyClass].
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
  String runNotifierBuild(
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
  AutoDisposeNotifierProviderElement<FamilyClass, String> createElement() {
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

mixin FamilyClassRef on AutoDisposeNotifierProviderRef<String> {
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
    extends AutoDisposeNotifierProviderElement<FamilyClass, String>
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

String _$supports$InClassNameHash() =>
    r'4e99f433d9cb3598faaf4d172edf9f28b9e68091';

/// See also [Supports$InClassName].
@ProviderFor(Supports$InClassName)
final supports$InClassNameProvider =
    AutoDisposeNotifierProvider<Supports$InClassName, String>.internal(
  Supports$InClassName.new,
  name: r'supports$InClassNameProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supports$InClassNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Supports$InClassName = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
