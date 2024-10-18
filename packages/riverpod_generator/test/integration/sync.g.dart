// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rawFutureHash() => r'9d397f4c0a578a2741610f9ca6f17438ee8e5a34';

/// See also [rawFuture].
@ProviderFor(rawFuture)
final rawFutureProvider = AutoDisposeProvider<Raw<Future<String>>>.internal(
  rawFuture,
  name: r'rawFutureProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rawFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RawFutureRef = AutoDisposeProviderRef<Raw<Future<String>>>;
String _$rawStreamHash() => r'c7d6cd22f1f325827c866c3ec757d08315fd9858';

/// See also [rawStream].
@ProviderFor(rawStream)
final rawStreamProvider = AutoDisposeProvider<Raw<Stream<String>>>.internal(
  rawStream,
  name: r'rawStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rawStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RawStreamRef = AutoDisposeProviderRef<Raw<Stream<String>>>;
String _$rawFamilyFutureHash() => r'0ac70d7a2133691f1a9a38cedaeeb6b3bc667ade';

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

/// See also [rawFamilyFuture].
@ProviderFor(rawFamilyFuture)
const rawFamilyFutureProvider = RawFamilyFutureFamily();

/// See also [rawFamilyFuture].
class RawFamilyFutureFamily extends Family<Raw<Future<String>>> {
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
class RawFamilyFutureProvider extends AutoDisposeProvider<Raw<Future<String>>> {
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
    Raw<Future<String>> Function(RawFamilyFutureRef provider) create,
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
  AutoDisposeProviderElement<Raw<Future<String>>> createElement() {
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RawFamilyFutureRef on AutoDisposeProviderRef<Raw<Future<String>>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _RawFamilyFutureProviderElement
    extends AutoDisposeProviderElement<Raw<Future<String>>>
    with RawFamilyFutureRef {
  _RawFamilyFutureProviderElement(super.provider);

  @override
  int get id => (origin as RawFamilyFutureProvider).id;
}

String _$rawFamilyStreamHash() => r'6eacfa3a3576d884099c08c298751a3d395271be';

/// See also [rawFamilyStream].
@ProviderFor(rawFamilyStream)
const rawFamilyStreamProvider = RawFamilyStreamFamily();

/// See also [rawFamilyStream].
class RawFamilyStreamFamily extends Family<Raw<Stream<String>>> {
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
class RawFamilyStreamProvider extends AutoDisposeProvider<Raw<Stream<String>>> {
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
    Raw<Stream<String>> Function(RawFamilyStreamRef provider) create,
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
  AutoDisposeProviderElement<Raw<Stream<String>>> createElement() {
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RawFamilyStreamRef on AutoDisposeProviderRef<Raw<Stream<String>>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _RawFamilyStreamProviderElement
    extends AutoDisposeProviderElement<Raw<Stream<String>>>
    with RawFamilyStreamRef {
  _RawFamilyStreamProviderElement(super.provider);

  @override
  int get id => (origin as RawFamilyStreamProvider).id;
}

String _$publicHash() => r'94bee36125844f9fe521363bb228632b9f3bfbc7';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PublicRef = AutoDisposeProviderRef<String>;
String _$supports$inNamesHash() => r'8da1f9329f302ce75e38d03c96595de3260b4d2d';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef Supports$inNamesRef = AutoDisposeProviderRef<String>;
String _$familyHash() => r'f58149448f80f10ec054f2f8a6f37bae61e38f49';

/// This is some documentation
///
/// Copied from [family].
@ProviderFor(family)
const familyProvider = FamilyFamily();

/// This is some documentation
///
/// Copied from [family].
class FamilyFamily extends Family<String> {
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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

String _$privateHash() => r'834affaed42662bf46ce7f6203ac2495e1e8974b';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _PrivateRef = AutoDisposeProviderRef<String>;
String _$generatedHash() => r'24bfb5df4dc529258ab568372e90a1cbfc2d8c24';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GeneratedRef = AutoDisposeProviderRef<String>;
String _$rawFutureClassHash() => r'bf66f1cdbd99118b8845d206e6a2611b3101f45c';

/// See also [RawFutureClass].
@ProviderFor(RawFutureClass)
final rawFutureClassProvider =
    AutoDisposeNotifierProvider<RawFutureClass, Raw<Future<String>>>.internal(
  RawFutureClass.new,
  name: r'rawFutureClassProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rawFutureClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RawFutureClass = AutoDisposeNotifier<Raw<Future<String>>>;
String _$rawStreamClassHash() => r'712cffcb2018cfb4ff45012c1aa6e43c8cbe9d5d';

/// See also [RawStreamClass].
@ProviderFor(RawStreamClass)
final rawStreamClassProvider =
    AutoDisposeNotifierProvider<RawStreamClass, Raw<Stream<String>>>.internal(
  RawStreamClass.new,
  name: r'rawStreamClassProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rawStreamClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RawStreamClass = AutoDisposeNotifier<Raw<Stream<String>>>;
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
class RawFamilyFutureClassFamily extends Family<Raw<Future<String>>> {
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
    RawFamilyFutureClass, Raw<Future<String>>> {
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
  Raw<Future<String>> runNotifierBuild(
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
  AutoDisposeNotifierProviderElement<RawFamilyFutureClass, Raw<Future<String>>>
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RawFamilyFutureClassRef
    on AutoDisposeNotifierProviderRef<Raw<Future<String>>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _RawFamilyFutureClassProviderElement
    extends AutoDisposeNotifierProviderElement<RawFamilyFutureClass,
        Raw<Future<String>>> with RawFamilyFutureClassRef {
  _RawFamilyFutureClassProviderElement(super.provider);

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
class RawFamilyStreamClassFamily extends Family<Raw<Stream<String>>> {
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
    RawFamilyStreamClass, Raw<Stream<String>>> {
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
  Raw<Stream<String>> runNotifierBuild(
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
  AutoDisposeNotifierProviderElement<RawFamilyStreamClass, Raw<Stream<String>>>
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RawFamilyStreamClassRef
    on AutoDisposeNotifierProviderRef<Raw<Stream<String>>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _RawFamilyStreamClassProviderElement
    extends AutoDisposeNotifierProviderElement<RawFamilyStreamClass,
        Raw<Stream<String>>> with RawFamilyStreamClassRef {
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
class FamilyClassFamily extends Family<String> {
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
