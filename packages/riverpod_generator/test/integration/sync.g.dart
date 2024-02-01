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
final class GenericFamily extends Family {
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

  @override
  String toString() => 'genericProvider';
}

/// See also [generic].
final class GenericProvider<T extends num> extends Provider<List<T>> {
  /// See also [generic].
  GenericProvider()
      : this._internal(
          (ref) => generic<T>(
            ref as GenericRef<T>,
          ),
          argument: (),
        );

  GenericProvider._internal(
    super.create, {
    required () super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericHash,
          from: genericProvider,
          name: r'genericProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _GenericProviderElement<T> createElement(
    ProviderContainer container,
  ) {
    return _GenericProviderElement(this, container);
  }

  @internal
  @override
  GenericProvider copyWithCreate(
    List<T> Function<T extends num>(GenericRef ref) create,
  ) {
    return GenericProvider._internal(
      (ref) => create(ref as GenericRef),
      argument: argument as (),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenericProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'genericProvider<$T>$argument';
}

mixin GenericRef<T extends num> on Ref<List<T>> {}

class _GenericProviderElement<T extends num> extends ProviderElement<List<T>>
    with GenericRef<T> {
  _GenericProviderElement(super.provider, super.container);
}

String _$complexGenericHash() => r'a5254e5552cd61bb8d65c018539ff2d8edfd5822';

/// See also [complexGeneric].
@ProviderFor(complexGeneric)
const complexGenericProvider = ComplexGenericFamily();

/// See also [complexGeneric].
final class ComplexGenericFamily extends Family {
  /// See also [complexGeneric].
  const ComplexGenericFamily()
      : super(
          name: r'complexGenericProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$complexGenericHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

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
  String toString() => 'complexGenericProvider';
}

/// See also [complexGeneric].
final class ComplexGenericProvider<T extends num, Foo extends String?>
    extends Provider<List<T>> {
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
          argument: (
            param: param,
            otherParam: otherParam,
          ),
        );

  ComplexGenericProvider._internal(
    super.create, {
    required ({
      T param,
      Foo? otherParam,
    })
        super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$complexGenericHash,
          from: complexGenericProvider,
          name: r'complexGenericProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _ComplexGenericProviderElement<T, Foo> createElement(
    ProviderContainer container,
  ) {
    return _ComplexGenericProviderElement(this, container);
  }

  @internal
  @override
  ComplexGenericProvider copyWithCreate(
    List<T> Function<T extends num, Foo extends String?>(ComplexGenericRef ref)
        create,
  ) {
    return ComplexGenericProvider._internal(
      (ref) => create(ref as ComplexGenericRef),
      argument: argument as ({
        T param,
        Foo? otherParam,
      }),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ComplexGenericProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'complexGenericProvider<$T,$Foo>$argument';
}

mixin ComplexGenericRef<T extends num, Foo extends String?> on Ref<List<T>> {
  /// The parameter `param` of this provider.
  T get param;

  /// The parameter `otherParam` of this provider.
  Foo? get otherParam;
}

class _ComplexGenericProviderElement<T extends num, Foo extends String?>
    extends ProviderElement<List<T>> with ComplexGenericRef<T, Foo> {
  _ComplexGenericProviderElement(super.provider, super.container);

  @override
  T get param => (origin as ComplexGenericProvider<T, Foo>).param;
  @override
  Foo? get otherParam => (origin as ComplexGenericProvider<T, Foo>).otherParam;
}

String _$rawFutureHash() => r'5203a56065b768023770326281618e3229ccb530';

/// See also [rawFuture].
@ProviderFor(rawFuture)
final rawFutureProvider = Provider<Raw<Future<String>>>.internal(
  rawFuture,
  name: r'rawFutureProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rawFutureHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RawFutureRef = Ref<Raw<Future<String>>>;
String _$rawStreamHash() => r'2b764189753a8b74f47ba557a79416f00ef5cebd';

/// See also [rawStream].
@ProviderFor(rawStream)
final rawStreamProvider = Provider<Raw<Stream<String>>>.internal(
  rawStream,
  name: r'rawStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rawStreamHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RawStreamRef = Ref<Raw<Stream<String>>>;
String _$rawFamilyFutureHash() => r'485f59512081852e51279658facc015309743864';

/// See also [rawFamilyFuture].
@ProviderFor(rawFamilyFuture)
const rawFamilyFutureProvider = RawFamilyFutureFamily();

/// See also [rawFamilyFuture].
final class RawFamilyFutureFamily extends Family {
  /// See also [rawFamilyFuture].
  const RawFamilyFutureFamily()
      : super(
          name: r'rawFamilyFutureProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawFamilyFutureHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [rawFamilyFuture].
  RawFamilyFutureProvider call(
    int id,
  ) {
    return RawFamilyFutureProvider(
      id,
    );
  }

  @override
  String toString() => 'rawFamilyFutureProvider';
}

/// See also [rawFamilyFuture].
final class RawFamilyFutureProvider extends Provider<Raw<Future<String>>> {
  /// See also [rawFamilyFuture].
  RawFamilyFutureProvider(
    int id,
  ) : this._internal(
          (ref) => rawFamilyFuture(
            ref as RawFamilyFutureRef,
            id,
          ),
          argument: (id,),
        );

  RawFamilyFutureProvider._internal(
    super.create, {
    required (int,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawFamilyFutureHash,
          from: rawFamilyFutureProvider,
          name: r'rawFamilyFutureProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _RawFamilyFutureProviderElement createElement(
    ProviderContainer container,
  ) {
    return _RawFamilyFutureProviderElement(this, container);
  }

  @internal
  @override
  RawFamilyFutureProvider copyWithCreate(
    Raw<Future<String>> Function(RawFamilyFutureRef ref) create,
  ) {
    return RawFamilyFutureProvider._internal(
      (ref) => create(ref as RawFamilyFutureRef),
      argument: argument as (int,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RawFamilyFutureProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'rawFamilyFutureProvider$argument';
}

mixin RawFamilyFutureRef on Ref<Raw<Future<String>>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _RawFamilyFutureProviderElement
    extends ProviderElement<Raw<Future<String>>> with RawFamilyFutureRef {
  _RawFamilyFutureProviderElement(super.provider, super.container);

  @override
  int get id => (origin as RawFamilyFutureProvider).id;
}

String _$rawFamilyStreamHash() => r'e778e5cfcb8ab381e2412f5c73213aaa03b93012';

/// See also [rawFamilyStream].
@ProviderFor(rawFamilyStream)
const rawFamilyStreamProvider = RawFamilyStreamFamily();

/// See also [rawFamilyStream].
final class RawFamilyStreamFamily extends Family {
  /// See also [rawFamilyStream].
  const RawFamilyStreamFamily()
      : super(
          name: r'rawFamilyStreamProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawFamilyStreamHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [rawFamilyStream].
  RawFamilyStreamProvider call(
    int id,
  ) {
    return RawFamilyStreamProvider(
      id,
    );
  }

  @override
  String toString() => 'rawFamilyStreamProvider';
}

/// See also [rawFamilyStream].
final class RawFamilyStreamProvider extends Provider<Raw<Stream<String>>> {
  /// See also [rawFamilyStream].
  RawFamilyStreamProvider(
    int id,
  ) : this._internal(
          (ref) => rawFamilyStream(
            ref as RawFamilyStreamRef,
            id,
          ),
          argument: (id,),
        );

  RawFamilyStreamProvider._internal(
    super.create, {
    required (int,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawFamilyStreamHash,
          from: rawFamilyStreamProvider,
          name: r'rawFamilyStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _RawFamilyStreamProviderElement createElement(
    ProviderContainer container,
  ) {
    return _RawFamilyStreamProviderElement(this, container);
  }

  @internal
  @override
  RawFamilyStreamProvider copyWithCreate(
    Raw<Stream<String>> Function(RawFamilyStreamRef ref) create,
  ) {
    return RawFamilyStreamProvider._internal(
      (ref) => create(ref as RawFamilyStreamRef),
      argument: argument as (int,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RawFamilyStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'rawFamilyStreamProvider$argument';
}

mixin RawFamilyStreamRef on Ref<Raw<Stream<String>>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _RawFamilyStreamProviderElement
    extends ProviderElement<Raw<Stream<String>>> with RawFamilyStreamRef {
  _RawFamilyStreamProviderElement(super.provider, super.container);

  @override
  int get id => (origin as RawFamilyStreamProvider).id;
}

String _$publicHash() => r'138be35943899793ab085e711fe3f3d22696a3ba';

/// This is some documentation
///
/// Copied from [public].
@ProviderFor(public)
final publicProvider = Provider<String>.internal(
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

typedef PublicRef = Ref<String>;
String _$supports$inNamesHash() => r'cbf929802fcbd0aa949ad72743d096fb3ef5f28f';

/// See also [supports$inNames].
@ProviderFor(supports$inNames)
final supports$inNamesProvider = Provider<String>.internal(
  supports$inNames,
  name: r'supports$inNamesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supports$inNamesHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef Supports$inNamesRef = Ref<String>;
String _$familyHash() => r'14d1ee238ca608d547630d0e222ef4c5866e9e61';

/// This is some documentation
///
/// Copied from [family].
@ProviderFor(family)
const familyProvider = FamilyFamily();

/// This is some documentation
///
/// Copied from [family].
final class FamilyFamily extends Family {
  /// This is some documentation
  ///
  /// Copied from [family].
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
  String toString() => 'familyProvider';
}

/// This is some documentation
///
/// Copied from [family].
final class FamilyProvider extends Provider<String> {
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
          argument: (
            first,
            second: second,
            third: third,
            fourth: fourth,
            fifth: fifth,
          ),
        );

  FamilyProvider._internal(
    super.create, {
    required (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    })
        super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyHash,
          from: familyProvider,
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _FamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _FamilyProviderElement(this, container);
  }

  @internal
  @override
  FamilyProvider copyWithCreate(
    String Function(FamilyRef ref) create,
  ) {
    return FamilyProvider._internal(
      (ref) => create(ref as FamilyRef),
      argument: argument as (
        int, {
        String? second,
        double third,
        bool fourth,
        List<String>? fifth,
      }),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'familyProvider$argument';
}

mixin FamilyRef on Ref<String> {
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

class _FamilyProviderElement extends ProviderElement<String> with FamilyRef {
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

String _$privateHash() => r'519561bc7e88e394d7f75ca2102a5c0acc832c66';

/// See also [_private].
@ProviderFor(_private)
final _privateProvider = Provider<String>.internal(
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

typedef _PrivateRef = Ref<String>;
String _$generatedHash() => r'fecbc1d5d9a05fc996b452a57fd1975ff368af91';

/// See also [generated].
@ProviderFor(generated)
final generatedProvider = Provider<String>.internal(
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

typedef GeneratedRef = Ref<String>;
String _$genericClassHash() => r'671e348a5abf8e00ab06c5f247defbca8af9677b';

abstract class _$GenericClass<T extends num>
    extends BuildlessAutoDisposeNotifier<List<T>> {
  List<T> build();
}

/// See also [GenericClass].
@ProviderFor(GenericClass)
const genericClassProvider = GenericClassFamily();

/// See also [GenericClass].
final class GenericClassFamily extends Family {
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

  @override
  String toString() => 'genericClassProvider';
}

/// See also [GenericClass].
final class GenericClassProvider<T extends num>
    extends AutoDisposeNotifierProviderImpl<GenericClass<T>, List<T>> {
  /// See also [GenericClass].
  GenericClassProvider()
      : this._internal(
          GenericClass<T>.new,
          argument: (),
        );

  GenericClassProvider._internal(
    super.create, {
    required () super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericClassHash,
          from: genericClassProvider,
          name: r'genericClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  List<T> runNotifierBuild(
    covariant GenericClass<T> notifier,
  ) {
    return notifier.build();
  }

  @internal
  @override
  AutoDisposeNotifierProviderImpl copyWithBuild(
    GenericClass Function() create,
  ) {
    return AutoDisposeNotifierProviderImpl._internal(
      create,
    );
  }

  @override
  _GenericClassProviderElement<T> createElement(
    ProviderContainer container,
  ) {
    return _GenericClassProviderElement(this, container);
  }

  @internal
  @override
  GenericClassProvider copyWithCreate(
    GenericClass Function() create,
  ) {
    return GenericClassProvider._internal(
      () => create(),
      argument: argument as (),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenericClassProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'genericClassProvider<$T>$argument';
}

mixin GenericClassRef<T extends num> on AutoDisposeNotifierProviderRef {}

class _GenericClassProviderElement<T extends num>
    extends AutoDisposeNotifierProviderElement<GenericClass<T>, List<T>>
    with GenericClassRef<T> {
  _GenericClassProviderElement(super.provider, super.container);
}

String _$rawFutureClassHash() => r'bf66f1cdbd99118b8845d206e6a2611b3101f45c';

/// See also [RawFutureClass].
@ProviderFor(RawFutureClass)
final rawFutureClassProvider =
    NotifierProvider<RawFutureClass, Raw<Future<String>>>.internal(
  RawFutureClass.new,
  name: r'rawFutureClassProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rawFutureClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RawFutureClass = Notifier<Raw<Future<String>>>;
String _$rawStreamClassHash() => r'712cffcb2018cfb4ff45012c1aa6e43c8cbe9d5d';

/// See also [RawStreamClass].
@ProviderFor(RawStreamClass)
final rawStreamClassProvider =
    NotifierProvider<RawStreamClass, Raw<Stream<String>>>.internal(
  RawStreamClass.new,
  name: r'rawStreamClassProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rawStreamClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RawStreamClass = Notifier<Raw<Stream<String>>>;
String _$rawFamilyFutureClassHash() =>
    r'd7cacb0f2c51697d107de6daa68b242c04085dca';

abstract class _$RawFamilyFutureClass
    extends BuildlessAutoDisposeNotifier<Raw<Future<String>>> {
  late final int id;

  Raw<Future<String>> build(
    int id,
  );
}

/// See also [RawFamilyFutureClass].
@ProviderFor(RawFamilyFutureClass)
const rawFamilyFutureClassProvider = RawFamilyFutureClassFamily();

/// See also [RawFamilyFutureClass].
final class RawFamilyFutureClassFamily extends Family {
  /// See also [RawFamilyFutureClass].
  const RawFamilyFutureClassFamily()
      : super(
          name: r'rawFamilyFutureClassProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawFamilyFutureClassHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [RawFamilyFutureClass].
  RawFamilyFutureClassProvider call(
    int id,
  ) {
    return RawFamilyFutureClassProvider(
      id,
    );
  }

  @override
  String toString() => 'rawFamilyFutureClassProvider';
}

/// See also [RawFamilyFutureClass].
final class RawFamilyFutureClassProvider
    extends AutoDisposeNotifierProviderImpl<RawFamilyFutureClass,
        Raw<Future<String>>> {
  /// See also [RawFamilyFutureClass].
  RawFamilyFutureClassProvider(
    int id,
  ) : this._internal(
          () => RawFamilyFutureClass()..id = id,
          argument: (id,),
        );

  RawFamilyFutureClassProvider._internal(
    super.create, {
    required (int,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawFamilyFutureClassHash,
          from: rawFamilyFutureClassProvider,
          name: r'rawFamilyFutureClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  Raw<Future<String>> runNotifierBuild(
    covariant RawFamilyFutureClass notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @internal
  @override
  AutoDisposeNotifierProviderImpl copyWithBuild(
    RawFamilyFutureClass Function() create,
  ) {
    return AutoDisposeNotifierProviderImpl._internal(
      create,
      id: id,
    );
  }

  @override
  _RawFamilyFutureClassProviderElement createElement(
    ProviderContainer container,
  ) {
    return _RawFamilyFutureClassProviderElement(this, container);
  }

  @internal
  @override
  RawFamilyFutureClassProvider copyWithCreate(
    RawFamilyFutureClass Function() create,
  ) {
    return RawFamilyFutureClassProvider._internal(
      () => create()..id = id,
      argument: argument as (int,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RawFamilyFutureClassProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'rawFamilyFutureClassProvider$argument';
}

mixin RawFamilyFutureClassRef on AutoDisposeNotifierProviderRef {
  /// The parameter `id` of this provider.
  int get id;
}

class _RawFamilyFutureClassProviderElement
    extends AutoDisposeNotifierProviderElement<RawFamilyFutureClass,
        Raw<Future<String>>> with RawFamilyFutureClassRef {
  _RawFamilyFutureClassProviderElement(super.provider, super.container);

  @override
  int get id => (origin as RawFamilyFutureClassProvider).id;
}

String _$rawFamilyStreamClassHash() =>
    r'321796a0befc43fb83f7ccfdcb6b011fc8c7c599';

abstract class _$RawFamilyStreamClass
    extends BuildlessAutoDisposeNotifier<Raw<Stream<String>>> {
  late final int id;

  Raw<Stream<String>> build(
    int id,
  );
}

/// See also [RawFamilyStreamClass].
@ProviderFor(RawFamilyStreamClass)
const rawFamilyStreamClassProvider = RawFamilyStreamClassFamily();

/// See also [RawFamilyStreamClass].
final class RawFamilyStreamClassFamily extends Family {
  /// See also [RawFamilyStreamClass].
  const RawFamilyStreamClassFamily()
      : super(
          name: r'rawFamilyStreamClassProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawFamilyStreamClassHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [RawFamilyStreamClass].
  RawFamilyStreamClassProvider call(
    int id,
  ) {
    return RawFamilyStreamClassProvider(
      id,
    );
  }

  @override
  String toString() => 'rawFamilyStreamClassProvider';
}

/// See also [RawFamilyStreamClass].
final class RawFamilyStreamClassProvider
    extends AutoDisposeNotifierProviderImpl<RawFamilyStreamClass,
        Raw<Stream<String>>> {
  /// See also [RawFamilyStreamClass].
  RawFamilyStreamClassProvider(
    int id,
  ) : this._internal(
          () => RawFamilyStreamClass()..id = id,
          argument: (id,),
        );

  RawFamilyStreamClassProvider._internal(
    super.create, {
    required (int,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawFamilyStreamClassHash,
          from: rawFamilyStreamClassProvider,
          name: r'rawFamilyStreamClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  Raw<Stream<String>> runNotifierBuild(
    covariant RawFamilyStreamClass notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @internal
  @override
  AutoDisposeNotifierProviderImpl copyWithBuild(
    RawFamilyStreamClass Function() create,
  ) {
    return AutoDisposeNotifierProviderImpl._internal(
      create,
      id: id,
    );
  }

  @override
  _RawFamilyStreamClassProviderElement createElement(
    ProviderContainer container,
  ) {
    return _RawFamilyStreamClassProviderElement(this, container);
  }

  @internal
  @override
  RawFamilyStreamClassProvider copyWithCreate(
    RawFamilyStreamClass Function() create,
  ) {
    return RawFamilyStreamClassProvider._internal(
      () => create()..id = id,
      argument: argument as (int,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RawFamilyStreamClassProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'rawFamilyStreamClassProvider$argument';
}

mixin RawFamilyStreamClassRef on AutoDisposeNotifierProviderRef {
  /// The parameter `id` of this provider.
  int get id;
}

class _RawFamilyStreamClassProviderElement
    extends AutoDisposeNotifierProviderElement<RawFamilyStreamClass,
        Raw<Stream<String>>> with RawFamilyStreamClassRef {
  _RawFamilyStreamClassProviderElement(super.provider, super.container);

  @override
  int get id => (origin as RawFamilyStreamClassProvider).id;
}

String _$publicClassHash() => r'c8e7eec9e202acf8394e02496857cbe49405bf62';

/// This is some documentation
///
/// Copied from [PublicClass].
@ProviderFor(PublicClass)
final publicClassProvider = NotifierProvider<PublicClass, String>.internal(
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

typedef _$PublicClass = Notifier<String>;
String _$privateClassHash() => r'6d41def3ffdc1f79e593beaefb3304ce4b211a77';

/// See also [_PrivateClass].
@ProviderFor(_PrivateClass)
final _privateClassProvider = NotifierProvider<_PrivateClass, String>.internal(
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

typedef _$PrivateClass = Notifier<String>;
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
final class FamilyClassFamily extends Family {
  /// This is some documentation
  ///
  /// Copied from [FamilyClass].
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
  String toString() => 'familyClassProvider';
}

/// This is some documentation
///
/// Copied from [FamilyClass].
final class FamilyClassProvider
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
          argument: (
            first,
            second: second,
            third: third,
            fourth: fourth,
            fifth: fifth,
          ),
        );

  FamilyClassProvider._internal(
    super.create, {
    required (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    })
        super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyClassHash,
          from: familyClassProvider,
          name: r'familyClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

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

  @internal
  @override
  AutoDisposeNotifierProviderImpl copyWithBuild(
    FamilyClass Function() create,
  ) {
    return AutoDisposeNotifierProviderImpl._internal(
      create,
      first: first,
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

  @internal
  @override
  FamilyClassProvider copyWithCreate(
    FamilyClass Function() create,
  ) {
    return FamilyClassProvider._internal(
      () => create()
        ..first = first
        ..second = second
        ..third = third
        ..fourth = fourth
        ..fifth = fifth,
      argument: argument as (
        int, {
        String? second,
        double third,
        bool fourth,
        List<String>? fifth,
      }),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'familyClassProvider$argument';
}

mixin FamilyClassRef on AutoDisposeNotifierProviderRef {
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

String _$supports$InClassNameHash() =>
    r'4e99f433d9cb3598faaf4d172edf9f28b9e68091';

/// See also [Supports$InClassName].
@ProviderFor(Supports$InClassName)
final supports$InClassNameProvider =
    NotifierProvider<Supports$InClassName, String>.internal(
  Supports$InClassName.new,
  name: r'supports$InClassNameProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supports$InClassNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Supports$InClassName = Notifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
