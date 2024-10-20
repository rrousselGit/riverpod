// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationHash() => r'39328e5d0ec2b97acec14f1aba6c8db3f24f46a8';

/// See also [location].
@ProviderFor(location)
final locationProvider =
    AutoDisposeStreamProvider<({double longitude, double latitude})>.internal(
  location,
  name: r'locationProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$locationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationRef
    = AutoDisposeStreamProviderRef<({double longitude, double latitude})>;
String _$restaurantsNearMeHash() => r'f577a4362db45208cd34f499d73f39f284807d13';

/// See also [restaurantsNearMe].
@ProviderFor(restaurantsNearMe)
final restaurantsNearMeProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  restaurantsNearMe,
  name: r'restaurantsNearMeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$restaurantsNearMeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RestaurantsNearMeRef = AutoDisposeFutureProviderRef<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
