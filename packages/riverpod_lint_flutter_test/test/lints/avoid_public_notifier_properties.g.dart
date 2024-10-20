// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avoid_public_notifier_properties.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$generatedNotifierHash() => r'2b7f4fba816b6e8ccd0e8b7d11fcd207bbb79828';

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

abstract class _$GeneratedNotifier extends BuildlessAutoDisposeNotifier<int> {
  late final int param;

  int build(
    int param,
  );
}

/// See also [GeneratedNotifier].
@ProviderFor(GeneratedNotifier)
const generatedNotifierProvider = GeneratedNotifierFamily();

/// See also [GeneratedNotifier].
class GeneratedNotifierFamily extends Family<int> {
  /// See also [GeneratedNotifier].
  const GeneratedNotifierFamily();

  /// See also [GeneratedNotifier].
  GeneratedNotifierProvider call(
    int param,
  ) {
    return GeneratedNotifierProvider(
      param,
    );
  }

  @override
  GeneratedNotifierProvider getProviderOverride(
    covariant GeneratedNotifierProvider provider,
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
  String? get name => r'generatedNotifierProvider';
}

/// See also [GeneratedNotifier].
class GeneratedNotifierProvider
    extends AutoDisposeNotifierProviderImpl<GeneratedNotifier, int> {
  /// See also [GeneratedNotifier].
  GeneratedNotifierProvider(
    int param,
  ) : this._internal(
          () => GeneratedNotifier()..param = param,
          from: generatedNotifierProvider,
          name: r'generatedNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generatedNotifierHash,
          dependencies: GeneratedNotifierFamily._dependencies,
          allTransitiveDependencies:
              GeneratedNotifierFamily._allTransitiveDependencies,
          param: param,
        );

  GeneratedNotifierProvider._internal(
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
    covariant GeneratedNotifier notifier,
  ) {
    return notifier.build(
      param,
    );
  }

  @override
  Override overrideWith(GeneratedNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: GeneratedNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<GeneratedNotifier, int> createElement() {
    return _GeneratedNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GeneratedNotifierProvider && other.param == param;
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
mixin GeneratedNotifierRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `param` of this provider.
  int get param;
}

class _GeneratedNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<GeneratedNotifier, int>
    with GeneratedNotifierRef {
  _GeneratedNotifierProviderElement(super.provider);

  @override
  int get param => (origin as GeneratedNotifierProvider).param;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
