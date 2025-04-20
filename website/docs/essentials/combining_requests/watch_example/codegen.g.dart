// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(location)
const locationProvider = LocationProvider._();

final class LocationProvider extends $FunctionalProvider<
        AsyncValue<({double longitude, double latitude})>,
        Stream<({double longitude, double latitude})>>
    with
        $FutureModifier<({double longitude, double latitude})>,
        $StreamProvider<({double longitude, double latitude})> {
  const LocationProvider._(
      {Stream<({double longitude, double latitude})> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'locationProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<({double longitude, double latitude})> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$locationHash();

  @$internal
  @override
  $StreamProviderElement<({double longitude, double latitude})> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(this, pointer);

  @override
  LocationProvider $copyWithCreate(
    Stream<({double longitude, double latitude})> Function(
      Ref ref,
    ) create,
  ) {
    return LocationProvider._(create: create);
  }

  @override
  Stream<({double longitude, double latitude})> create(Ref ref) {
    final _$cb = _createCb ?? location;
    return _$cb(ref);
  }
}

String _$locationHash() => r'39328e5d0ec2b97acec14f1aba6c8db3f24f46a8';

@ProviderFor(restaurantsNearMe)
const restaurantsNearMeProvider = RestaurantsNearMeProvider._();

final class RestaurantsNearMeProvider extends $FunctionalProvider<
        AsyncValue<List<String>>, FutureOr<List<String>>>
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  const RestaurantsNearMeProvider._(
      {FutureOr<List<String>> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'restaurantsNearMeProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<List<String>> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$restaurantsNearMeHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  RestaurantsNearMeProvider $copyWithCreate(
    FutureOr<List<String>> Function(
      Ref ref,
    ) create,
  ) {
    return RestaurantsNearMeProvider._(create: create);
  }

  @override
  FutureOr<List<String>> create(Ref ref) {
    final _$cb = _createCb ?? restaurantsNearMe;
    return _$cb(ref);
  }
}

String _$restaurantsNearMeHash() => r'f577a4362db45208cd34f499d73f39f284807d13';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
