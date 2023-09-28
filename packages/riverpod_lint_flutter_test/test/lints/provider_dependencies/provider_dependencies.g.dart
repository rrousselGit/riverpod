// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$depHash() => r'749c4d696d29c72686cabcabd6fa7855f5cbf4db';

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

typedef DepRef = AutoDisposeProviderRef<int>;
String _$dep2Hash() => r'13cd909366c79168e3d9cd95f529ddbcee6de7dc';

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

typedef Dep2Ref = AutoDisposeProviderRef<int>;
String _$plainAnnotationHash() =>
    r'ceeb01dfcbd115f3676c8e38ce35a03cff16246b'; ////////////
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

typedef PlainAnnotationRef = AutoDisposeProviderRef<int>;
String _$customAnnotationHash() => r'04faed9b424be360e594870f91c4ef4689f05672';

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

typedef CustomAnnotationRef = AutoDisposeProviderRef<int>;
String _$customAnnotationWithTrailingCommaHash() =>
    r'b5c62d769dfc53d6d77e8fde9e0eb7d8a0ab9d18';

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

typedef CustomAnnotationWithTrailingCommaRef = AutoDisposeProviderRef<int>;
String _$existingDepHash() => r'8d7866d1af7e350d7c792e43a542cd47b130b239';

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

typedef ExistingDepRef = AutoDisposeProviderRef<int>;
String _$multipleDepsHash() => r'9d08791636a0435ba115062a453d0d9e530ecf71';

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

typedef MultipleDepsRef = AutoDisposeProviderRef<int>;
String _$extraDepHash() => r'038d9c819b5d91eb1f7166194d8e646f17ea24d7';

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

typedef ExtraDepRef = AutoDisposeProviderRef<int>;
String _$noDepHash() => r'38d78ded1eba491968c0200cc0b51969fcf3ec9a';

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

typedef NoDepRef = AutoDisposeProviderRef<int>;
String _$dependenciesFirstThenKeepAliveHash() =>
    r'15604dafd167408515dfb4e846fab0af46e7e566';

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

typedef DependenciesFirstThenKeepAliveRef = AutoDisposeProviderRef<int>;
String _$noDepNoParamHash() => r'fe52f15a4d98159beafe8b9a177073f6b6cbae6d';

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

typedef NoDepNoParamRef = AutoDisposeProviderRef<int>;
String _$noDepWithoutCommaHash() => r'59d5a7874da40605b1b187766ebb4927d2eaae81';

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

typedef NoDepWithoutCommaRef = AutoDisposeProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
