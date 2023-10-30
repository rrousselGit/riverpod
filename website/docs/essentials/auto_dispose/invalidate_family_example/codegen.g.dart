// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$labelHash() => r'20aa8ce0231205540f466f91259732bd86953c64';

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

/// See also [label].
@ProviderFor(label)
const labelProvider = LabelFamily();

/// See also [label].
class LabelFamily extends Family<String> {
  /// See also [label].
  const LabelFamily();

  /// See also [label].
  LabelProvider call(
    String userName,
  ) {
    return LabelProvider(
      userName,
    );
  }

  @override
  LabelProvider getProviderOverride(
    covariant LabelProvider provider,
  ) {
    return call(
      provider.userName,
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
  String? get name => r'labelProvider';
}

/// See also [label].
class LabelProvider extends AutoDisposeProvider<String> {
  /// See also [label].
  LabelProvider(
    String userName,
  ) : this._internal(
          (ref) => label(
            ref as LabelRef,
            userName,
          ),
          from: labelProvider,
          name: r'labelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$labelHash,
          dependencies: LabelFamily._dependencies,
          allTransitiveDependencies: LabelFamily._allTransitiveDependencies,
          userName: userName,
        );

  LabelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userName,
  }) : super.internal();

  final String userName;

  @override
  Override overrideWith(
    String Function(LabelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LabelProvider._internal(
        (ref) => create(ref as LabelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userName: userName,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _LabelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LabelProvider && other.userName == userName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LabelRef on AutoDisposeProviderRef<String> {
  /// The parameter `userName` of this provider.
  String get userName;
}

class _LabelProviderElement extends AutoDisposeProviderElement<String>
    with LabelRef {
  _LabelProviderElement(super.provider);

  @override
  String get userName => (origin as LabelProvider).userName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
