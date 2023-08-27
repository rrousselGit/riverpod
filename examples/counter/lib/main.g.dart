// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mapTestHash() => r'9237bec3efa862babc342486d916a2a73b3c3b4a';

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

abstract class _$MapTest extends BuildlessNotifier<Map<String, dynamic>> {
  late final String namespace;

  Map<String, dynamic> build({
    String namespace = 'abc',
  });
}

/// This provider is used to determine if mock data is used instead of making
/// API calls.
///
/// Copied from [MapTest].
@ProviderFor(MapTest)
const mapTestProvider = MapTestFamily();

/// This provider is used to determine if mock data is used instead of making
/// API calls.
///
/// Copied from [MapTest].
class MapTestFamily extends Family<Map<String, dynamic>> {
  /// This provider is used to determine if mock data is used instead of making
  /// API calls.
  ///
  /// Copied from [MapTest].
  const MapTestFamily();

  /// This provider is used to determine if mock data is used instead of making
  /// API calls.
  ///
  /// Copied from [MapTest].
  MapTestProvider call({
    String namespace = 'abc',
  }) {
    return MapTestProvider(
      namespace: namespace,
    );
  }

  @override
  MapTestProvider getProviderOverride(
    covariant MapTestProvider provider,
  ) {
    return call(
      namespace: provider.namespace,
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
  String? get name => r'mapTestProvider';
}

/// This provider is used to determine if mock data is used instead of making
/// API calls.
///
/// Copied from [MapTest].
class MapTestProvider
    extends NotifierProviderImpl<MapTest, Map<String, dynamic>> {
  /// This provider is used to determine if mock data is used instead of making
  /// API calls.
  ///
  /// Copied from [MapTest].
  MapTestProvider({
    String namespace = 'abc',
  }) : this._internal(
          () => MapTest()..namespace = namespace,
          from: mapTestProvider,
          name: r'mapTestProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mapTestHash,
          dependencies: MapTestFamily._dependencies,
          allTransitiveDependencies: MapTestFamily._allTransitiveDependencies,
          namespace: namespace,
        );

  MapTestProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.namespace,
  }) : super.internal();

  final String namespace;

  @override
  Map<String, dynamic> runNotifierBuild(
    covariant MapTest notifier,
  ) {
    return notifier.build(
      namespace: namespace,
    );
  }

  @override
  Override overrideWith(MapTest Function() create) {
    return ProviderOverride(
      origin: this,
      override: MapTestProvider._internal(
        create,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        namespace: namespace,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MapTestProvider && other.namespace == namespace;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, namespace.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
