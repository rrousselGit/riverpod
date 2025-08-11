// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(location)
const locationProvider = LocationProvider._();

final class LocationProvider extends $FunctionalProvider<
        AsyncValue<
            ({
              double latitude,
              double longitude,
            })>,
        ({
          double latitude,
          double longitude,
        }),
        Stream<
            ({
              double latitude,
              double longitude,
            })>>
    with
        $FutureModifier<
            ({
              double latitude,
              double longitude,
            })>,
        $StreamProvider<
            ({
              double latitude,
              double longitude,
            })> {
  const LocationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'locationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$locationHash();

  @$internal
  @override
  $StreamProviderElement<
      ({
        double latitude,
        double longitude,
      })> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<
      ({
        double latitude,
        double longitude,
      })> create(Ref ref) {
    return location(ref);
  }
}

String _$locationHash() => r'39328e5d0ec2b97acec14f1aba6c8db3f24f46a8';

@ProviderFor(restaurantsNearMe)
const restaurantsNearMeProvider = RestaurantsNearMeProvider._();

final class RestaurantsNearMeProvider extends $FunctionalProvider<
        AsyncValue<List<String>>, List<String>, FutureOr<List<String>>>
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  const RestaurantsNearMeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'restaurantsNearMeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$restaurantsNearMeHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return restaurantsNearMe(ref);
  }
}

String _$restaurantsNearMeHash() => r'f577a4362db45208cd34f499d73f39f284807d13';
