// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoped_providers_should_specify_dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scopedHash() => r'5a271e9b23e18517694454448b922a6c9d03781e';

/// See also [scoped].
@ProviderFor(scoped)
final scopedProvider = AutoDisposeProvider<int>.internal(
  scoped,
  name: r'scopedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scopedHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScopedRef = AutoDisposeProviderRef<int>;
String _$unimplementedScopedHash() =>
    r'5f32fc56f4157238612d62ef54038fe92b7cdfe8';

/// See also [unimplementedScoped].
@ProviderFor(unimplementedScoped)
final unimplementedScopedProvider = AutoDisposeProvider<int>.internal(
  (_) => throw UnsupportedError(
    'The provider "unimplementedScopedProvider" is expected to get overridden/scoped, '
    'but was accessed without an override.',
  ),
  name: r'unimplementedScopedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unimplementedScopedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnimplementedScopedRef = AutoDisposeProviderRef<int>;
String _$rootHash() => r'dda8bbb46cb4d7c658597669e3be92e2447dcfb0';

/// See also [root].
@ProviderFor(root)
final rootProvider = AutoDisposeProvider<int>.internal(
  root,
  name: r'rootProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rootHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RootRef = AutoDisposeProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
