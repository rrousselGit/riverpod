// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step2.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fnHash() => r'439909d1278559c9165335820904a15fda32eca8';

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

typedef FnRef = AutoDisposeProviderRef<String>;

/// See also [fn].
@ProviderFor(fn)
const fnProvider = FnFamily();

/// See also [fn].
class FnFamily extends Family<String> {
  /// See also [fn].
  const FnFamily();

  /// See also [fn].
  FnProvider call({
    required int id2,
  }) {
    return FnProvider(
      id2: id2,
    );
  }

  @override
  FnProvider getProviderOverride(
    covariant FnProvider provider,
  ) {
    return call(
      id2: provider.id2,
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

  @override
  Type get debugFamilyCallRuntimeType => call.runtimeType;
}

/// See also [fn].
class FnProvider extends AutoDisposeProvider<String> {
  /// See also [fn].
  FnProvider({
    required this.id2,
  }) : super.internal(
          (ref) => fn(
            ref,
            id2: id2,
          ),
          from: fnProvider,
          name: r'fnProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$fnHash,
          dependencies: FnFamily._dependencies,
          allTransitiveDependencies: FnFamily._allTransitiveDependencies,
          debugFamilyCallRuntimeType: fnProvider.debugFamilyCallRuntimeType,
        );

  final int id2;

  @override
  bool operator ==(Object other) {
    return other is FnProvider && other.id2 == id2;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id2.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
