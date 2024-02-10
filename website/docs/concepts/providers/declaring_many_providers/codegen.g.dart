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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
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

typedef CountryRef = Ref<String>;

@ProviderFor(country)
const countryProvider = CountryProvider._();

final class CountryProvider
    extends $FunctionalProvider<String, String, CountryRef>
    with $Provider<String, CountryRef> {
  const CountryProvider._(
      {String Function(
        CountryRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'countryProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    CountryRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countryHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  CountryProvider $copyWithCreate(
    String Function(
      CountryRef ref,
    ) create,
  ) {
    return CountryProvider._(create: create);
  }

  @override
  String create(CountryRef ref) {
    final _$cb = _createCb ?? country;
    return _$cb(ref);
  }
}

String _$countryHash() => r'd1513349c3bc0c99763cb4fb29eb012f2351bc4c';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
