// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family_class.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exampleHash() => r'c81e9d94e763b25403ab6b7fa03f092003570142';

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

abstract class _$Example extends BuildlessAutoDisposeNotifier<String> {
  late final int param1;
  late final String param2;

  String build(
    int param1, {
    String param2 = 'foo',
  });
}

/// See also [Example].
@ProviderFor(Example)
const exampleProvider = ExampleFamily();

/// See also [Example].
class ExampleFamily extends Family<String> {
  /// See also [Example].
  const ExampleFamily();

  /// See also [Example].
  ExampleProvider call(
    int param1, {
    String param2 = 'foo',
  }) {
    return ExampleProvider(
      param1,
      param2: param2,
    );
  }

  @override
  ExampleProvider getProviderOverride(
    covariant ExampleProvider provider,
  ) {
    return call(
      provider.param1,
      param2: provider.param2,
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
  String? get name => r'exampleProvider';
}

/// See also [Example].
class ExampleProvider extends AutoDisposeNotifierProviderImpl<Example, String> {
  /// See also [Example].
  ExampleProvider(
    int param1, {
    String param2 = 'foo',
  }) : this._internal(
          () => Example()
            ..param1 = param1
            ..param2 = param2,
          from: exampleProvider,
          name: r'exampleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exampleHash,
          dependencies: ExampleFamily._dependencies,
          allTransitiveDependencies: ExampleFamily._allTransitiveDependencies,
          param1: param1,
          param2: param2,
        );

  ExampleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.param1,
    required this.param2,
  }) : super.internal();

  final int param1;
  final String param2;

  @override
  String runNotifierBuild(
    covariant Example notifier,
  ) {
    return notifier.build(
      param1,
      param2: param2,
    );
  }

  @override
  Override overrideWith(Example Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExampleProvider._internal(
        () => create()
          ..param1 = param1
          ..param2 = param2,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        param1: param1,
        param2: param2,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Example, String> createElement() {
    return _ExampleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExampleProvider &&
        other.param1 == param1 &&
        other.param2 == param2;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, param1.hashCode);
    hash = _SystemHash.combine(hash, param2.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ExampleRef on AutoDisposeNotifierProviderRef<String> {
  /// The parameter `param1` of this provider.
  int get param1;

  /// The parameter `param2` of this provider.
  String get param2;
}

class _ExampleProviderElement
    extends AutoDisposeNotifierProviderElement<Example, String>
    with ExampleRef {
  _ExampleProviderElement(super.provider);

  @override
  int get param1 => (origin as ExampleProvider).param1;
  @override
  String get param2 => (origin as ExampleProvider).param2;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
