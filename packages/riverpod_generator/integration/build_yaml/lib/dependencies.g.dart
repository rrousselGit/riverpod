// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$calc2Hash() => r'ae1d601ff7cdda569255e8014bd5d8d1c178b3eb';

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

/// See also [calc2].
@ProviderFor(calc2)
const myFamilyCalc2ProviderFamily = Calc2Family();

/// See also [calc2].
class Calc2Family extends Family<int> {
  /// See also [calc2].
  const Calc2Family();

  /// See also [calc2].
  Calc2Provider call(
    String id,
  ) {
    return Calc2Provider(
      id,
    );
  }

  @override
  Calc2Provider getProviderOverride(
    covariant Calc2Provider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>{
    myCountPod,
    myCountFuturePod,
    myCountStreamPod,
    myCountNotifierPod,
    myCountAsyncNotifierPod,
    myCountStreamNotifierPod,
    myFamilyCount2ProviderFamily,
    myFamilyCountFuture2ProviderFamily,
    myFamilyCountStream2ProviderFamily,
    myFamilyCountNotifier2ProviderFamily,
    myFamilyCountAsyncNotifier2ProviderFamily,
    myFamilyCountStreamNotifier2ProviderFamily
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    myCountPod,
    ...?myCountPod.allTransitiveDependencies,
    myCountFuturePod,
    ...?myCountFuturePod.allTransitiveDependencies,
    myCountStreamPod,
    ...?myCountStreamPod.allTransitiveDependencies,
    myCountNotifierPod,
    ...?myCountNotifierPod.allTransitiveDependencies,
    myCountAsyncNotifierPod,
    ...?myCountAsyncNotifierPod.allTransitiveDependencies,
    myCountStreamNotifierPod,
    ...?myCountStreamNotifierPod.allTransitiveDependencies,
    myFamilyCount2ProviderFamily,
    ...?myFamilyCount2ProviderFamily.allTransitiveDependencies,
    myFamilyCountFuture2ProviderFamily,
    ...?myFamilyCountFuture2ProviderFamily.allTransitiveDependencies,
    myFamilyCountStream2ProviderFamily,
    ...?myFamilyCountStream2ProviderFamily.allTransitiveDependencies,
    myFamilyCountNotifier2ProviderFamily,
    ...?myFamilyCountNotifier2ProviderFamily.allTransitiveDependencies,
    myFamilyCountAsyncNotifier2ProviderFamily,
    ...?myFamilyCountAsyncNotifier2ProviderFamily.allTransitiveDependencies,
    myFamilyCountStreamNotifier2ProviderFamily,
    ...?myFamilyCountStreamNotifier2ProviderFamily.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'myFamilyCalc2ProviderFamily';
}

/// See also [calc2].
class Calc2Provider extends AutoDisposeProvider<int> {
  /// See also [calc2].
  Calc2Provider(
    String id,
  ) : this._internal(
          (ref) => calc2(
            ref as Calc2Ref,
            id,
          ),
          from: myFamilyCalc2ProviderFamily,
          name: r'myFamilyCalc2ProviderFamily',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$calc2Hash,
          dependencies: Calc2Family._dependencies,
          allTransitiveDependencies: Calc2Family._allTransitiveDependencies,
          id: id,
        );

  Calc2Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    int Function(Calc2Ref provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: Calc2Provider._internal(
        (ref) => create(ref as Calc2Ref),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _Calc2ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is Calc2Provider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin Calc2Ref on AutoDisposeProviderRef<int> {
  /// The parameter `id` of this provider.
  String get id;
}

class _Calc2ProviderElement extends AutoDisposeProviderElement<int>
    with Calc2Ref {
  _Calc2ProviderElement(super.provider);

  @override
  String get id => (origin as Calc2Provider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
