// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationHash() => r'22e666f1e1ce04ce03d8f8d5652e25b54c1d1af3';

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

typedef LocationRef
    = AutoDisposeStreamProviderRef<({double longitude, double latitude})>;
String _$restaurantsNearMeHash() => r'dd49cc1e6f16abb34dd15286d171e322c06b93b8';

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

typedef RestaurantsNearMeRef = AutoDisposeFutureProviderRef<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
