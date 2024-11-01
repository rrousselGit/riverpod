// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef CityRef = Ref<String>;

@ProviderFor(city)
const cityProvider = CityProvider._();

final class CityProvider extends $FunctionalProvider<String, String>
    with $Provider<String, CityRef> {
  const CityProvider._(
      {String Function(
        CityRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'cityProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    CityRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$cityHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  CityProvider $copyWithCreate(
    String Function(
      CityRef ref,
    ) create,
  ) {
    return CityProvider._(create: create);
  }

  @override
  String create(CityRef ref) {
    final _$cb = _createCb ?? city;
    return _$cb(ref);
  }
}

String _$cityHash() => r'6a5023a3aba119f1ecaee6c7db44b3f519e72759';

typedef WeatherRef = Ref<AsyncValue<Weather>>;

@ProviderFor(weather)
const weatherProvider = WeatherProvider._();

final class WeatherProvider
    extends $FunctionalProvider<AsyncValue<Weather>, FutureOr<Weather>>
    with $FutureModifier<Weather>, $FutureProvider<Weather, WeatherRef> {
  const WeatherProvider._(
      {FutureOr<Weather> Function(
        WeatherRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'weatherProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<Weather> Function(
    WeatherRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$weatherHash();

  @$internal
  @override
  $FutureProviderElement<Weather> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  WeatherProvider $copyWithCreate(
    FutureOr<Weather> Function(
      WeatherRef ref,
    ) create,
  ) {
    return WeatherProvider._(create: create);
  }

  @override
  FutureOr<Weather> create(WeatherRef ref) {
    final _$cb = _createCb ?? weather;
    return _$cb(ref);
  }
}

String _$weatherHash() => r'277f005f0a4ea0bc28eaa4bc6628ba2a5d1034c8';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
