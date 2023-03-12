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

typedef Count2Ref = AutoDisposeProviderRef<int>;

/// See also [count2].
@ProviderFor(count2)
const count2ProviderFamily = Count2Family();

/// See also [count2].
class Count2Family extends Family<int> {
  /// See also [count2].
  const Count2Family();

  /// See also [count2].
  Count2Provider call(
    int a,
  ) {
    return Count2Provider(
      a,
    );
  }

  @override
  Count2Provider getProviderOverride(
    covariant Count2Provider provider,
  ) {
    return call(
      provider.a,
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
  String? get name => r'count2ProviderFamily';
}

/// See also [count2].
class Count2Provider extends AutoDisposeProvider<int> {
  /// See also [count2].
  Count2Provider(
    this.a,
  ) : super.internal(
          (ref) => count2(
            ref,
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
        );

  final int a;

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

String _$countFuture2Hash() => r'096675b70a267f5d7c62ac7d3e7dd231ef529034';
typedef CountFuture2Ref = AutoDisposeFutureProviderRef<int>;

/// See also [countFuture2].
@ProviderFor(countFuture2)
const countFuture2ProviderFamily = CountFuture2Family();

/// See also [countFuture2].
class CountFuture2Family extends Family<AsyncValue<int>> {
  /// See also [countFuture2].
  const CountFuture2Family();

  /// See also [countFuture2].
  CountFuture2Provider call(
    int a,
  ) {
    return CountFuture2Provider(
      a,
    );
  }

  @override
  CountFuture2Provider getProviderOverride(
    covariant CountFuture2Provider provider,
  ) {
    return call(
      provider.a,
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
  String? get name => r'countFuture2ProviderFamily';
}

/// See also [countFuture2].
class CountFuture2Provider extends AutoDisposeFutureProvider<int> {
  /// See also [countFuture2].
  CountFuture2Provider(
    this.a,
  ) : super.internal(
          (ref) => countFuture2(
            ref,
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
        );

  final int a;

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

String _$countStream2Hash() => r'051264dd685ebc0a57e454bb676957c93cb4ae20';
typedef CountStream2Ref = AutoDisposeStreamProviderRef<int>;

/// See also [countStream2].
@ProviderFor(countStream2)
const countStream2ProviderFamily = CountStream2Family();

/// See also [countStream2].
class CountStream2Family extends Family<AsyncValue<int>> {
  /// See also [countStream2].
  const CountStream2Family();

  /// See also [countStream2].
  CountStream2Provider call(
    int a,
  ) {
    return CountStream2Provider(
      a,
    );
  }

  @override
  CountStream2Provider getProviderOverride(
    covariant CountStream2Provider provider,
  ) {
    return call(
      provider.a,
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
  String? get name => r'countStream2ProviderFamily';
}

/// See also [countStream2].
class CountStream2Provider extends AutoDisposeStreamProvider<int> {
  /// See also [countStream2].
  CountStream2Provider(
    this.a,
  ) : super.internal(
          (ref) => countStream2(
            ref,
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
        );

  final int a;

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

  /// See also [CountNotifier2].
  CountNotifier2Provider call(
    int a,
  ) {
    return CountNotifier2Provider(
      a,
    );
  }

  @override
  CountNotifier2Provider getProviderOverride(
    covariant CountNotifier2Provider provider,
  ) {
    return call(
      provider.a,
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
  String? get name => r'countNotifier2ProviderFamily';
}

/// See also [CountNotifier2].
class CountNotifier2Provider
    extends AutoDisposeNotifierProviderImpl<CountNotifier2, int> {
  /// See also [CountNotifier2].
  CountNotifier2Provider(
    this.a,
  ) : super.internal(
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
        );

  final int a;

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

  @override
  int runNotifierBuild(
    covariant CountNotifier2 notifier,
  ) {
    return notifier.build(
      a,
    );
  }
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

  /// See also [CountAsyncNotifier2].
  CountAsyncNotifier2Provider call(
    int a,
  ) {
    return CountAsyncNotifier2Provider(
      a,
    );
  }

  @override
  CountAsyncNotifier2Provider getProviderOverride(
    covariant CountAsyncNotifier2Provider provider,
  ) {
    return call(
      provider.a,
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
  String? get name => r'countAsyncNotifier2ProviderFamily';
}

/// See also [CountAsyncNotifier2].
class CountAsyncNotifier2Provider
    extends AutoDisposeAsyncNotifierProviderImpl<CountAsyncNotifier2, int> {
  /// See also [CountAsyncNotifier2].
  CountAsyncNotifier2Provider(
    this.a,
  ) : super.internal(
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
        );

  final int a;

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

  @override
  FutureOr<int> runNotifierBuild(
    covariant CountAsyncNotifier2 notifier,
  ) {
    return notifier.build(
      a,
    );
  }
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

  /// See also [CountStreamNotifier2].
  CountStreamNotifier2Provider call(
    int a,
  ) {
    return CountStreamNotifier2Provider(
      a,
    );
  }

  @override
  CountStreamNotifier2Provider getProviderOverride(
    covariant CountStreamNotifier2Provider provider,
  ) {
    return call(
      provider.a,
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
  String? get name => r'countStreamNotifier2ProviderFamily';
}

/// See also [CountStreamNotifier2].
class CountStreamNotifier2Provider
    extends AutoDisposeStreamNotifierProviderImpl<CountStreamNotifier2, int> {
  /// See also [CountStreamNotifier2].
  CountStreamNotifier2Provider(
    this.a,
  ) : super.internal(
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
        );

  final int a;

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

  @override
  Stream<int> runNotifierBuild(
    covariant CountStreamNotifier2 notifier,
  ) {
    return notifier.build(
      a,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
