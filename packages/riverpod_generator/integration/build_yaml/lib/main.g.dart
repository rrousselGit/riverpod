// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$countHash() => r'4c7e72b275767a60ece5e8662ab1e28f73cf7e44';

/// See also [count].
@ProviderFor(count)
final countPod = AutoDisposeProvider<int>.internal(
  count,
  name: r'countPod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$countHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CountRef = AutoDisposeProviderRef<int>;
String _$countFutureHash() => r'ec7cc31ce1c1a10607f1dcb35dd217acd2877729';

/// See also [countFuture].
@ProviderFor(countFuture)
final countFuturePod = AutoDisposeFutureProvider<int>.internal(
  countFuture,
  name: r'countFuturePod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$countFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CountFutureRef = AutoDisposeFutureProviderRef<int>;
String _$countStreamHash() => r'1dbe49244ea19e8dbc3af0534429bb323720c07a';

/// See also [countStream].
@ProviderFor(countStream)
final countStreamPod = AutoDisposeStreamProvider<int>.internal(
  countStream,
  name: r'countStreamPod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$countStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CountStreamRef = AutoDisposeStreamProviderRef<int>;
String _$count2Hash() => r'6256825480d83bb13acde282cf3c9d9524cc3a6c';

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

/// See also [count2].
@ProviderFor(count2)
const count2ProviderFamily = Count2Family();

/// See also [count2].
class Count2Family extends Family<int> {
  /// See also [count2].
  const Count2Family();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'count2ProviderFamily';

  /// See also [count2].
  Count2Provider call(
    int a,
  ) {
    return Count2Provider(
      a,
    );
  }

  @visibleForOverriding
  @override
  Count2Provider getProviderOverride(
    covariant Count2Provider provider,
  ) {
    return call(
      provider.a,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(int Function(Count2Ref ref) create) {
    return _$Count2FamilyOverride(this, create);
  }
}

class _$Count2FamilyOverride implements FamilyOverride<int> {
  _$Count2FamilyOverride(this.overriddenFamily, this.create);

  final int Function(Count2Ref ref) create;

  @override
  final Count2Family overriddenFamily;

  @override
  Count2Provider getProviderOverride(
    covariant Count2Provider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [count2].
class Count2Provider extends AutoDisposeProvider<int> {
  /// See also [count2].
  Count2Provider(
    int a,
  ) : this._internal(
          (ref) => count2(
            ref as Count2Ref,
            a,
          ),
          from: count2ProviderFamily,
          name: r'count2ProviderFamily',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$count2Hash,
          dependencies: Count2Family._dependencies,
          allTransitiveDependencies: Count2Family._allTransitiveDependencies,
          a: a,
        );

  Count2Provider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.a,
  }) : super.internal();

  final int a;

  @override
  Override overrideWith(
    int Function(Count2Ref ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: Count2Provider._internal(
        (ref) => create(ref as Count2Ref),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        a: a,
      ),
    );
  }

  @override
  (int,) get argument {
    return (a,);
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _Count2ProviderElement(this);
  }

  Count2Provider _copyWith(
    int Function(Count2Ref ref) create,
  ) {
    return Count2Provider._internal(
      (ref) => create(ref as Count2Ref),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      a: a,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Count2Provider && other.a == a;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, a.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin Count2Ref on AutoDisposeProviderRef<int> {
  /// The parameter `a` of this provider.
  int get a;
}

class _Count2ProviderElement extends AutoDisposeProviderElement<int>
    with Count2Ref {
  _Count2ProviderElement(super.provider);

  @override
  int get a => (origin as Count2Provider).a;
}

String _$countFuture2Hash() => r'096675b70a267f5d7c62ac7d3e7dd231ef529034';

/// See also [countFuture2].
@ProviderFor(countFuture2)
const countFuture2ProviderFamily = CountFuture2Family();

/// See also [countFuture2].
class CountFuture2Family extends Family<AsyncValue<int>> {
  /// See also [countFuture2].
  const CountFuture2Family();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'countFuture2ProviderFamily';

  /// See also [countFuture2].
  CountFuture2Provider call(
    int a,
  ) {
    return CountFuture2Provider(
      a,
    );
  }

  @visibleForOverriding
  @override
  CountFuture2Provider getProviderOverride(
    covariant CountFuture2Provider provider,
  ) {
    return call(
      provider.a,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<int> Function(CountFuture2Ref ref) create) {
    return _$CountFuture2FamilyOverride(this, create);
  }
}

class _$CountFuture2FamilyOverride implements FamilyOverride<AsyncValue<int>> {
  _$CountFuture2FamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<int> Function(CountFuture2Ref ref) create;

  @override
  final CountFuture2Family overriddenFamily;

  @override
  CountFuture2Provider getProviderOverride(
    covariant CountFuture2Provider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [countFuture2].
class CountFuture2Provider extends AutoDisposeFutureProvider<int> {
  /// See also [countFuture2].
  CountFuture2Provider(
    int a,
  ) : this._internal(
          (ref) => countFuture2(
            ref as CountFuture2Ref,
            a,
          ),
          from: countFuture2ProviderFamily,
          name: r'countFuture2ProviderFamily',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$countFuture2Hash,
          dependencies: CountFuture2Family._dependencies,
          allTransitiveDependencies:
              CountFuture2Family._allTransitiveDependencies,
          a: a,
        );

  CountFuture2Provider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.a,
  }) : super.internal();

  final int a;

  @override
  Override overrideWith(
    FutureOr<int> Function(CountFuture2Ref ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CountFuture2Provider._internal(
        (ref) => create(ref as CountFuture2Ref),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        a: a,
      ),
    );
  }

  @override
  (int,) get argument {
    return (a,);
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _CountFuture2ProviderElement(this);
  }

  CountFuture2Provider _copyWith(
    FutureOr<int> Function(CountFuture2Ref ref) create,
  ) {
    return CountFuture2Provider._internal(
      (ref) => create(ref as CountFuture2Ref),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      a: a,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CountFuture2Provider && other.a == a;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, a.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CountFuture2Ref on AutoDisposeFutureProviderRef<int> {
  /// The parameter `a` of this provider.
  int get a;
}

class _CountFuture2ProviderElement extends AutoDisposeFutureProviderElement<int>
    with CountFuture2Ref {
  _CountFuture2ProviderElement(super.provider);

  @override
  int get a => (origin as CountFuture2Provider).a;
}

String _$countStream2Hash() => r'051264dd685ebc0a57e454bb676957c93cb4ae20';

/// See also [countStream2].
@ProviderFor(countStream2)
const countStream2ProviderFamily = CountStream2Family();

/// See also [countStream2].
class CountStream2Family extends Family<AsyncValue<int>> {
  /// See also [countStream2].
  const CountStream2Family();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'countStream2ProviderFamily';

  /// See also [countStream2].
  CountStream2Provider call(
    int a,
  ) {
    return CountStream2Provider(
      a,
    );
  }

  @visibleForOverriding
  @override
  CountStream2Provider getProviderOverride(
    covariant CountStream2Provider provider,
  ) {
    return call(
      provider.a,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(Stream<int> Function(CountStream2Ref ref) create) {
    return _$CountStream2FamilyOverride(this, create);
  }
}

class _$CountStream2FamilyOverride implements FamilyOverride<AsyncValue<int>> {
  _$CountStream2FamilyOverride(this.overriddenFamily, this.create);

  final Stream<int> Function(CountStream2Ref ref) create;

  @override
  final CountStream2Family overriddenFamily;

  @override
  CountStream2Provider getProviderOverride(
    covariant CountStream2Provider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [countStream2].
class CountStream2Provider extends AutoDisposeStreamProvider<int> {
  /// See also [countStream2].
  CountStream2Provider(
    int a,
  ) : this._internal(
          (ref) => countStream2(
            ref as CountStream2Ref,
            a,
          ),
          from: countStream2ProviderFamily,
          name: r'countStream2ProviderFamily',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$countStream2Hash,
          dependencies: CountStream2Family._dependencies,
          allTransitiveDependencies:
              CountStream2Family._allTransitiveDependencies,
          a: a,
        );

  CountStream2Provider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.a,
  }) : super.internal();

  final int a;

  @override
  Override overrideWith(
    Stream<int> Function(CountStream2Ref ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CountStream2Provider._internal(
        (ref) => create(ref as CountStream2Ref),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        a: a,
      ),
    );
  }

  @override
  (int,) get argument {
    return (a,);
  }

  @override
  AutoDisposeStreamProviderElement<int> createElement() {
    return _CountStream2ProviderElement(this);
  }

  CountStream2Provider _copyWith(
    Stream<int> Function(CountStream2Ref ref) create,
  ) {
    return CountStream2Provider._internal(
      (ref) => create(ref as CountStream2Ref),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      a: a,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CountStream2Provider && other.a == a;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, a.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CountStream2Ref on AutoDisposeStreamProviderRef<int> {
  /// The parameter `a` of this provider.
  int get a;
}

class _CountStream2ProviderElement extends AutoDisposeStreamProviderElement<int>
    with CountStream2Ref {
  _CountStream2ProviderElement(super.provider);

  @override
  int get a => (origin as CountStream2Provider).a;
}

String _$countNotifierHash() => r'a8dd7a66ee0002b8af657245c4affaa206fd99ec';

/// See also [CountNotifier].
@ProviderFor(CountNotifier)
final countNotifierPod =
    AutoDisposeNotifierProvider<CountNotifier, int>.internal(
  CountNotifier.new,
  name: r'countNotifierPod',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$countNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CountNotifier = AutoDisposeNotifier<int>;
String _$countAsyncNotifierHash() =>
    r'2a7049d864bf396e44a5937b4001efb4774a5f29';

/// See also [CountAsyncNotifier].
@ProviderFor(CountAsyncNotifier)
final countAsyncNotifierPod =
    AutoDisposeAsyncNotifierProvider<CountAsyncNotifier, int>.internal(
  CountAsyncNotifier.new,
  name: r'countAsyncNotifierPod',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$countAsyncNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CountAsyncNotifier = AutoDisposeAsyncNotifier<int>;
String _$countStreamNotifierHash() =>
    r'61d2cd311c4808f8d7e8b2d67f5c7b85337666c6';

/// See also [CountStreamNotifier].
@ProviderFor(CountStreamNotifier)
final countStreamNotifierPod =
    AutoDisposeStreamNotifierProvider<CountStreamNotifier, int>.internal(
  CountStreamNotifier.new,
  name: r'countStreamNotifierPod',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$countStreamNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CountStreamNotifier = AutoDisposeStreamNotifier<int>;
String _$countNotifier2Hash() => r'ef12bb4f94add336804ae43bcdbcd8e9b0bec420';

abstract class _$CountNotifier2 extends BuildlessAutoDisposeNotifier<int> {
  late final int a;

  int build(
    int a,
  );
}

/// See also [CountNotifier2].
@ProviderFor(CountNotifier2)
const countNotifier2ProviderFamily = CountNotifier2Family();

/// See also [CountNotifier2].
class CountNotifier2Family extends Family<int> {
  /// See also [CountNotifier2].
  const CountNotifier2Family();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'countNotifier2ProviderFamily';

  /// See also [CountNotifier2].
  CountNotifier2Provider call(
    int a,
  ) {
    return CountNotifier2Provider(
      a,
    );
  }

  @visibleForOverriding
  @override
  CountNotifier2Provider getProviderOverride(
    covariant CountNotifier2Provider provider,
  ) {
    return call(
      provider.a,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(CountNotifier2 Function() create) {
    return _$CountNotifier2FamilyOverride(this, create);
  }
}

class _$CountNotifier2FamilyOverride implements FamilyOverride<int> {
  _$CountNotifier2FamilyOverride(this.overriddenFamily, this.create);

  final CountNotifier2 Function() create;

  @override
  final CountNotifier2Family overriddenFamily;

  @override
  CountNotifier2Provider getProviderOverride(
    covariant CountNotifier2Provider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [CountNotifier2].
class CountNotifier2Provider
    extends AutoDisposeNotifierProviderImpl<CountNotifier2, int> {
  /// See also [CountNotifier2].
  CountNotifier2Provider(
    int a,
  ) : this._internal(
          () => CountNotifier2()..a = a,
          from: countNotifier2ProviderFamily,
          name: r'countNotifier2ProviderFamily',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$countNotifier2Hash,
          dependencies: CountNotifier2Family._dependencies,
          allTransitiveDependencies:
              CountNotifier2Family._allTransitiveDependencies,
          a: a,
        );

  CountNotifier2Provider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.a,
  }) : super.internal();

  final int a;

  @override
  int runNotifierBuild(
    covariant CountNotifier2 notifier,
  ) {
    return notifier.build(
      a,
    );
  }

  @override
  Override overrideWith(CountNotifier2 Function() create) {
    return ProviderOverride(
      origin: this,
      override: CountNotifier2Provider._internal(
        () => create()..a = a,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        a: a,
      ),
    );
  }

  @override
  (int,) get argument {
    return (a,);
  }

  @override
  AutoDisposeNotifierProviderElement<CountNotifier2, int> createElement() {
    return _CountNotifier2ProviderElement(this);
  }

  CountNotifier2Provider _copyWith(
    CountNotifier2 Function() create,
  ) {
    return CountNotifier2Provider._internal(
      () => create()..a = a,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      a: a,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CountNotifier2Provider && other.a == a;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, a.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CountNotifier2Ref on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `a` of this provider.
  int get a;
}

class _CountNotifier2ProviderElement
    extends AutoDisposeNotifierProviderElement<CountNotifier2, int>
    with CountNotifier2Ref {
  _CountNotifier2ProviderElement(super.provider);

  @override
  int get a => (origin as CountNotifier2Provider).a;
}

String _$countAsyncNotifier2Hash() =>
    r'e4bd4d858edbb47fa0d7581f3cfa72e13c914d3d';

abstract class _$CountAsyncNotifier2
    extends BuildlessAutoDisposeAsyncNotifier<int> {
  late final int a;

  FutureOr<int> build(
    int a,
  );
}

/// See also [CountAsyncNotifier2].
@ProviderFor(CountAsyncNotifier2)
const countAsyncNotifier2ProviderFamily = CountAsyncNotifier2Family();

/// See also [CountAsyncNotifier2].
class CountAsyncNotifier2Family extends Family<AsyncValue<int>> {
  /// See also [CountAsyncNotifier2].
  const CountAsyncNotifier2Family();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'countAsyncNotifier2ProviderFamily';

  /// See also [CountAsyncNotifier2].
  CountAsyncNotifier2Provider call(
    int a,
  ) {
    return CountAsyncNotifier2Provider(
      a,
    );
  }

  @visibleForOverriding
  @override
  CountAsyncNotifier2Provider getProviderOverride(
    covariant CountAsyncNotifier2Provider provider,
  ) {
    return call(
      provider.a,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(CountAsyncNotifier2 Function() create) {
    return _$CountAsyncNotifier2FamilyOverride(this, create);
  }
}

class _$CountAsyncNotifier2FamilyOverride
    implements FamilyOverride<AsyncValue<int>> {
  _$CountAsyncNotifier2FamilyOverride(this.overriddenFamily, this.create);

  final CountAsyncNotifier2 Function() create;

  @override
  final CountAsyncNotifier2Family overriddenFamily;

  @override
  CountAsyncNotifier2Provider getProviderOverride(
    covariant CountAsyncNotifier2Provider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [CountAsyncNotifier2].
class CountAsyncNotifier2Provider
    extends AutoDisposeAsyncNotifierProviderImpl<CountAsyncNotifier2, int> {
  /// See also [CountAsyncNotifier2].
  CountAsyncNotifier2Provider(
    int a,
  ) : this._internal(
          () => CountAsyncNotifier2()..a = a,
          from: countAsyncNotifier2ProviderFamily,
          name: r'countAsyncNotifier2ProviderFamily',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$countAsyncNotifier2Hash,
          dependencies: CountAsyncNotifier2Family._dependencies,
          allTransitiveDependencies:
              CountAsyncNotifier2Family._allTransitiveDependencies,
          a: a,
        );

  CountAsyncNotifier2Provider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.a,
  }) : super.internal();

  final int a;

  @override
  FutureOr<int> runNotifierBuild(
    covariant CountAsyncNotifier2 notifier,
  ) {
    return notifier.build(
      a,
    );
  }

  @override
  Override overrideWith(CountAsyncNotifier2 Function() create) {
    return ProviderOverride(
      origin: this,
      override: CountAsyncNotifier2Provider._internal(
        () => create()..a = a,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        a: a,
      ),
    );
  }

  @override
  (int,) get argument {
    return (a,);
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CountAsyncNotifier2, int>
      createElement() {
    return _CountAsyncNotifier2ProviderElement(this);
  }

  CountAsyncNotifier2Provider _copyWith(
    CountAsyncNotifier2 Function() create,
  ) {
    return CountAsyncNotifier2Provider._internal(
      () => create()..a = a,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      a: a,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CountAsyncNotifier2Provider && other.a == a;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, a.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CountAsyncNotifier2Ref on AutoDisposeAsyncNotifierProviderRef<int> {
  /// The parameter `a` of this provider.
  int get a;
}

class _CountAsyncNotifier2ProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CountAsyncNotifier2, int>
    with CountAsyncNotifier2Ref {
  _CountAsyncNotifier2ProviderElement(super.provider);

  @override
  int get a => (origin as CountAsyncNotifier2Provider).a;
}

String _$countStreamNotifier2Hash() =>
    r'13be1b7aa32801b33c68f2a228851d2fb6a4a9ee';

abstract class _$CountStreamNotifier2
    extends BuildlessAutoDisposeStreamNotifier<int> {
  late final int a;

  Stream<int> build(
    int a,
  );
}

/// See also [CountStreamNotifier2].
@ProviderFor(CountStreamNotifier2)
const countStreamNotifier2ProviderFamily = CountStreamNotifier2Family();

/// See also [CountStreamNotifier2].
class CountStreamNotifier2Family extends Family<AsyncValue<int>> {
  /// See also [CountStreamNotifier2].
  const CountStreamNotifier2Family();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'countStreamNotifier2ProviderFamily';

  /// See also [CountStreamNotifier2].
  CountStreamNotifier2Provider call(
    int a,
  ) {
    return CountStreamNotifier2Provider(
      a,
    );
  }

  @visibleForOverriding
  @override
  CountStreamNotifier2Provider getProviderOverride(
    covariant CountStreamNotifier2Provider provider,
  ) {
    return call(
      provider.a,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(CountStreamNotifier2 Function() create) {
    return _$CountStreamNotifier2FamilyOverride(this, create);
  }
}

class _$CountStreamNotifier2FamilyOverride
    implements FamilyOverride<AsyncValue<int>> {
  _$CountStreamNotifier2FamilyOverride(this.overriddenFamily, this.create);

  final CountStreamNotifier2 Function() create;

  @override
  final CountStreamNotifier2Family overriddenFamily;

  @override
  CountStreamNotifier2Provider getProviderOverride(
    covariant CountStreamNotifier2Provider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [CountStreamNotifier2].
class CountStreamNotifier2Provider
    extends AutoDisposeStreamNotifierProviderImpl<CountStreamNotifier2, int> {
  /// See also [CountStreamNotifier2].
  CountStreamNotifier2Provider(
    int a,
  ) : this._internal(
          () => CountStreamNotifier2()..a = a,
          from: countStreamNotifier2ProviderFamily,
          name: r'countStreamNotifier2ProviderFamily',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$countStreamNotifier2Hash,
          dependencies: CountStreamNotifier2Family._dependencies,
          allTransitiveDependencies:
              CountStreamNotifier2Family._allTransitiveDependencies,
          a: a,
        );

  CountStreamNotifier2Provider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.a,
  }) : super.internal();

  final int a;

  @override
  Stream<int> runNotifierBuild(
    covariant CountStreamNotifier2 notifier,
  ) {
    return notifier.build(
      a,
    );
  }

  @override
  Override overrideWith(CountStreamNotifier2 Function() create) {
    return ProviderOverride(
      origin: this,
      override: CountStreamNotifier2Provider._internal(
        () => create()..a = a,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        a: a,
      ),
    );
  }

  @override
  (int,) get argument {
    return (a,);
  }

  @override
  AutoDisposeStreamNotifierProviderElement<CountStreamNotifier2, int>
      createElement() {
    return _CountStreamNotifier2ProviderElement(this);
  }

  CountStreamNotifier2Provider _copyWith(
    CountStreamNotifier2 Function() create,
  ) {
    return CountStreamNotifier2Provider._internal(
      () => create()..a = a,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      a: a,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CountStreamNotifier2Provider && other.a == a;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, a.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CountStreamNotifier2Ref on AutoDisposeStreamNotifierProviderRef<int> {
  /// The parameter `a` of this provider.
  int get a;
}

class _CountStreamNotifier2ProviderElement
    extends AutoDisposeStreamNotifierProviderElement<CountStreamNotifier2, int>
    with CountStreamNotifier2Ref {
  _CountStreamNotifier2ProviderElement(super.provider);

  @override
  int get a => (origin as CountStreamNotifier2Provider).a;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
