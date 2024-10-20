// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protected_notifier_properties.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aHash() => r'9bf449b010f4dd5800e78f9f5b8a431b1a79c8b7';

/// See also [A].
@ProviderFor(A)
final aProvider = AutoDisposeNotifierProvider<A, int>.internal(
  A.new,
  name: r'aProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$A = AutoDisposeNotifier<int>;
String _$a2Hash() => r'898d46cbcec03233c7b8b0754810a6903226aa2e';

/// See also [A2].
@ProviderFor(A2)
final a2Provider = NotifierProvider<A2, int>.internal(
  A2.new,
  name: r'a2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$a2Hash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$A2 = Notifier<int>;
String _$a3Hash() => r'2e21e9af8b67b5412611e0d23b862ead56deb8e1';

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

abstract class _$A3 extends BuildlessAutoDisposeNotifier<int> {
  late final int param;

  int build(
    int param,
  );
}

/// See also [A3].
@ProviderFor(A3)
const a3Provider = A3Family();

/// See also [A3].
class A3Family extends Family<int> {
  /// See also [A3].
  const A3Family();

  /// See also [A3].
  A3Provider call(
    int param,
  ) {
    return A3Provider(
      param,
    );
  }

  @override
  A3Provider getProviderOverride(
    covariant A3Provider provider,
  ) {
    return call(
      provider.param,
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
  String? get name => r'a3Provider';
}

/// See also [A3].
class A3Provider extends AutoDisposeNotifierProviderImpl<A3, int> {
  /// See also [A3].
  A3Provider(
    int param,
  ) : this._internal(
          () => A3()..param = param,
          from: a3Provider,
          name: r'a3Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$a3Hash,
          dependencies: A3Family._dependencies,
          allTransitiveDependencies: A3Family._allTransitiveDependencies,
          param: param,
        );

  A3Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.param,
  }) : super.internal();

  final int param;

  @override
  int runNotifierBuild(
    covariant A3 notifier,
  ) {
    return notifier.build(
      param,
    );
  }

  @override
  Override overrideWith(A3 Function() create) {
    return ProviderOverride(
      origin: this,
      override: A3Provider._internal(
        () => create()..param = param,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        param: param,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<A3, int> createElement() {
    return _A3ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is A3Provider && other.param == param;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, param.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin A3Ref on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `param` of this provider.
  int get param;
}

class _A3ProviderElement extends AutoDisposeNotifierProviderElement<A3, int>
    with A3Ref {
  _A3ProviderElement(super.provider);

  @override
  int get param => (origin as A3Provider).param;
}

String _$a4Hash() => r'cdd9ad09099881cafe06d7b3095a8b06dbe7d876';

abstract class _$A4 extends BuildlessNotifier<int> {
  late final int param;

  int build(
    int param,
  );
}

/// See also [A4].
@ProviderFor(A4)
const a4Provider = A4Family();

/// See also [A4].
class A4Family extends Family<int> {
  /// See also [A4].
  const A4Family();

  /// See also [A4].
  A4Provider call(
    int param,
  ) {
    return A4Provider(
      param,
    );
  }

  @override
  A4Provider getProviderOverride(
    covariant A4Provider provider,
  ) {
    return call(
      provider.param,
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
  String? get name => r'a4Provider';
}

/// See also [A4].
class A4Provider extends NotifierProviderImpl<A4, int> {
  /// See also [A4].
  A4Provider(
    int param,
  ) : this._internal(
          () => A4()..param = param,
          from: a4Provider,
          name: r'a4Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$a4Hash,
          dependencies: A4Family._dependencies,
          allTransitiveDependencies: A4Family._allTransitiveDependencies,
          param: param,
        );

  A4Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.param,
  }) : super.internal();

  final int param;

  @override
  int runNotifierBuild(
    covariant A4 notifier,
  ) {
    return notifier.build(
      param,
    );
  }

  @override
  Override overrideWith(A4 Function() create) {
    return ProviderOverride(
      origin: this,
      override: A4Provider._internal(
        () => create()..param = param,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        param: param,
      ),
    );
  }

  @override
  NotifierProviderElement<A4, int> createElement() {
    return _A4ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is A4Provider && other.param == param;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, param.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin A4Ref on NotifierProviderRef<int> {
  /// The parameter `param` of this provider.
  int get param;
}

class _A4ProviderElement extends NotifierProviderElement<A4, int> with A4Ref {
  _A4ProviderElement(super.provider);

  @override
  int get param => (origin as A4Provider).param;
}

String _$a5Hash() => r'c83634c22b6a9149aa8787e45c3b7cd6c88b5958';

abstract class _$A5 extends BuildlessAutoDisposeAsyncNotifier<int> {
  late final int param;

  FutureOr<int> build(
    int param,
  );
}

/// See also [A5].
@ProviderFor(A5)
const a5Provider = A5Family();

/// See also [A5].
class A5Family extends Family<AsyncValue<int>> {
  /// See also [A5].
  const A5Family();

  /// See also [A5].
  A5Provider call(
    int param,
  ) {
    return A5Provider(
      param,
    );
  }

  @override
  A5Provider getProviderOverride(
    covariant A5Provider provider,
  ) {
    return call(
      provider.param,
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
  String? get name => r'a5Provider';
}

/// See also [A5].
class A5Provider extends AutoDisposeAsyncNotifierProviderImpl<A5, int> {
  /// See also [A5].
  A5Provider(
    int param,
  ) : this._internal(
          () => A5()..param = param,
          from: a5Provider,
          name: r'a5Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$a5Hash,
          dependencies: A5Family._dependencies,
          allTransitiveDependencies: A5Family._allTransitiveDependencies,
          param: param,
        );

  A5Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.param,
  }) : super.internal();

  final int param;

  @override
  FutureOr<int> runNotifierBuild(
    covariant A5 notifier,
  ) {
    return notifier.build(
      param,
    );
  }

  @override
  Override overrideWith(A5 Function() create) {
    return ProviderOverride(
      origin: this,
      override: A5Provider._internal(
        () => create()..param = param,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        param: param,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<A5, int> createElement() {
    return _A5ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is A5Provider && other.param == param;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, param.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin A5Ref on AutoDisposeAsyncNotifierProviderRef<int> {
  /// The parameter `param` of this provider.
  int get param;
}

class _A5ProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<A5, int> with A5Ref {
  _A5ProviderElement(super.provider);

  @override
  int get param => (origin as A5Provider).param;
}

String _$a6Hash() => r'fe641c72cacf3dd119eb77a34fe8fc71c5c30139';

abstract class _$A6 extends BuildlessAsyncNotifier<int> {
  late final int param;

  FutureOr<int> build(
    int param,
  );
}

/// See also [A6].
@ProviderFor(A6)
const a6Provider = A6Family();

/// See also [A6].
class A6Family extends Family<AsyncValue<int>> {
  /// See also [A6].
  const A6Family();

  /// See also [A6].
  A6Provider call(
    int param,
  ) {
    return A6Provider(
      param,
    );
  }

  @override
  A6Provider getProviderOverride(
    covariant A6Provider provider,
  ) {
    return call(
      provider.param,
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
  String? get name => r'a6Provider';
}

/// See also [A6].
class A6Provider extends AsyncNotifierProviderImpl<A6, int> {
  /// See also [A6].
  A6Provider(
    int param,
  ) : this._internal(
          () => A6()..param = param,
          from: a6Provider,
          name: r'a6Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$a6Hash,
          dependencies: A6Family._dependencies,
          allTransitiveDependencies: A6Family._allTransitiveDependencies,
          param: param,
        );

  A6Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.param,
  }) : super.internal();

  final int param;

  @override
  FutureOr<int> runNotifierBuild(
    covariant A6 notifier,
  ) {
    return notifier.build(
      param,
    );
  }

  @override
  Override overrideWith(A6 Function() create) {
    return ProviderOverride(
      origin: this,
      override: A6Provider._internal(
        () => create()..param = param,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        param: param,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<A6, int> createElement() {
    return _A6ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is A6Provider && other.param == param;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, param.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin A6Ref on AsyncNotifierProviderRef<int> {
  /// The parameter `param` of this provider.
  int get param;
}

class _A6ProviderElement extends AsyncNotifierProviderElement<A6, int>
    with A6Ref {
  _A6ProviderElement(super.provider);

  @override
  int get param => (origin as A6Provider).param;
}

String _$a7Hash() => r'd3d9ab5090e21987d65522f14ebb70d0058fc56a';

abstract class _$A7 extends BuildlessAutoDisposeStreamNotifier<int> {
  late final int param;

  Stream<int> build(
    int param,
  );
}

/// See also [A7].
@ProviderFor(A7)
const a7Provider = A7Family();

/// See also [A7].
class A7Family extends Family<AsyncValue<int>> {
  /// See also [A7].
  const A7Family();

  /// See also [A7].
  A7Provider call(
    int param,
  ) {
    return A7Provider(
      param,
    );
  }

  @override
  A7Provider getProviderOverride(
    covariant A7Provider provider,
  ) {
    return call(
      provider.param,
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
  String? get name => r'a7Provider';
}

/// See also [A7].
class A7Provider extends AutoDisposeStreamNotifierProviderImpl<A7, int> {
  /// See also [A7].
  A7Provider(
    int param,
  ) : this._internal(
          () => A7()..param = param,
          from: a7Provider,
          name: r'a7Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$a7Hash,
          dependencies: A7Family._dependencies,
          allTransitiveDependencies: A7Family._allTransitiveDependencies,
          param: param,
        );

  A7Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.param,
  }) : super.internal();

  final int param;

  @override
  Stream<int> runNotifierBuild(
    covariant A7 notifier,
  ) {
    return notifier.build(
      param,
    );
  }

  @override
  Override overrideWith(A7 Function() create) {
    return ProviderOverride(
      origin: this,
      override: A7Provider._internal(
        () => create()..param = param,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        param: param,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<A7, int> createElement() {
    return _A7ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is A7Provider && other.param == param;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, param.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin A7Ref on AutoDisposeStreamNotifierProviderRef<int> {
  /// The parameter `param` of this provider.
  int get param;
}

class _A7ProviderElement
    extends AutoDisposeStreamNotifierProviderElement<A7, int> with A7Ref {
  _A7ProviderElement(super.provider);

  @override
  int get param => (origin as A7Provider).param;
}

String _$a8Hash() => r'54f4a841a283161bed3d444dcee53bf367958678';

abstract class _$A8 extends BuildlessStreamNotifier<int> {
  late final int param;

  Stream<int> build(
    int param,
  );
}

/// See also [A8].
@ProviderFor(A8)
const a8Provider = A8Family();

/// See also [A8].
class A8Family extends Family<AsyncValue<int>> {
  /// See also [A8].
  const A8Family();

  /// See also [A8].
  A8Provider call(
    int param,
  ) {
    return A8Provider(
      param,
    );
  }

  @override
  A8Provider getProviderOverride(
    covariant A8Provider provider,
  ) {
    return call(
      provider.param,
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
  String? get name => r'a8Provider';
}

/// See also [A8].
class A8Provider extends StreamNotifierProviderImpl<A8, int> {
  /// See also [A8].
  A8Provider(
    int param,
  ) : this._internal(
          () => A8()..param = param,
          from: a8Provider,
          name: r'a8Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$a8Hash,
          dependencies: A8Family._dependencies,
          allTransitiveDependencies: A8Family._allTransitiveDependencies,
          param: param,
        );

  A8Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.param,
  }) : super.internal();

  final int param;

  @override
  Stream<int> runNotifierBuild(
    covariant A8 notifier,
  ) {
    return notifier.build(
      param,
    );
  }

  @override
  Override overrideWith(A8 Function() create) {
    return ProviderOverride(
      origin: this,
      override: A8Provider._internal(
        () => create()..param = param,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        param: param,
      ),
    );
  }

  @override
  StreamNotifierProviderElement<A8, int> createElement() {
    return _A8ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is A8Provider && other.param == param;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, param.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin A8Ref on StreamNotifierProviderRef<int> {
  /// The parameter `param` of this provider.
  int get param;
}

class _A8ProviderElement extends StreamNotifierProviderElement<A8, int>
    with A8Ref {
  _A8ProviderElement(super.provider);

  @override
  int get param => (origin as A8Provider).param;
}

String _$bHash() => r'44288285e9c28f846d609ba892520f577ecf7867';

/// See also [B].
@ProviderFor(B)
final bProvider = NotifierProvider<B, int>.internal(
  B.new,
  name: r'bProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$B = Notifier<int>;
String _$b2Hash() => r'292925c285c6975ed6585d541c5a9ae18977d73c';

/// See also [B2].
@ProviderFor(B2)
final b2Provider = AutoDisposeNotifierProvider<B2, int>.internal(
  B2.new,
  name: r'b2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$b2Hash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$B2 = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
