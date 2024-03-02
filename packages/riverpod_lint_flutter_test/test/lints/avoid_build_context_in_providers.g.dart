// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avoid_build_context_in_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fnHash() => r'7b8d0cf179067c80b8553b3232fd886fac83f387';

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

/// See also [fn].
@ProviderFor(fn)
const fnProvider = FnFamily();

/// See also [fn].
class FnFamily extends Family<int> {
  /// See also [fn].
  const FnFamily();

  /// See also [fn].
  FnProvider call(
    BuildContext context1, {
    required BuildContext context2,
  }) {
    return FnProvider(
      context1,
      context2: context2,
    );
  }

  @override
  FnProvider getProviderOverride(
    covariant FnProvider provider,
  ) {
    return call(
      provider.context1,
      context2: provider.context2,
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
  String? get name => r'fnProvider';
}

/// See also [fn].
class FnProvider extends AutoDisposeProvider<int> {
  /// See also [fn].
  FnProvider(
    BuildContext context1, {
    required BuildContext context2,
  }) : this._internal(
          (ref) => fn(
            ref as FnRef,
            context1,
            context2: context2,
          ),
          from: fnProvider,
          name: r'fnProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$fnHash,
          dependencies: FnFamily._dependencies,
          allTransitiveDependencies: FnFamily._allTransitiveDependencies,
          context1: context1,
          context2: context2,
        );

  FnProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context1,
    required this.context2,
  }) : super.internal();

  final BuildContext context1;
  final BuildContext context2;

  @override
  Override overrideWith(
    int Function(FnRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FnProvider._internal(
        (ref) => create(ref as FnRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context1: context1,
        context2: context2,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _FnProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FnProvider &&
        other.context1 == context1 &&
        other.context2 == context2;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context1.hashCode);
    hash = _SystemHash.combine(hash, context2.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FnRef on AutoDisposeProviderRef<int> {
  /// The parameter `context1` of this provider.
  BuildContext get context1;

  /// The parameter `context2` of this provider.
  BuildContext get context2;
}

class _FnProviderElement extends AutoDisposeProviderElement<int> with FnRef {
  _FnProviderElement(super.provider);

  @override
  BuildContext get context1 => (origin as FnProvider).context1;
  @override
  BuildContext get context2 => (origin as FnProvider).context2;
}

String _$myNotifierHash() => r'04a0cf33dbda80e3fa80748fe46546b1c968da22';

abstract class _$MyNotifier extends BuildlessAutoDisposeNotifier<int> {
  late final BuildContext context1;
  late final BuildContext context2;

  int build(
    BuildContext context1, {
    required BuildContext context2,
  });
}

/// See also [MyNotifier].
@ProviderFor(MyNotifier)
const myNotifierProvider = MyNotifierFamily();

/// See also [MyNotifier].
class MyNotifierFamily extends Family<int> {
  /// See also [MyNotifier].
  const MyNotifierFamily();

  /// See also [MyNotifier].
  MyNotifierProvider call(
    BuildContext context1, {
    required BuildContext context2,
  }) {
    return MyNotifierProvider(
      context1,
      context2: context2,
    );
  }

  @override
  MyNotifierProvider getProviderOverride(
    covariant MyNotifierProvider provider,
  ) {
    return call(
      provider.context1,
      context2: provider.context2,
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
  String? get name => r'myNotifierProvider';
}

/// See also [MyNotifier].
class MyNotifierProvider
    extends AutoDisposeNotifierProviderImpl<MyNotifier, int> {
  /// See also [MyNotifier].
  MyNotifierProvider(
    BuildContext context1, {
    required BuildContext context2,
  }) : this._internal(
          () => MyNotifier()
            ..context1 = context1
            ..context2 = context2,
          from: myNotifierProvider,
          name: r'myNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myNotifierHash,
          dependencies: MyNotifierFamily._dependencies,
          allTransitiveDependencies:
              MyNotifierFamily._allTransitiveDependencies,
          context1: context1,
          context2: context2,
        );

  MyNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context1,
    required this.context2,
  }) : super.internal();

  final BuildContext context1;
  final BuildContext context2;

  @override
  int runNotifierBuild(
    covariant MyNotifier notifier,
  ) {
    return notifier.build(
      context1,
      context2: context2,
    );
  }

  @override
  Override overrideWith(MyNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MyNotifierProvider._internal(
        () => create()
          ..context1 = context1
          ..context2 = context2,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context1: context1,
        context2: context2,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MyNotifier, int> createElement() {
    return _MyNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyNotifierProvider &&
        other.context1 == context1 &&
        other.context2 == context2;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context1.hashCode);
    hash = _SystemHash.combine(hash, context2.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MyNotifierRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `context1` of this provider.
  BuildContext get context1;

  /// The parameter `context2` of this provider.
  BuildContext get context2;
}

class _MyNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<MyNotifier, int>
    with MyNotifierRef {
  _MyNotifierProviderElement(super.provider);

  @override
  BuildContext get context1 => (origin as MyNotifierProvider).context1;
  @override
  BuildContext get context2 => (origin as MyNotifierProvider).context2;
}

String _$regresion2959Hash() => r'bcf9a829ce75026a78569de680451d157c7d90a2';

/// See also [Regresion2959].
@ProviderFor(Regresion2959)
final regresion2959Provider =
    AutoDisposeNotifierProvider<Regresion2959, void>.internal(
  Regresion2959.new,
  name: r'regresion2959Provider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$regresion2959Hash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Regresion2959 = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
