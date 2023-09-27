// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avoid_passing_build_context_to_providers.dart';

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

String _$myNotifierHash() => r'82f0f308fc9cdfb483d40e6264e47714e81d0c79';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
