// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef CityRef = Ref<String>;

@ProviderFor(city)
const cityProvider = CityProvider._();

final class CityProvider extends $FunctionalProvider<String, String, CityRef>
    with $Provider<String, CityRef> {
  const CityProvider._(
      {String Function(
        CityRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
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
  $ProviderElement<String> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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

String _$cityHash() => r'2ccdee096b5d5c1cafa736b3e52b788431b9af38';

typedef WeatherRef = Ref<AsyncValue<Weather>>;

@ProviderFor(weather)
const weatherProvider = WeatherProvider._();

final class WeatherProvider extends $FunctionalProvider<AsyncValue<Weather>,
        FutureOr<Weather>, WeatherRef>
    with $FutureModifier<Weather>, $FutureProvider<Weather, WeatherRef> {
  const WeatherProvider._(
      {FutureOr<Weather> Function(
        WeatherRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
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
  $FutureProviderElement<Weather> $createElement(ProviderContainer container) =>
      $FutureProviderElement(this, container);

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

String _$weatherHash() => r'9a79d0269032630918eef9d3f562ff35b5860061';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
