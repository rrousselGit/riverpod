// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$depHash() => r'578a350a40cda46444ecd9fa3ea2fd7bd0994692';

/// See also [dep].
@ProviderFor(dep)
final depProvider = AutoDisposeProvider<int>.internal(
  dep,
  name: r'depProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$depHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DepRef = AutoDisposeProviderRef<int>;
String _$dep2Hash() => r'97901e825cdcf5b1ac455b0fe8a2111662ce9f13';

/// See also [dep2].
@ProviderFor(dep2)
final dep2Provider = AutoDisposeProvider<int>.internal(
  dep2,
  name: r'dep2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dep2Hash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef Dep2Ref = AutoDisposeProviderRef<int>;
String _$dep3Hash() => r'bb6a5b0a89055bc25a5edfd22f8674cf8b1ce771';

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

/// See also [dep3].
@ProviderFor(dep3)
const dep3Provider = Dep3Family();

/// See also [dep3].
class Dep3Family extends Family<int> {
  /// See also [dep3].
  const Dep3Family();

  /// See also [dep3].
  Dep3Provider call(
    int parameter,
  ) {
    return Dep3Provider(
      parameter,
    );
  }

  @override
  Dep3Provider getProviderOverride(
    covariant Dep3Provider provider,
  ) {
    return call(
      provider.parameter,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies =
      const <ProviderOrFamily>[];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      const <ProviderOrFamily>{};

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dep3Provider';
}

/// See also [dep3].
class Dep3Provider extends AutoDisposeProvider<int> {
  /// See also [dep3].
  Dep3Provider(
    int parameter,
  ) : this._internal(
          (ref) => dep3(
            ref as Dep3Ref,
            parameter,
          ),
          from: dep3Provider,
          name: r'dep3Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$dep3Hash,
          dependencies: Dep3Family._dependencies,
          allTransitiveDependencies: Dep3Family._allTransitiveDependencies,
          parameter: parameter,
        );

  Dep3Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parameter,
  }) : super.internal();

  final int parameter;

  @override
  Override overrideWith(
    int Function(Dep3Ref provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: Dep3Provider._internal(
        (ref) => create(ref as Dep3Ref),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parameter: parameter,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _Dep3ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is Dep3Provider && other.parameter == parameter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parameter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin Dep3Ref on AutoDisposeProviderRef<int> {
  /// The parameter `parameter` of this provider.
  int get parameter;
}

class _Dep3ProviderElement extends AutoDisposeProviderElement<int>
    with Dep3Ref {
  _Dep3ProviderElement(super.provider);

  @override
  int get parameter => (origin as Dep3Provider).parameter;
}

String _$plainAnnotationHash() =>
    r'6a3d1f1f2e53902af56cd7ce6ceba17358690b70'; ////////////
///
/// Copied from [plainAnnotation].
@ProviderFor(plainAnnotation)
final plainAnnotationProvider = AutoDisposeProvider<int>.internal(
  plainAnnotation,
  name: r'plainAnnotationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$plainAnnotationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlainAnnotationRef = AutoDisposeProviderRef<int>;
String _$customAnnotationHash() => r'8081bbad2cfbe5bff1ace9aa3be450dd28112488';

/// See also [customAnnotation].
@ProviderFor(customAnnotation)
final customAnnotationProvider = AutoDisposeProvider<int>.internal(
  customAnnotation,
  name: r'customAnnotationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customAnnotationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CustomAnnotationRef = AutoDisposeProviderRef<int>;
String _$customAnnotationWithTrailingCommaHash() =>
    r'709613050eb1db7b4c43cb87855e2c32988141d8';

/// See also [customAnnotationWithTrailingComma].
@ProviderFor(customAnnotationWithTrailingComma)
final customAnnotationWithTrailingCommaProvider =
    AutoDisposeProvider<int>.internal(
  customAnnotationWithTrailingComma,
  name: r'customAnnotationWithTrailingCommaProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customAnnotationWithTrailingCommaHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CustomAnnotationWithTrailingCommaRef = AutoDisposeProviderRef<int>;
String _$existingDepHash() => r'73e7e1a0d4c2ae07ed03fb248408c3d82fe85554';

/// See also [existingDep].
@ProviderFor(existingDep)
final existingDepProvider = AutoDisposeProvider<int>.internal(
  existingDep,
  name: r'existingDepProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$existingDepHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExistingDepRef = AutoDisposeProviderRef<int>;
String _$multipleDepsHash() => r'66de70567c011a294a2c46703dfab8ba7247fd5e';

/// See also [multipleDeps].
@ProviderFor(multipleDeps)
final multipleDepsProvider = AutoDisposeProvider<int>.internal(
  multipleDeps,
  name: r'multipleDepsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$multipleDepsHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MultipleDepsRef = AutoDisposeProviderRef<int>;
String _$extraDepHash() => r'586c1a0f0ac120f8608c025a6a47fe5282b80320';

/// See also [extraDep].
@ProviderFor(extraDep)
final extraDepProvider = AutoDisposeProvider<int>.internal(
  extraDep,
  name: r'extraDepProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$extraDepHash,
  dependencies: <ProviderOrFamily>[depProvider, dep2Provider],
  allTransitiveDependencies: <ProviderOrFamily>{
    depProvider,
    ...?depProvider.allTransitiveDependencies,
    dep2Provider,
    ...?dep2Provider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExtraDepRef = AutoDisposeProviderRef<int>;
String _$onFamilyDepHash() => r'ad04da6286b3475658b531d9a7dd8a47f11c56f2';

/// See also [onFamilyDep].
@ProviderFor(onFamilyDep)
final onFamilyDepProvider = AutoDisposeProvider<int>.internal(
  onFamilyDep,
  name: r'onFamilyDepProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$onFamilyDepHash,
  dependencies: <ProviderOrFamily>[dep3Provider],
  allTransitiveDependencies: <ProviderOrFamily>{
    dep3Provider,
    ...?dep3Provider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OnFamilyDepRef = AutoDisposeProviderRef<int>;
String _$noDepHash() => r'99022366e7dd3e19464747d1e2f23184691aa134';

/// See also [noDep].
@ProviderFor(noDep)
final noDepProvider = AutoDisposeProvider<int>.internal(
  noDep,
  name: r'noDepProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$noDepHash,
  dependencies: <ProviderOrFamily>[depProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    depProvider,
    ...?depProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NoDepRef = AutoDisposeProviderRef<int>;
String _$dependenciesFirstThenKeepAliveHash() =>
    r'b9bd9082ce9a72feea33f9327b26e7b428cadfd3';

/// See also [dependenciesFirstThenKeepAlive].
@ProviderFor(dependenciesFirstThenKeepAlive)
final dependenciesFirstThenKeepAliveProvider =
    AutoDisposeProvider<int>.internal(
  dependenciesFirstThenKeepAlive,
  name: r'dependenciesFirstThenKeepAliveProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dependenciesFirstThenKeepAliveHash,
  dependencies: <ProviderOrFamily>[depProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    depProvider,
    ...?depProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DependenciesFirstThenKeepAliveRef = AutoDisposeProviderRef<int>;
String _$noDepNoParamHash() => r'ea3e66e28bbfb716adf89cea37a1607c78283e06';

/// See also [noDepNoParam].
@ProviderFor(noDepNoParam)
final noDepNoParamProvider = AutoDisposeProvider<int>.internal(
  noDepNoParam,
  name: r'noDepNoParamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$noDepNoParamHash,
  dependencies: <ProviderOrFamily>[depProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    depProvider,
    ...?depProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NoDepNoParamRef = AutoDisposeProviderRef<int>;
String _$noDepWithoutCommaHash() => r'a3b07e526b4829ee4ed1848de4ff64c3b05c1a30';

/// See also [noDepWithoutComma].
@ProviderFor(noDepWithoutComma)
final noDepWithoutCommaProvider = AutoDisposeProvider<int>.internal(
  noDepWithoutComma,
  name: r'noDepWithoutCommaProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noDepWithoutCommaHash,
  dependencies: <ProviderOrFamily>[depProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    depProvider,
    ...?depProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NoDepWithoutCommaRef = AutoDisposeProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
