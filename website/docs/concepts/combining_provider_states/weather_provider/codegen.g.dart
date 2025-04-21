// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(city)
const cityProvider = CityProvider._();

final class CityProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const CityProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cityProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cityHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return city(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }
}

String _$cityHash() => r'6a5023a3aba119f1ecaee6c7db44b3f519e72759';

@ProviderFor(weather)
const weatherProvider = WeatherProvider._();

final class WeatherProvider
    extends $FunctionalProvider<AsyncValue<Weather>, FutureOr<Weather>>
    with $FutureModifier<Weather>, $FutureProvider<Weather> {
  const WeatherProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'weatherProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$weatherHash();

  @$internal
  @override
  $FutureProviderElement<Weather> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Weather> create(Ref ref) {
    return weather(ref);
  }
}

String _$weatherHash() => r'277f005f0a4ea0bc28eaa4bc6628ba2a5d1034c8';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
